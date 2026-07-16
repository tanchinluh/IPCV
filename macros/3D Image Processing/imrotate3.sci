function out = imrotate3(volume, angle, axis)
    // Rotate a 3D volume by a multiple of 90 degrees around one axis.
    rhs = argn(2);
    if rhs < 2 | rhs > 3 then error("imrotate3: volume and angle are required."); end
    if rhs < 3 then axis = 3; end
    if size(size(volume), "*") <> 3 | axis <> 3 then error("imrotate3: current implementation supports 3D rotations around axis 3."); end
    turns = modulo(round(angle / 90), 4);
    out = volume;
    if turns == 1 then
        out = zeros(size(volume, 2), size(volume, 1), size(volume, 3));
        for k = 1:size(volume, 3) out(:, :, k) = volume(:, :, k)'; end
        out = out($:-1:1, :, :);
    end
    if turns == 2 then out = volume($:-1:1, $:-1:1, :); end
    if turns == 3 then
        out = zeros(size(volume, 2), size(volume, 1), size(volume, 3));
        for k = 1:size(volume, 3) out(:, :, k) = volume(:, :, k)'; end
        out = out(:, $:-1:1, :);
    end
endfunction
