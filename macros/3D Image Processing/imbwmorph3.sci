function out = imbwmorph3(volume, operation, iterations, connectivity)
    // Apply native binary morphology to a 3D volume.
    rhs = argn(2);
    if rhs < 2 | rhs > 4 then error("imbwmorph3: volume and operation are required."); end
    if size(size(volume), "*") <> 3 then error("imbwmorph3: a 3D volume is required."); end
    if rhs < 3 then iterations = 1; end
    if rhs < 4 then connectivity = 6; end
    if iterations < 1 | (connectivity <> 6 & connectivity <> 18 & connectivity <> 26) then
        error("imbwmorph3: use positive iterations and 6, 18, or 26 connectivity.");
    end
    select convstr(operation, "l")
    case "erode" then operationCode = 0;
    case "dilate" then operationCode = 1;
    case "open" then operationCode = 2;
    case "close" then operationCode = 3;
    else error("imbwmorph3: use erode, dilate, open, or close.");
    end
    if typeof(volume) == "boolean" then mask = volume; else mask = volume <> 0; end
    out = int_imbwmorph3(mask, operationCode, round(iterations), connectivity);
endfunction