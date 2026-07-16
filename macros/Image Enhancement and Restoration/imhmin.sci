function out = imhmin(image, depth)
    // Suppress dark valleys below the requested contrast depth.
    if argn(2) <> 2 | depth < 0 then error("imhmin: image and nonnegative depth are required."); end
    inputType = typeof(image(1));
    values = double(image);
    local = imlocalmean(values, [3 3]);
    out = values;
    out(local - values < depth) = local(local - values < depth);

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
