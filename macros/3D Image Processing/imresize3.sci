function out = imresize3(volume, outputSize)
    // Resize a 3D volume with nearest-neighbor sampling.
    if argn(2) <> 2 then error("imresize3: volume and [rows cols slices] are required."); end
    if size(size(volume), "*") <> 3 | size(outputSize, "*") <> 3 then error("imresize3: a 3D volume and three-element output size are required."); end
    rows = size(volume, 1); cols = size(volume, 2); slices = size(volume, 3);
    newRows = round(outputSize(1)); newCols = round(outputSize(2)); newSlices = round(outputSize(3));
    if min([newRows newCols newSlices]) < 1 then error("imresize3: output dimensions must be positive."); end
    out = zeros(newRows, newCols, newSlices);
    for k = 1:newSlices
        sourceK = min(max(round((k - 0.5) * slices / newSlices + 0.5), 1), slices);
        for j = 1:newCols
            sourceJ = min(max(round((j - 0.5) * cols / newCols + 0.5), 1), cols);
            for i = 1:newRows
                sourceI = min(max(round((i - 0.5) * rows / newRows + 0.5), 1), rows);
                out(i, j, k) = volume(sourceI, sourceJ, sourceK);
            end
        end
    end
endfunction
