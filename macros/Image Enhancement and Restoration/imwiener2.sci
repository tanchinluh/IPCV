//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imwiener2(imin,mn,noise)
    // Wiener filter for image
    if argn(2) < 3 then
        noise = [];
    end
    // Syntax
    //    imout = imwiener2(imin,mn,noise)
    //
    // Parameters
    //    imin : Source Image
    //    mn : Block size
    //    noise : Noise ratio
    //    imout : Output Image
    //
    // Description
    //    Wiener filter is used to filter out noise that has corrupted an image based on a statistical approach.
    //    Integer input images are processed in normalized double precision and converted back to the input integer class.
    //    Double input images return normalized double output.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/opencv_smarties.png"));
    //    image = imresize(rgb2gray(image), [120 160]);
    //    noisy = imnoise(image, "gaussian", 0, 0.01);
    //    restored = imwiener2(noisy, [5 5], 0.01);
    //    imshow(restored);
    //
    // See also
    //    imfilter
    //
    // Authors
    //    Tan Chin Luh
    //


    //

    inputType = typeof(imin(1));
    if inputType == "constant" then
        source = double(imin);
        if min(source) < 0 | max(source) > 1 then
            source = immat2gray(source);
        end
    else
        source = im2double(imin);
    end

    block_sz = prod(mn);

    loc_mean = imfilter2(source,ones(mn(1),mn(2))) / block_sz;
    loc_var = imfilter2(source.^2,ones(mn(1),mn(2))) / block_sz - loc_mean.^2;

    // Estimate the noise power if necessary.
    if (isempty(noise))
        noise = mean(loc_var);
    end

    // Compute result
    imout = loc_mean + (max(0, loc_var - noise) ./ max(loc_var, noise)) .* (source - loc_mean);
    imout = min(max(imout, 0), 1);

    select inputType
    case "uint8" then
        imout = im2uint8(imout);
    case "uint16" then
        imout = im2uint16(imout);
    case "int8" then
        imout = im2int8(imout);
    case "int16" then
        imout = im2int16(imout);
    case "int32" then
        imout = im2int32(imout);
    case "uint32" then
        imout = im2uint32(imout);
    end

endfunction
