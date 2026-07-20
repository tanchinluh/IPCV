function out = immedian3(volume, window)
    // Apply a native 3D median filter.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("immedian3: invalid arguments."); end
    if rhs < 2 then window = [3 3 3]; end
    if size(window, "*") == 1 then window = [window window window]; end
    if size(window, "*") <> 3 | or(window <= 0) | or(modulo(window, 2) == 0) then
        error("immedian3: window must contain positive odd dimensions.");
    end
    if typeof(volume(1)) == "constant" then values = double(volume); else values = im2double(volume); end;
    if size(size(values), "*") <> 3 then error("immedian3: a 3D volume is required."); end
    out = int_immedian3(values, round(window));
endfunction