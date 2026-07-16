function weight = imgradientweight(image, sensitivity)
    // Convert gradient magnitude into an edge-aware weight map.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imgradientweight: invalid arguments."); end
    if rhs < 2 then sensitivity = 1; end
    if sensitivity <= 0 then error("imgradientweight: sensitivity must be positive."); end
    magnitude = imgradientmagnitude(image);
    scale = max(matrix(magnitude, -1, 1));
    if scale <= %eps then weight = ones(size(magnitude)); else weight = exp(-sensitivity .* magnitude ./ scale); end
endfunction
