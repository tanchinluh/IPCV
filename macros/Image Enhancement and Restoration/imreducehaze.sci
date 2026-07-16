function out = imreducehaze(image, omega, t0, window)
    // Reduce haze in an RGB image using a dark-channel transmission model.
    rhs = argn(2);
    if rhs < 1 | rhs > 4 then error("imreducehaze: invalid arguments."); end
    if size(size(image), "*") <> 3 | size(image, 3) <> 3 then error("imreducehaze: an RGB image is required."); end
    if rhs < 2 then omega = 0.95; end
    if rhs < 3 then t0 = 0.1; end
    if rhs < 4 then window = 7; end
    if omega <= 0 | omega > 1 | t0 <= 0 | t0 >= 1 | window < 1 then error("imreducehaze: invalid model parameters."); end
    values = im2double(image); rows = size(values, 1); cols = size(values, 2);
    dark = min(values(:, :, 1), min(values(:, :, 2), values(:, :, 3)));
    dark = imboxfilt(dark, [window window]);
    airlight = max(matrix(dark, -1, 1));
    if airlight < %eps then airlight = 1; end
    transmission = 1 - omega * dark / airlight;
    transmission = max(transmission, t0);
    out = zeros(rows, cols, 3);
    for ch = 1:3
        out(:, :, ch) = (values(:, :, ch) - airlight) ./ transmission + airlight;
    end
    out = min(max(out, 0), 1);
endfunction
