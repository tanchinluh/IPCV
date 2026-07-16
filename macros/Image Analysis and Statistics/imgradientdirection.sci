function direction = imgradientdirection(image)
    // Return Sobel gradient direction in degrees in the range [-180, 180].
    [gx, gy] = imgradientxy(image);
    direction = zeros(size(gx, 1), size(gx, 2));
    for i = 1:size(gx, 1)
        for j = 1:size(gx, 2)
            x = gx(i, j);
            y = gy(i, j);
            if x > 0 then
                angle = atan(y / x);
            elseif x < 0 & y >= 0 then
                angle = atan(y / x) + %pi;
            elseif x < 0 & y < 0 then
                angle = atan(y / x) - %pi;
            elseif y > 0 then
                angle = %pi / 2;
            elseif y < 0 then
                angle = -%pi / 2;
            else
                angle = 0;
            end
            direction(i, j) = angle * 180 / %pi;
        end
    end
endfunction
