function out = imhmax(image, height)
    // Suppress bright peaks below the requested contrast height.
    if argn(2) <> 2 | height < 0 then error("imhmax: image and nonnegative height are required."); end
    inputType = typeof(image(1));
    values = double(image);
    local = imlocalmean(values, [3 3]);
    out = values;
    out(values - local < height) = local(values - local < height);

    select inputType
    case "uint8" then
        out = uint8(round(min(max(out, 0), 255)));
    case "uint16" then
        out = uint16(round(min(max(out, 0), 65535)));
    case "int8" then
        out = int8(round(min(max(out, -128), 127)));
    case "int16" then
        out = int16(round(min(max(out, -32768), 32767)));
    case "int32" then
        out = int32(round(out));
    case "uint32" then
        out = uint32(round(max(out, 0)));
    end
endfunction
