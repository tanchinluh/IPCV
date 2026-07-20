function out = imboxfilt3(volume, window)
    // Apply a native normalized box filter across all three volume axes.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imboxfilt3: invalid arguments."); end
    if rhs < 2 then window = [3 3 3]; end
    if size(window, "*") == 1 then window = [window window window]; end
    if size(window, "*") <> 3 | or(window <= 0) then
        error("imboxfilt3: window must contain three positive dimensions.");
    end
    if typeof(volume(1)) == "constant" then values = double(volume); else values = im2double(volume); end;
    if size(size(values), "*") <> 3 then error("imboxfilt3: a 3D volume is required."); end
    out = int_imboxfilt3(values, round(window));
endfunction