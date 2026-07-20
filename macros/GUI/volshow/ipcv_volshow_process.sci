function [out, description] = ipcv_volshow_process(volume, operation, parameter, threshold, connectivity)
    // Apply a selected IPCV 3-D operation to the full-resolution volume.
    if size(size(volume), "*") <> 3 then
        error("volshow: processing requires a 3-D scalar volume.");
    end

    operation = convstr(operation, "l");
    parameter = double(parameter);
    threshold = min(max(double(threshold), 0), 1);
    connectivity = round(double(connectivity));
    if connectivity <> 6 & connectivity <> 18 & connectivity <> 26 then
        error("volshow: connectivity must be 6, 18, or 26.");
    end

    values = double(volume);
    low = min(matrix(values, -1, 1));
    high = max(matrix(values, -1, 1));
    if high > low then
        normalized = (values - low) ./ (high - low);
    else
        normalized = zeros(volume);
    end
    mask = normalized >= threshold;

    select operation
    case "adjust" then
        out = imadjust3(volume);
        description = "Adjusted intensity range";
    case "box" then
        window = max(1, round(parameter));
        out = imboxfilt3(volume, window);
        description = msprintf("Box filter, %d x %d x %d", window, window, window);
    case "gaussian" then
        sigma = max(parameter, 0.01);
        out = imgaussianblur3(volume, sigma);
        description = msprintf("Gaussian blur, sigma %.3g", sigma);
    case "median" then
        window = max(1, round(parameter));
        if modulo(window, 2) == 0 then window = window + 1; end
        out = immedian3(volume, window);
        description = msprintf("Median filter, %d x %d x %d", window, window, window);
    case "gradient" then
        out = imgradient3(volume);
        description = "3-D gradient magnitude";
    case "threshold" then
        out = mask;
        description = msprintf("Threshold at %.3f of intensity range", threshold);
    case "regionalmax" then
        out = imregionalmax3(volume, connectivity);
        description = msprintf("Regional maxima, %d-connectivity", connectivity);
    case "erode" then
        iterations = max(1, round(parameter));
        out = imbwmorph3(mask, "erode", iterations, connectivity);
        description = msprintf("Binary erosion, %d iteration(s)", iterations);
    case "dilate" then
        iterations = max(1, round(parameter));
        out = imbwmorph3(mask, "dilate", iterations, connectivity);
        description = msprintf("Binary dilation, %d iteration(s)", iterations);
    case "open" then
        iterations = max(1, round(parameter));
        out = imbwmorph3(mask, "open", iterations, connectivity);
        description = msprintf("Binary opening, %d iteration(s)", iterations);
    case "close" then
        iterations = max(1, round(parameter));
        out = imbwmorph3(mask, "close", iterations, connectivity);
        description = msprintf("Binary closing, %d iteration(s)", iterations);
    case "fill" then
        out = imfill3(mask, connectivity);
        description = msprintf("Filled 3-D cavities, %d-connectivity", connectivity);
    case "areaopen" then
        minimumSize = max(1, round(parameter));
        out = imbwareaopen3(mask, minimumSize, connectivity);
        description = msprintf("Removed components below %d voxels", minimumSize);
    case "perimeter" then
        out = imbwperim3(mask, connectivity);
        description = msprintf("3-D perimeter, %d-connectivity", connectivity);
    case "kmeans" then
        clusterCount = max(2, round(parameter));
        [out, centers] = imsegkmeans3(volume, clusterCount);
        description = msprintf("K-means segmentation, %d clusters", clusterCount);
    else
        error("volshow: unknown 3-D processing operation: " + operation);
    end
endfunction