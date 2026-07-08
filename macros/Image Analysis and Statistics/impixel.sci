//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [xc,yc,pixval] = impixel(S)
    // Return selected pixel coordinates and values
    //
    // Syntax
    //     [xc,yc,pixval] = impixel(S);
    //
    // Parameters
    //     S : Image matrix in Scilab
    //     xc : x-coordinates for the selected points
    //     yc : y-coordinates for the selected points
    //     pixval : Correspond pixels' values
    //
    // Description
    //    This function provides interactive way to select the points on an image 
    //    and returned with the locations and pixels values. Multiple points could
    //    be selected with left mouse click and the last point should be selected 
    //    with the right mouse click.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons.png"));
    //    impixel(S);
    //
    // See also
    //     improfile
    //
    // Authors
    //    Tan Chin Luh
    //




    imshow(S);

    [b,xc,yc]=xclick();
    plot2d(xc,yc,style = -1, strf = '082');

    cnt = 2;
    while b ~=5
        [b(cnt),xc(cnt),yc(cnt)]=xclick();
        plot2d(xc(cnt),yc(cnt),style = -1,strf = '082');
        cnt = cnt + 1;
    end

    [r,c] = size(S);
    pixval = cell(cnt-1,1);

    for cnt2 = 1:cnt-1
        yc(cnt2) = r+1-yc(cnt2);
        pixtemp = S(yc(cnt2),xc(cnt2),:);
        pixval{cnt2} = double(matrix(pixtemp,length(pixtemp)));
        mprintf('[x,y] = [%i,%i] \t RGB = %s \n',xc(cnt2),yc(cnt2),strcat(string(pixval{cnt2}),','));
    end

endfunction
