function out = imbwpropfilt(image, property, limits, connectivity)
    // Keep connected components whose measured property is in limits.
    rhs = argn(2); if rhs < 3 | rhs > 4 then error("imbwpropfilt: image, property, and limits are required."); end
    if rhs < 4 then connectivity = 8; end
    mask = ipcv_binary_mask(image, "imbwpropfilt");
    [labels, count] = imconnectedcomponents(mask, connectivity);
    props = imregionprops(labels);
    if size(limits, "*") == 1 then limits = [limits %inf]; end
    if size(limits, "*") <> 2 then error("imbwpropfilt: limits must be a scalar or [min max]."); end
    key = convstr(property, "l"); out = zeros(size(mask, 1), size(mask, 2)) == 1;
    for i = 1:count
        select key
        case "area" then value = props(i).Area;
        case "extent" then value = props(i).Extent;
        case "perimeter" then value = props(i).Perimeter;
        else error("imbwpropfilt: property must be area, extent, or perimeter.");
        end
        if value >= limits(1) & value <= limits(2) then
            out = out | (labels == i);
        end
    end
endfunction
