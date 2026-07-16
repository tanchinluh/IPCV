function out = imbwmorph3(volume, operation, iterations, connectivity)
    // Apply a documented subset of 3D binary morphology operations.
    rhs = argn(2);
    if rhs < 2 | rhs > 4 then error("imbwmorph3: volume and operation are required."); end
    if size(size(volume), "*") <> 3 then error("imbwmorph3: a 3D volume is required."); end
    if rhs < 3 then iterations = 1; end
    if rhs < 4 then connectivity = 6; end
    if iterations < 1 | connectivity <> 6 & connectivity <> 26 then error("imbwmorph3: invalid iterations or connectivity."); end
    key = convstr(operation, "l");
    if typeof(volume) == "boolean" then mask = volume; else mask = volume <> 0; end
    select key
    case "erode" then out = ipcv_imbwmorph3_once(mask, "erode", connectivity);
    case "dilate" then out = ipcv_imbwmorph3_once(mask, "dilate", connectivity);
    case "open" then out = ipcv_imbwmorph3_once(ipcv_imbwmorph3_once(mask, "erode", connectivity), "dilate", connectivity);
    case "close" then out = ipcv_imbwmorph3_once(ipcv_imbwmorph3_once(mask, "dilate", connectivity), "erode", connectivity);
    else error("imbwmorph3: use erode, dilate, open, or close.");
    end
    for i = 2:iterations
        if key == "open" then
            out = ipcv_imbwmorph3_once(ipcv_imbwmorph3_once(out, "erode", connectivity), "dilate", connectivity);
        elseif key == "close" then
            out = ipcv_imbwmorph3_once(ipcv_imbwmorph3_once(out, "dilate", connectivity), "erode", connectivity);
        else
            out = ipcv_imbwmorph3_once(out, key, connectivity);
        end
    end
endfunction

function out = ipcv_imbwmorph3_once(volume, operation, connectivity)
    rows = size(volume, 1); cols = size(volume, 2); slices = size(volume, 3); out = zeros(rows, cols, slices) == 1;
    for z = 1:slices
        for y = 1:rows
            for x = 1:cols
                keep = operation == "dilate";
                for dz = -1:1
                    for dy = -1:1
                        for dx = -1:1
                            if dx == 0 & dy == 0 & dz == 0 then continue; end
                            if connectivity == 6 & abs(dx) + abs(dy) + abs(dz) <> 1 then continue; end
                            yy = y + dy; xx = x + dx; zz = z + dz; neighbor = %f;
                            if yy >= 1 & yy <= rows & xx >= 1 & xx <= cols & zz >= 1 & zz <= slices then neighbor = volume(yy, xx, zz); end
                            if operation == "dilate" then
                                if neighbor then keep = %t; end
                            else
                                if ~neighbor then keep = %f; end
                            end
                        end
                    end
                end
                out(y, x, z) = keep;
            end
        end
    end
endfunction
