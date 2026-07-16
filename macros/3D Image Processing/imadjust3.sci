function out = imadjust3(volume, limits)
    // Adjust a 3-D volume to the normalized range [0, 1].
    rhs = argn(2); if rhs < 1 | rhs > 2 then error("imadjust3: invalid arguments."); end
    values = im2double(volume); if size(size(values), "*") <> 3 then error("imadjust3: a 3-D volume is required."); end
    if rhs < 2 then limits = [min(matrix(values, -1, 1)) max(matrix(values, -1, 1))]; end
    if size(limits, "*") <> 2 | limits(1) >= limits(2) then error("imadjust3: limits must be [low high]."); end
    out = min(max((values - limits(1)) ./ (limits(2) - limits(1)), 0), 1);
endfunction
