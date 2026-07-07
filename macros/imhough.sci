//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [HM, rho, th2] = imhough(S)
    // Image Hough transformation 
    //
    // Syntax
    //    [HM, rho, th] = imhough(S)
    //
    // Parameters
    //    S : Source edge image. Boolean and nonzero numeric pixels vote in Hough space.
    //    HM : Hough Matrix
    //    rho : Distance from center to the point
    //    th  : Angle from the center to the point
    //
    // Description
    //    Applies Hough transformation to an image.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/2lines.png"));
    //    [HM, rho, th] = imhough(S);
    //    scf();Sgrayplot(th,rho,HM',strf="021");
    //    xset("colormap",hot(64))
    //
    // See also
    //    imradon
    //
    // Authors
    //    Tan Chin Luh
    //

    sz = size(S);
    if size(sz, "*") > 2 then
        S = rgb2gray(S);
        sz = size(S);
    end

    x_total = sz(2);
    y_total = sz(1);

    th = -%pi/2:%pi/180:%pi/2-%pi/180;
    maxrho = round(sqrt(x_total^2 + y_total^2));
    rho = -maxrho:maxrho;
    th_total = size(th, "*");
    HM = zeros(size(rho, "*"), th_total);

    if typeof(S) == "boolean" then
        active = S;
    else
        active = double(S) <> 0;
    end

    for cnt_x = 1:x_total
        for cnt_y = 1:y_total
            if active(cnt_y, cnt_x) then
                r = cnt_x.*cos(th) + cnt_y.*sin(th);
                ind = sub2ind(size(HM), round(r) + maxrho + 1, 1:th_total);
                HM(ind) = HM(ind) + 1;
            end
        end
    end

    th2 = th.*180/%pi;
endfunction
