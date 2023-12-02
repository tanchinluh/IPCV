//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [xc,yc,pixval] = improfile(S,points)
    // Return profiles for the selected 2 points
    //
    // Syntax
    //     [xc,yc,pixval] = improfile(S)
    //
    // Parameters
    //     S : Image matrix in Scilab
    //     xc : x-coordinates for the selected points
    //     yc : y-coordinates for the selected points
    //     pixval : Correspond pixels' values along the selected points
    //
    // Description
    //    This function provides interactive way to select 2 points on an image 
    //    and returned with the line profile. Use left mouse click to select 2 
    //    points and the image profile would be computed and ploted on a new graph.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons.png"));
    //    improfile(S);
    //
    // See also
    //    impixel
    //
    // Authors
    //     Tan Chin Luh
    //

    rhs=argn(2);
    // Error Checking 
    if rhs < 1; error("At least 1 arguments expected, model file and the prototext."); end    
    if rhs < 2; 

        imshow(S);

        [b,xc,yc]=xclick();
        plot2d(xc,yc,style = -1, strf = '082');

        cnt = 2;

        while b ~=5 & cnt <=2
            [b(cnt),xc(cnt),yc(cnt)]=xclick();
            plot2d(xc(cnt),yc(cnt),style = -1,strf = '082');
            plot2d([xc(cnt-1),xc(cnt)],[yc(cnt-1),yc(cnt)],style = 1,strf = '082');
            cnt = cnt + 1;
        end

    else
        xc = points(:,1); yc = points(:,2); cnt=3;
    end

    a=gca();
    a.children // list the children of the axes.
    // There are a compound made of two polylines and a legend
    poly1= a.children(1).children(1); //store polyline handle into poly1
    poly1.foreground = 3; // another way to change the style...

    [r,c] = size(S);
    //pixval = cell(cnt-1,1);
    yc = r+1-yc;

    for cnt2 = 2:cnt-1
        //yc(cnt2) = r+1-yc(cnt2);

        [mv,mi] = max(length(xc(cnt2-1):xc(cnt2)),length(yc(cnt2-1):yc(cnt2)));
        if mi ==1
            xcnew = xc(cnt2-1):xc(cnt2);
            ycnew = linspace(yc(cnt2-1),yc(cnt2),mv)
        else
            ycnew = yc(cnt2-1):yc(cnt2);
            xcnew = linspace(xc(cnt2-1),xc(cnt2),mv)

        end
    end

    pixval = cell(length(xcnew),1);

    for cnt3 = 1:length(xcnew)

        pixtemp = S(ycnew(cnt3),xcnew(cnt3),:);
        pixval{cnt3} = double(matrix(pixtemp,length(pixtemp)));
        //mprintf('[x,y] = [%i,%i] \t RGB = %s \n',xcnew(cnt3),ycnew(cnt3),string(pixval(cnt3)));
    end


    if length(pixval{1}) == 3
        pixvalmat = cell2mat(pixval);

        pixvalmat = matrix(pixvalmat,3,double(max(size(pixval))));
        scf;newaxes();
        plot(1:length(xcnew),pixvalmat(1,:),'r',1:length(xcnew),pixvalmat(2,:),'g',1:length(xcnew),pixvalmat(3,:),'b');
    else
        pixvalmat = cell2mat(pixval);
        pixvalmat = matrix(pixvalmat,1,double(max(size(pixval))));

        scf;newaxes();
        plot(1:length(xcnew),pixvalmat);

    end


endfunction
