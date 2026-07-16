function out = imautocorr(image)
    // Return the normalized two-dimensional autocorrelation.
    if argn(2) <> 1 then error("imautocorr: one image is required."); end
    values = im2double(image);
    if size(size(values), "*") <> 2 then error("imautocorr: a 2D image is required."); end
    values = values - mean(values);
    spectrum = fft(values);
    out = real(ifft(abs(spectrum) .* abs(spectrum)));
    peak = max(abs(out));
    if peak > 0 then out = out / peak; end
endfunction
