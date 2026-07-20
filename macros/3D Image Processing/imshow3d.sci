function view = imshow3d(volume, varargin)
    // Display a 3D scalar volume with slice, orthoslice, MIP, or 3D voxel views.

    function image = imshow3d_normalize(plane)
        values = double(plane);
        low = min(values);
        high = max(values);
        if high == low then
            image = uint8(zeros(size(values)));
        else
            image = uint8(round((values - low) * 255 / (high - low)));
        end
    endfunction

    function mip = imshow3d_mip_xy(values)
        rows = size(values, 1);
        cols = size(values, 2);
        slices = size(values, 3);
        mip = values(:, :, 1);
        for k = 2:slices
            mip = max(mip, values(:, :, k));
        end
    endfunction

    function mip = imshow3d_mip_xz(values)
        rows = size(values, 1);
        cols = size(values, 2);
        slices = size(values, 3);
        mip = zeros(rows, slices);
        for k = 1:slices
            for r = 1:rows
                mip(r, k) = max(values(r, :, k));
            end
        end
    endfunction

    function mip = imshow3d_mip_yz(values)
        rows = size(values, 1);
        cols = size(values, 2);
        slices = size(values, 3);
        mip = zeros(cols, slices);
        for k = 1:slices
            for c = 1:cols
                mip(c, k) = max(values(:, c, k));
            end
        end
    endfunction

    function plane = imshow3d_coronal(values, rowIndex)
        cols = size(values, 2);
        slices = size(values, 3);
        plane = matrix(values(rowIndex, :, :), cols, slices);
    endfunction

    function plane = imshow3d_sagittal(values, colIndex)
        rows = size(values, 1);
        slices = size(values, 3);
        plane = matrix(values(:, colIndex, :), rows, slices);
    endfunction

    function [x, y, z, threshold] = imshow3d_voxel_points(values, threshold, maxPoints)
        rows = size(values, 1);
        cols = size(values, 2);
        slices = size(values, 3);
        flat = matrix(values, -1, 1);
        low = min(flat);
        high = max(flat);

        if threshold == [] then
            threshold = low + 0.45 * (high - low);
        end

        indices = find(flat >= threshold);
        if indices == [] then
            threshold = low;
            indices = find(flat >= threshold);
        end

        if size(indices, "*") > maxPoints then
            step = ceil(size(indices, "*") / maxPoints);
            indices = indices(1:step:$);
        end

        z = floor((indices - 1) / (rows * cols)) + 1;
        remain = indices - (z - 1) * rows * cols;
        col = floor((remain - 1) / rows) + 1;
        row = remain - (col - 1) * rows;

        x = col;
        y = rows - row + 1;
    endfunction

    function view = imshow3d_render_voxels(values, threshold, maxPoints, displayMode)
        rows = size(values, 1);
        cols = size(values, 2);
        slices = size(values, 3);
        [x, y, z, threshold] = imshow3d_voxel_points(values, threshold, maxPoints);

        param3d1(x, y, z);
        e = gce();
        e.line_mode = "off";
        e.mark_mode = "on";
        e.mark_style = 4;
        e.mark_foreground = 5;
        a = gca();
        a.data_bounds = [1, 1, 1; cols, rows, slices];
        a.rotation_angles = [65, 35];
        xlabel("Column");
        ylabel("Row");
        zlabel("Slice");
        title(msprintf("3D volume view: %d points, threshold %.3g", size(x, "*"), threshold));

        view = struct("Mode", displayMode, "X", x, "Y", y, "Z", z, "Threshold", threshold, ..
            "MaxPoints", maxPoints);
    endfunction

    rhs = argn(2);
    if rhs < 1 then
        error("imshow3d: a 3D volume is required.");
    end
    if size(size(volume), "*") <> 3 then
        error("imshow3d: input must be a 3D scalar volume.");
    end

    rows = size(volume, 1);
    cols = size(volume, 2);
    slices = size(volume, 3);
    sliceIndex = ceil(slices / 2);
    rowIndex = ceil(rows / 2);
    colIndex = ceil(cols / 2);
    mode = "3d";
    threshold = [];
    maxPoints = 12000;

    if length(varargin) >= 1 then
        firstArg = varargin(1);
        if type(firstArg) == 10 then
            mode = convstr(firstArg, "l");
        else
            sliceIndex = firstArg;
            mode = "slice";
        end
    end
    if length(varargin) >= 2 then
        secondArg = varargin(2);
        if type(secondArg) == 10 then
            mode = convstr(secondArg, "l");
        elseif mode == "3d" | mode == "volshow" | mode == "volume" | mode == "voxel" then
            threshold = secondArg;
        else
            rowIndex = secondArg;
        end
    end
    if length(varargin) >= 3 then
        thirdArg = varargin(3);
        if mode == "3d" | mode == "volshow" | mode == "volume" | mode == "voxel" then
            maxPoints = thirdArg;
        else
            colIndex = thirdArg;
        end
    end

    sliceIndex = min(max(round(sliceIndex), 1), slices);
    rowIndex = min(max(round(rowIndex), 1), rows);
    colIndex = min(max(round(colIndex), 1), cols);
    values = double(volume);
    maxPoints = max(round(maxPoints), 1);

    select mode
    case "slice" then
        view = volume(:, :, sliceIndex);
        imshow(view);
        title(msprintf("Slice %d / %d", sliceIndex, slices));
    case "orthoslice" then
        axial = values(:, :, sliceIndex);
        coronal = imshow3d_coronal(values, rowIndex);
        sagittal = imshow3d_sagittal(values, colIndex);
        subplot(1, 3, 1);
        imshow(imshow3d_normalize(axial));
        title(msprintf("Axial z=%d", sliceIndex));
        subplot(1, 3, 2);
        imshow(imshow3d_normalize(coronal));
        title(msprintf("Coronal row=%d", rowIndex));
        subplot(1, 3, 3);
        imshow(imshow3d_normalize(sagittal));
        title(msprintf("Sagittal col=%d", colIndex));
        view = struct("Mode", mode, "Axial", axial, "Coronal", coronal, "Sagittal", sagittal, ..
            "SliceIndex", sliceIndex, "RowIndex", rowIndex, "ColumnIndex", colIndex);
    case "mip" then
        mipXY = imshow3d_mip_xy(values);
        mipXZ = imshow3d_mip_xz(values);
        mipYZ = imshow3d_mip_yz(values);
        subplot(1, 3, 1);
        imshow(imshow3d_normalize(mipXY));
        title("MIP XY");
        subplot(1, 3, 2);
        imshow(imshow3d_normalize(mipXZ));
        title("MIP XZ");
        subplot(1, 3, 3);
        imshow(imshow3d_normalize(mipYZ));
        title("MIP YZ");
        view = struct("Mode", mode, "XY", mipXY, "XZ", mipXZ, "YZ", mipYZ);
    case "3d" then
        view = imshow3d_render_voxels(values, threshold, maxPoints, "3d");
    case "volshow" then
        view = volshow(volume);
    case "volume" then
        view = imshow3d_render_voxels(values, threshold, maxPoints, "3d");
    case "voxel" then
        view = imshow3d_render_voxels(values, threshold, maxPoints, "3d");
    case "overview" then
        axial = values(:, :, sliceIndex);
        coronal = imshow3d_coronal(values, rowIndex);
        sagittal = imshow3d_sagittal(values, colIndex);
        mipXY = imshow3d_mip_xy(values);
        mipXZ = imshow3d_mip_xz(values);
        mipYZ = imshow3d_mip_yz(values);
        subplot(2, 3, 1);
        imshow(imshow3d_normalize(axial));
        title(msprintf("Axial z=%d", sliceIndex));
        subplot(2, 3, 2);
        imshow(imshow3d_normalize(coronal));
        title(msprintf("Coronal row=%d", rowIndex));
        subplot(2, 3, 3);
        imshow(imshow3d_normalize(sagittal));
        title(msprintf("Sagittal col=%d", colIndex));
        subplot(2, 3, 4);
        imshow(imshow3d_normalize(mipXY));
        title("MIP XY");
        subplot(2, 3, 5);
        imshow(imshow3d_normalize(mipXZ));
        title("MIP XZ");
        subplot(2, 3, 6);
        imshow(imshow3d_normalize(mipYZ));
        title("MIP YZ");
        view = struct("Mode", mode, "Axial", axial, "Coronal", coronal, "Sagittal", sagittal, ..
            "XY", mipXY, "XZ", mipXZ, "YZ", mipYZ, "SliceIndex", sliceIndex, ..
            "RowIndex", rowIndex, "ColumnIndex", colIndex);
    else
        error("imshow3d: mode must be ''slice'', ''orthoslice'', ''mip'', ''overview'', ''3d'', or ''volshow''.");
    end
endfunction
