function out = imcolortransfer(source, reference)
    // Transfer global Lab color statistics from reference to source.
    if argn(2) <> 2 then error("imcolortransfer: source and reference images are required."); end
    if size(size(source), "*") <> 3 | size(size(reference), "*") <> 3 then error("imcolortransfer: RGB source and reference images are required."); end
    sourceLab = double(rgb2lab(source)); referenceLab = double(rgb2lab(reference)); transformed = sourceLab;
    for ch = 1:3
        sourceChannel = sourceLab(:, :, ch); referenceChannel = referenceLab(:, :, ch);
        sourceMean = mean(sourceChannel); referenceMean = mean(referenceChannel);
        sourceStd = stdev(sourceChannel); referenceStd = stdev(referenceChannel);
        transformed(:, :, ch) = (sourceChannel - sourceMean) .* referenceStd ./ max(sourceStd, %eps) + referenceMean;
    end
    out = lab2rgb(transformed);
endfunction
