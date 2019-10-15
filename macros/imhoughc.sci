//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [HM, rho, th2] = imhoughc(S)
    // Image Hough transformation for Circle Detection
    //
    // Syntax
    //    
    // Parameters
    //
    // Description
    //
    // Examples
    //
    // See also
    //    imradon
    //
    // Authors
    //    Tan Chin Luh
    //
    
sz = size(S);
x_total = sz(2);
y_total = sz(1);

th = -%pi/2:%pi/180:%pi/2-%pi/180;
maxrho = round(sqrt(x_total^2 + y_total^2));
rho = -maxrho:maxrho;
th_total = size(th,'*');
HM = zeros(size(rho,'*'),th_total);

cc= 0;
for cnt_x = 1:x_total
    for cnt_y = 1:y_total
        if S(cnt_y,cnt_x) == %t
           r = cnt_x.*cos(th) + cnt_y.*sin(th);
           ind = sub2ind(size(HM),round(r)+maxrho,1:th_total);
           HM(ind) = HM(ind) + 1;
           
        end            
    end
end

th2 = th.*180/%pi;

endfunction
