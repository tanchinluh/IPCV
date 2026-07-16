function [out, edges] = imquantize(image, edges)
    // Quantize image values into numbered intervals.
    //
    // Syntax
    //    [out, edges] = imquantize(image, edges)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    [labels, edges] = imquantize(image, [64 128 192]);
    //    colored = imlabel2rgb(labels);
    //    imshow(colored);
    //
    // See also
    //    immultithresh
    //    imlabel2rgb
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    if argn(2) <> 2 then error("imquantize: image and thresholds are required."); end
    if size(size(image), "*") == 3 then image = rgb2gray(image); end
    if size(edges, "*") == 1 then edges = immultithresh(image, edges); end
    if isempty(edges) | ~and(edges == gsort(edges, "g", "i")) then error("imquantize: edges must be sorted ascending."); end

    values = double(image);
    out = values * 0 + 1;
    for i = 1:size(edges, "*")
        out = out + double(values >= edges(i));
    end
endfunction
