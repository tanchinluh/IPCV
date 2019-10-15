//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [] = immesh(imin,n,plotop);
    // Visualize 2D matrix using mesh plot, useful for frequency response visualization.
    //
    // Syntax
    //     immesh(imin,n);
    //
    // Parameters
    //     imin : Input Matrix
    //     n : Number of points to plot
    //
    // Description
    //    This function used to visualize the 2-D matrix as 3D mesh plot with the values 
    //    as the z-axes value. It is useful to visuallize the filter in frequency 
    //    domain, and also the frequency response of the images.
    //
    // Examples
    //    f = fspecial('gaussian');
    //    F = fftshift(fft2pad(f,256,256));
    //    immesh(abs(F),100);
    //
    // See also
    //     imsurf
    //     imsmoothsurf
    //
    // Authors
    //    Tan Chin Luh
    //



    rhs=argn(2);

    // Error Checking
    if rhs < 1; error("At least 1 argument expected, in 2D matrix"); end    
    if rhs < 3; plotop = 0; end
    if rhs == 1 | n == []; n=100; end
    //

    sz = size(imin);

    r_step = round(sz(1)/n);
    c_step = round(sz(2)/n);

    if n == -1 then
        r_step = 1;
        c_step = 1;    
    end

    r_center = round(sz(1)/2);
    c_center = round(sz(2)/2);

    r_1 = modulo(r_center,r_step)+1;
    c_1 = modulo(c_center,c_step)+1;


    ind1 = r_1:r_step:sz(1);
    ind2 = c_1:c_step:sz(2);

    x = linspace(-1,1,length(ind2));
    y = linspace(-1,1,length(ind1));

    if plotop == 0 then
        [X,Y] = meshgrid(x,y);
        mesh(X,Y,imin(ind1,ind2));
    else
        plot3d(y,x,imin(ind1,ind2));    
    end


    //plot3d(y,x,imin(ind1,ind2));

    f=gcf();
    f.background = -2;    
    f.children.children.color_mode = 0;

endfunction






