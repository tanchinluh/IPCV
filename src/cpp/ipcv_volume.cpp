#define IPCV_CORE_EXPORTS
#include "ipcv_volume.h"

#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <vector>

namespace
{
struct Offset
{
    int dr;
    int dc;
    int dz;
};

void set_error(IpcvVolume *volume, const char *message)
{
    if (volume == NULL) return;
    std::strncpy(volume->error, message, sizeof(volume->error) - 1);
    volume->error[sizeof(volume->error) - 1] = 0;
}

size_t depth_size(int depth)
{
    switch (depth)
    {
    case IPCV_DEPTH_8U:
    case IPCV_DEPTH_8S: return 1;
    case IPCV_DEPTH_16U:
    case IPCV_DEPTH_16S: return 2;
    case IPCV_DEPTH_32S:
    case IPCV_DEPTH_32F: return 4;
    case IPCV_DEPTH_64F: return 8;
    default: return 0;
    }
}

size_t voxel_count(const IpcvVolume& volume)
{
    return static_cast<size_t>(volume.rows) * volume.cols * volume.slices;
}

size_t index_of(int row, int col, int slice, int rows, int cols)
{
    return static_cast<size_t>(row) +
        static_cast<size_t>(rows) * (col + static_cast<size_t>(cols) * slice);
}

void decode_index(size_t index, int rows, int cols, int& row, int& col, int& slice)
{
    const size_t plane = static_cast<size_t>(rows) * cols;
    slice = static_cast<int>(index / plane);
    const size_t within = index - static_cast<size_t>(slice) * plane;
    col = static_cast<int>(within / rows);
    row = static_cast<int>(within - static_cast<size_t>(col) * rows);
}

bool valid_volume(const IpcvVolume *volume)
{
    if (volume == NULL || volume->data == NULL ||
        volume->rows <= 0 || volume->cols <= 0 || volume->slices <= 0)
        return false;
    const size_t bytes = depth_size(volume->depth);
    return bytes != 0 && volume->byte_count == voxel_count(*volume) * bytes;
}

double read_value(const IpcvVolume& volume, size_t index)
{
    switch (volume.depth)
    {
    case IPCV_DEPTH_8U: return reinterpret_cast<const unsigned char*>(volume.data)[index];
    case IPCV_DEPTH_8S: return reinterpret_cast<const signed char*>(volume.data)[index];
    case IPCV_DEPTH_16U: return reinterpret_cast<const unsigned short*>(volume.data)[index];
    case IPCV_DEPTH_16S: return reinterpret_cast<const short*>(volume.data)[index];
    case IPCV_DEPTH_32S: return reinterpret_cast<const int*>(volume.data)[index];
    case IPCV_DEPTH_32F: return reinterpret_cast<const float*>(volume.data)[index];
    case IPCV_DEPTH_64F: return reinterpret_cast<const double*>(volume.data)[index];
    default: return 0.0;
    }
}

bool allocate_volume(IpcvVolume *volume, const IpcvVolume& source, int depth)
{
    std::memset(volume, 0, sizeof(*volume));
    volume->rows = source.rows;
    volume->cols = source.cols;
    volume->slices = source.slices;
    volume->depth = depth;
    volume->byte_count = voxel_count(source) * depth_size(depth);
    volume->data = static_cast<unsigned char*>(std::malloc(volume->byte_count));
    if (volume->data == NULL)
    {
        set_error(volume, "out of memory");
        return false;
    }
    volume->owns_data = 1;
    return true;
}

bool valid_connectivity(int connectivity)
{
    return connectivity == 6 || connectivity == 18 || connectivity == 26;
}

std::vector<Offset> offsets_for(int connectivity)
{
    std::vector<Offset> offsets;
    for (int dz = -1; dz <= 1; ++dz)
        for (int dc = -1; dc <= 1; ++dc)
            for (int dr = -1; dr <= 1; ++dr)
            {
                if (dr == 0 && dc == 0 && dz == 0) continue;
                const int distance = std::abs(dr) + std::abs(dc) + std::abs(dz);
                if (connectivity == 6 && distance != 1) continue;
                if (connectivity == 18 && distance > 2) continue;
                offsets.push_back(Offset{dr, dc, dz});
            }
    return offsets;
}

bool inside(int row, int col, int slice, const IpcvVolume& volume)
{
    return row >= 0 && row < volume.rows &&
        col >= 0 && col < volume.cols &&
        slice >= 0 && slice < volume.slices;
}

std::vector<unsigned char> binary_mask(const IpcvVolume& volume)
{
    std::vector<unsigned char> mask(voxel_count(volume));
    for (size_t i = 0; i < mask.size(); ++i) mask[i] = read_value(volume, i) != 0.0;
    return mask;
}

int boolean_output(const IpcvVolume& source,
    const std::vector<unsigned char>& values, IpcvVolume *output)
{
    if (!allocate_volume(output, source, IPCV_DEPTH_8U)) return -1;
    std::memcpy(output->data, values.data(), values.size());
    return 0;
}

void morphology_once(const std::vector<unsigned char>& source,
    std::vector<unsigned char>& destination, const IpcvVolume& volume,
    const std::vector<Offset>& offsets, bool dilate)
{
    destination.assign(source.size(), 0);
    for (size_t index = 0; index < source.size(); ++index)
    {
        int row = 0, col = 0, slice = 0;
        decode_index(index, volume.rows, volume.cols, row, col, slice);
        bool result = source[index] != 0;
        if ((dilate && result) || (!dilate && !result))
        {
            destination[index] = result;
            continue;
        }
        for (size_t i = 0; i < offsets.size(); ++i)
        {
            const int rr = row + offsets[i].dr;
            const int cc = col + offsets[i].dc;
            const int zz = slice + offsets[i].dz;
            const bool neighbor = inside(rr, cc, zz, volume) &&
                source[index_of(rr, cc, zz, volume.rows, volume.cols)] != 0;
            if (dilate && neighbor)
            {
                result = true;
                break;
            }
            if (!dilate && !neighbor)
            {
                result = false;
                break;
            }
        }
        destination[index] = result ? 1 : 0;
    }
}

void repeat_morphology(std::vector<unsigned char>& data,
    const IpcvVolume& volume, const std::vector<Offset>& offsets,
    bool dilate, int iterations)
{
    std::vector<unsigned char> temporary;
    for (int i = 0; i < iterations; ++i)
    {
        morphology_once(data, temporary, volume, offsets, dilate);
        data.swap(temporary);
    }
}

size_t integral_index(int row, int col, int slice, int rows, int cols)
{
    return static_cast<size_t>(row) +
        static_cast<size_t>(rows) * (col + static_cast<size_t>(cols) * slice);
}

double box_sum(const std::vector<double>& integral,
    int r0, int c0, int z0, int r1, int c1, int z1, int rows, int cols)
{
    const int rb = r1 + 1, cb = c1 + 1, zb = z1 + 1;
    return integral[integral_index(rb, cb, zb, rows, cols)]
        - integral[integral_index(r0, cb, zb, rows, cols)]
        - integral[integral_index(rb, c0, zb, rows, cols)]
        - integral[integral_index(rb, cb, z0, rows, cols)]
        + integral[integral_index(r0, c0, zb, rows, cols)]
        + integral[integral_index(r0, cb, z0, rows, cols)]
        + integral[integral_index(rb, c0, z0, rows, cols)]
        - integral[integral_index(r0, c0, z0, rows, cols)];
}
}

extern "C" IPCV_CORE_API void ipcv_free_volume(IpcvVolume *volume)
{
    if (volume == NULL) return;
    if (volume->owns_data && volume->data != NULL) std::free(volume->data);
    std::memset(volume, 0, sizeof(*volume));
}

extern "C" IPCV_CORE_API int ipcv_label_volume(const IpcvVolume *source,
    int connectivity, IpcvVolume *labels, int *component_count)
{
    if (labels == NULL || component_count == NULL) return -1;
    std::memset(labels, 0, sizeof(*labels));
    *component_count = 0;
    if (!valid_volume(source))
    {
        set_error(labels, "invalid 3-D volume input");
        return -1;
    }
    if (!valid_connectivity(connectivity))
    {
        set_error(labels, "connectivity must be 6, 18, or 26");
        return -1;
    }
    if (!allocate_volume(labels, *source, IPCV_DEPTH_64F)) return -1;

    const std::vector<unsigned char> mask = binary_mask(*source);
    double *values = reinterpret_cast<double*>(labels->data);
    std::fill(values, values + mask.size(), 0.0);
    const std::vector<Offset> offsets = offsets_for(connectivity);
    std::vector<size_t> queue;
    queue.reserve(mask.size());

    for (size_t seed = 0; seed < mask.size(); ++seed)
    {
        if (!mask[seed] || values[seed] != 0.0) continue;
        ++*component_count;
        queue.clear();
        queue.push_back(seed);
        values[seed] = *component_count;
        for (size_t head = 0; head < queue.size(); ++head)
        {
            int row = 0, col = 0, slice = 0;
            decode_index(queue[head], source->rows, source->cols, row, col, slice);
            for (size_t i = 0; i < offsets.size(); ++i)
            {
                const int rr = row + offsets[i].dr;
                const int cc = col + offsets[i].dc;
                const int zz = slice + offsets[i].dz;
                if (!inside(rr, cc, zz, *source)) continue;
                const size_t neighbor = index_of(rr, cc, zz, source->rows, source->cols);
                if (mask[neighbor] && values[neighbor] == 0.0)
                {
                    values[neighbor] = *component_count;
                    queue.push_back(neighbor);
                }
            }
        }
    }
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_regional_max_volume(const IpcvVolume *source,
    int connectivity, IpcvVolume *output)
{
    if (output == NULL) return -1;
    std::memset(output, 0, sizeof(*output));
    if (!valid_volume(source))
    {
        set_error(output, "invalid 3-D volume input");
        return -1;
    }
    if (!valid_connectivity(connectivity))
    {
        set_error(output, "connectivity must be 6, 18, or 26");
        return -1;
    }

    const size_t count = voxel_count(*source);
    std::vector<unsigned char> visited(count, 0), maxima(count, 0);
    std::vector<size_t> queue, plateau;
    queue.reserve(count);
    plateau.reserve(count);
    const std::vector<Offset> offsets = offsets_for(connectivity);
    for (size_t seed = 0; seed < count; ++seed)
    {
        if (visited[seed]) continue;
        const double plateau_value = read_value(*source, seed);
        visited[seed] = 1;
        if (std::isnan(plateau_value)) continue;
        bool is_maximum = true;
        queue.clear();
        plateau.clear();
        queue.push_back(seed);
        for (size_t head = 0; head < queue.size(); ++head)
        {
            const size_t current = queue[head];
            plateau.push_back(current);
            int row = 0, col = 0, slice = 0;
            decode_index(current, source->rows, source->cols, row, col, slice);
            for (size_t i = 0; i < offsets.size(); ++i)
            {
                const int rr = row + offsets[i].dr;
                const int cc = col + offsets[i].dc;
                const int zz = slice + offsets[i].dz;
                if (!inside(rr, cc, zz, *source)) continue;
                const size_t neighbor = index_of(rr, cc, zz, source->rows, source->cols);
                const double neighbor_value = read_value(*source, neighbor);
                if (neighbor_value > plateau_value) is_maximum = false;
                if (!visited[neighbor] && neighbor_value == plateau_value)
                {
                    visited[neighbor] = 1;
                    queue.push_back(neighbor);
                }
            }
        }
        if (is_maximum)
            for (size_t i = 0; i < plateau.size(); ++i) maxima[plateau[i]] = 1;
    }
    return boolean_output(*source, maxima, output);
}

extern "C" IPCV_CORE_API int ipcv_box_filter_volume(const IpcvVolume *source,
    const int window[3], IpcvVolume *output)
{
    if (output == NULL) return -1;
    std::memset(output, 0, sizeof(*output));
    if (!valid_volume(source) || window == NULL)
    {
        set_error(output, "invalid 3-D volume input");
        return -1;
    }
    if (window[0] <= 0 || window[1] <= 0 || window[2] <= 0)
    {
        set_error(output, "window dimensions must be positive");
        return -1;
    }
    if (!allocate_volume(output, *source, IPCV_DEPTH_64F)) return -1;

    const int ir = source->rows + 1, ic = source->cols + 1, iz = source->slices + 1;
    std::vector<double> integral(static_cast<size_t>(ir) * ic * iz, 0.0);
    for (int z = 1; z <= source->slices; ++z)
        for (int c = 1; c <= source->cols; ++c)
            for (int r = 1; r <= source->rows; ++r)
            {
                const double value = read_value(*source,
                    index_of(r - 1, c - 1, z - 1, source->rows, source->cols));
                integral[integral_index(r, c, z, ir, ic)] = value
                    + integral[integral_index(r - 1, c, z, ir, ic)]
                    + integral[integral_index(r, c - 1, z, ir, ic)]
                    + integral[integral_index(r, c, z - 1, ir, ic)]
                    - integral[integral_index(r - 1, c - 1, z, ir, ic)]
                    - integral[integral_index(r - 1, c, z - 1, ir, ic)]
                    - integral[integral_index(r, c - 1, z - 1, ir, ic)]
                    + integral[integral_index(r - 1, c - 1, z - 1, ir, ic)];
            }

    const int wr = window[0] / 2, wc = window[1] / 2, wz = window[2] / 2;
    double *destination = reinterpret_cast<double*>(output->data);
    for (int z = 0; z < source->slices; ++z)
        for (int c = 0; c < source->cols; ++c)
            for (int r = 0; r < source->rows; ++r)
            {
                const int r0 = std::max(0, r - wr), r1 = std::min(source->rows - 1, r + wr);
                const int c0 = std::max(0, c - wc), c1 = std::min(source->cols - 1, c + wc);
                const int z0 = std::max(0, z - wz), z1 = std::min(source->slices - 1, z + wz);
                const double count = static_cast<double>(
                    (r1 - r0 + 1) * (c1 - c0 + 1) * (z1 - z0 + 1));
                destination[index_of(r, c, z, source->rows, source->cols)] =
                    box_sum(integral, r0, c0, z0, r1, c1, z1, ir, ic) / count;
            }
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_gaussian_filter_volume(const IpcvVolume *source,
    double sigma, IpcvVolume *output)
{
    if (output == NULL) return -1;
    std::memset(output, 0, sizeof(*output));
    if (!valid_volume(source))
    {
        set_error(output, "invalid 3-D volume input");
        return -1;
    }
    if (!(sigma > 0.0) || !std::isfinite(sigma))
    {
        set_error(output, "sigma must be a positive finite scalar");
        return -1;
    }
    if (!allocate_volume(output, *source, IPCV_DEPTH_64F)) return -1;

    const int radius = std::max(1, static_cast<int>(std::ceil(3.0 * sigma)));
    std::vector<double> kernel(2 * radius + 1);
    double normalizer = 0.0;
    for (int k = -radius; k <= radius; ++k)
    {
        kernel[k + radius] = std::exp(-(k * k) / (2.0 * sigma * sigma));
        normalizer += kernel[k + radius];
    }
    for (size_t i = 0; i < kernel.size(); ++i) kernel[i] /= normalizer;

    std::vector<double> xpass(voxel_count(*source), 0.0);
    std::vector<double> ypass(voxel_count(*source), 0.0);
    double *destination = reinterpret_cast<double*>(output->data);
    for (int z = 0; z < source->slices; ++z)
        for (int c = 0; c < source->cols; ++c)
            for (int r = 0; r < source->rows; ++r)
            {
                double sum = 0.0;
                for (int k = -radius; k <= radius; ++k)
                {
                    const int cc = std::min(std::max(c + k, 0), source->cols - 1);
                    sum += read_value(*source, index_of(r, cc, z, source->rows, source->cols)) *
                        kernel[k + radius];
                }
                xpass[index_of(r, c, z, source->rows, source->cols)] = sum;
            }
    for (int z = 0; z < source->slices; ++z)
        for (int c = 0; c < source->cols; ++c)
            for (int r = 0; r < source->rows; ++r)
            {
                double sum = 0.0;
                for (int k = -radius; k <= radius; ++k)
                {
                    const int rr = std::min(std::max(r + k, 0), source->rows - 1);
                    sum += xpass[index_of(rr, c, z, source->rows, source->cols)] *
                        kernel[k + radius];
                }
                ypass[index_of(r, c, z, source->rows, source->cols)] = sum;
            }
    for (int z = 0; z < source->slices; ++z)
        for (int c = 0; c < source->cols; ++c)
            for (int r = 0; r < source->rows; ++r)
            {
                double sum = 0.0;
                for (int k = -radius; k <= radius; ++k)
                {
                    const int zz = std::min(std::max(z + k, 0), source->slices - 1);
                    sum += ypass[index_of(r, c, zz, source->rows, source->cols)] *
                        kernel[k + radius];
                }
                destination[index_of(r, c, z, source->rows, source->cols)] = sum;
            }
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_median_filter_volume(const IpcvVolume *source,
    const int window[3], IpcvVolume *output)
{
    if (output == NULL) return -1;
    std::memset(output, 0, sizeof(*output));
    if (!valid_volume(source) || window == NULL)
    {
        set_error(output, "invalid 3-D volume input");
        return -1;
    }
    for (int i = 0; i < 3; ++i)
        if (window[i] <= 0 || window[i] % 2 == 0)
        {
            set_error(output, "window dimensions must be positive odd integers");
            return -1;
        }
    if (!allocate_volume(output, *source, IPCV_DEPTH_64F)) return -1;

    const int wr = window[0] / 2, wc = window[1] / 2, wz = window[2] / 2;
    std::vector<double> samples;
    samples.reserve(static_cast<size_t>(window[0]) * window[1] * window[2]);
    double *destination = reinterpret_cast<double*>(output->data);
    for (int z = 0; z < source->slices; ++z)
        for (int c = 0; c < source->cols; ++c)
            for (int r = 0; r < source->rows; ++r)
            {
                samples.clear();
                for (int zz = std::max(0, z - wz); zz <= std::min(source->slices - 1, z + wz); ++zz)
                    for (int cc = std::max(0, c - wc); cc <= std::min(source->cols - 1, c + wc); ++cc)
                        for (int rr = std::max(0, r - wr); rr <= std::min(source->rows - 1, r + wr); ++rr)
                            samples.push_back(read_value(*source,
                                index_of(rr, cc, zz, source->rows, source->cols)));
                const size_t middle = samples.size() / 2;
                std::nth_element(samples.begin(), samples.begin() + middle, samples.end());
                double median = samples[middle];
                if (samples.size() % 2 == 0)
                {
                    const double lower = *std::max_element(samples.begin(), samples.begin() + middle);
                    median = 0.5 * (lower + median);
                }
                destination[index_of(r, c, z, source->rows, source->cols)] = median;
            }
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_binary_morphology_volume(
    const IpcvVolume *source, int operation, int iterations,
    int connectivity, IpcvVolume *output)
{
    if (output == NULL) return -1;
    std::memset(output, 0, sizeof(*output));
    if (!valid_volume(source))
    {
        set_error(output, "invalid 3-D volume input");
        return -1;
    }
    if (!valid_connectivity(connectivity))
    {
        set_error(output, "connectivity must be 6, 18, or 26");
        return -1;
    }
    if (iterations < 1)
    {
        set_error(output, "iterations must be positive");
        return -1;
    }
    if (operation < IPCV_VOLUME_ERODE || operation > IPCV_VOLUME_CLOSE)
    {
        set_error(output, "unsupported 3-D morphology operation");
        return -1;
    }

    std::vector<unsigned char> data = binary_mask(*source);
    const std::vector<Offset> offsets = offsets_for(connectivity);
    if (operation == IPCV_VOLUME_ERODE)
        repeat_morphology(data, *source, offsets, false, iterations);
    else if (operation == IPCV_VOLUME_DILATE)
        repeat_morphology(data, *source, offsets, true, iterations);
    else if (operation == IPCV_VOLUME_OPEN)
    {
        repeat_morphology(data, *source, offsets, false, iterations);
        repeat_morphology(data, *source, offsets, true, iterations);
    }
    else
    {
        repeat_morphology(data, *source, offsets, true, iterations);
        repeat_morphology(data, *source, offsets, false, iterations);
    }
    return boolean_output(*source, data, output);
}

extern "C" IPCV_CORE_API int ipcv_area_open_volume(const IpcvVolume *source,
    int minimum_size, int connectivity, IpcvVolume *output)
{
    if (output == NULL) return -1;
    std::memset(output, 0, sizeof(*output));
    if (!valid_volume(source))
    {
        set_error(output, "invalid 3-D volume input");
        return -1;
    }
    if (minimum_size < 1)
    {
        set_error(output, "minimum size must be positive");
        return -1;
    }
    if (!valid_connectivity(connectivity))
    {
        set_error(output, "connectivity must be 6, 18, or 26");
        return -1;
    }

    const std::vector<unsigned char> mask = binary_mask(*source);
    std::vector<unsigned char> visited(mask.size(), 0), result(mask.size(), 0);
    std::vector<size_t> queue;
    queue.reserve(mask.size());
    const std::vector<Offset> offsets = offsets_for(connectivity);
    for (size_t seed = 0; seed < mask.size(); ++seed)
    {
        if (!mask[seed] || visited[seed]) continue;
        queue.clear();
        queue.push_back(seed);
        visited[seed] = 1;
        for (size_t head = 0; head < queue.size(); ++head)
        {
            int row = 0, col = 0, slice = 0;
            decode_index(queue[head], source->rows, source->cols, row, col, slice);
            for (size_t i = 0; i < offsets.size(); ++i)
            {
                const int rr = row + offsets[i].dr;
                const int cc = col + offsets[i].dc;
                const int zz = slice + offsets[i].dz;
                if (!inside(rr, cc, zz, *source)) continue;
                const size_t neighbor = index_of(rr, cc, zz, source->rows, source->cols);
                if (mask[neighbor] && !visited[neighbor])
                {
                    visited[neighbor] = 1;
                    queue.push_back(neighbor);
                }
            }
        }
        if (static_cast<int>(queue.size()) >= minimum_size)
            for (size_t i = 0; i < queue.size(); ++i) result[queue[i]] = 1;
    }
    return boolean_output(*source, result, output);
}

extern "C" IPCV_CORE_API int ipcv_perimeter_volume(const IpcvVolume *source,
    int connectivity, IpcvVolume *output)
{
    if (output == NULL) return -1;
    std::memset(output, 0, sizeof(*output));
    if (!valid_volume(source))
    {
        set_error(output, "invalid 3-D volume input");
        return -1;
    }
    if (!valid_connectivity(connectivity))
    {
        set_error(output, "connectivity must be 6, 18, or 26");
        return -1;
    }

    const std::vector<unsigned char> mask = binary_mask(*source);
    std::vector<unsigned char> result(mask.size(), 0);
    const std::vector<Offset> offsets = offsets_for(connectivity);
    for (size_t index = 0; index < mask.size(); ++index)
    {
        if (!mask[index]) continue;
        int row = 0, col = 0, slice = 0;
        decode_index(index, source->rows, source->cols, row, col, slice);
        for (size_t i = 0; i < offsets.size(); ++i)
        {
            const int rr = row + offsets[i].dr;
            const int cc = col + offsets[i].dc;
            const int zz = slice + offsets[i].dz;
            if (!inside(rr, cc, zz, *source) ||
                !mask[index_of(rr, cc, zz, source->rows, source->cols)])
            {
                result[index] = 1;
                break;
            }
        }
    }
    return boolean_output(*source, result, output);
}

extern "C" IPCV_CORE_API int ipcv_fill_volume(const IpcvVolume *source,
    int connectivity, IpcvVolume *output)
{
    if (output == NULL) return -1;
    std::memset(output, 0, sizeof(*output));
    if (!valid_volume(source))
    {
        set_error(output, "invalid 3-D volume input");
        return -1;
    }
    if (!valid_connectivity(connectivity))
    {
        set_error(output, "connectivity must be 6, 18, or 26");
        return -1;
    }

    const std::vector<unsigned char> mask = binary_mask(*source);
    std::vector<unsigned char> outside(mask.size(), 0);
    std::vector<size_t> queue;
    queue.reserve(mask.size());
    for (int z = 0; z < source->slices; ++z)
        for (int c = 0; c < source->cols; ++c)
            for (int r = 0; r < source->rows; ++r)
            {
                if (r != 0 && r != source->rows - 1 &&
                    c != 0 && c != source->cols - 1 &&
                    z != 0 && z != source->slices - 1) continue;
                const size_t index = index_of(r, c, z, source->rows, source->cols);
                if (!mask[index] && !outside[index])
                {
                    outside[index] = 1;
                    queue.push_back(index);
                }
            }

    const std::vector<Offset> offsets = offsets_for(connectivity);
    for (size_t head = 0; head < queue.size(); ++head)
    {
        int row = 0, col = 0, slice = 0;
        decode_index(queue[head], source->rows, source->cols, row, col, slice);
        for (size_t i = 0; i < offsets.size(); ++i)
        {
            const int rr = row + offsets[i].dr;
            const int cc = col + offsets[i].dc;
            const int zz = slice + offsets[i].dz;
            if (!inside(rr, cc, zz, *source)) continue;
            const size_t neighbor = index_of(rr, cc, zz, source->rows, source->cols);
            if (!mask[neighbor] && !outside[neighbor])
            {
                outside[neighbor] = 1;
                queue.push_back(neighbor);
            }
        }
    }
    std::vector<unsigned char> result(mask.size(), 0);
    for (size_t i = 0; i < mask.size(); ++i) result[i] = mask[i] || !outside[i];
    return boolean_output(*source, result, output);
}
