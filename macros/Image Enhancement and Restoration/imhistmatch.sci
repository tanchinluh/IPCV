function out = imhistmatch(image, reference, bins)
    // Match the global histogram of an image to a reference image.
    if argn(2) < 2 | argn(2) > 3 then error("imhistmatch: image and reference are required."); end
    if argn(2) < 3 then bins = 256; end
    if bins < 2 then error("imhistmatch: bins must be at least 2."); end
    src = im2double(image); ref = im2double(reference);
    ds = size(src); dr = size(ref);
    if size(ds, "*") <> size(dr, "*") then error("imhistmatch: image and reference dimensions must agree."); end
    channels = 1; if size(ds, "*") == 3 then channels = ds(3); end
    out = zeros(ds);
    for ch = 1:channels
        if channels == 1 then s = src; r = ref; else s = src(:, :, ch); r = ref(:, :, ch); end
        s = min(max(s, 0), 1); r = min(max(r, 0), 1);
        hs = zeros(bins, 1); hr = zeros(bins, 1);
        si = floor(s * (bins - 1)) + 1; ri = floor(r * (bins - 1)) + 1;
        for k = 1:size(s, "*")
            hs(si(k)) = hs(si(k)) + 1;
        end
        for k = 1:size(r, "*")
            hr(ri(k)) = hr(ri(k)) + 1;
        end
        cs = cumsum(hs) / size(s, "*"); cr = cumsum(hr) / size(r, "*");
        lut = zeros(bins, 1);
        for k = 1:bins
            [_, j] = min(abs(cr - cs(k))); lut(k) = (j - 1) / (bins - 1);
        end
        mapped = lut(si);
        if channels == 1 then out = mapped; else out(:, :, ch) = mapped; end
    end
endfunction
