//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function [imout,pts] = imroi(imin, nr_points)
    // Select region of interest and create a mask from it
    //
    // Syntax
    //     imout = imroi(imin [, nr_points ])
    //     imout = imroi(imin [, points ])
    //
    // Parameters
    //     imin : Input Image
	//     nr_points : Maximum number of points to select with mouse - a positive integer (the default value is 10)
	//     points : a 2xN matrix of points; if present the region is defined by points and no interactive mouse selection is used
    //     imout : Output mask
    //
    // Description
    //    The first calling sequence is used to provide interactive way to select up to nr_points points (or up to 10 points,
    // 	  if nr_points is not given) by using right mouse button to select the last point, and points are used
    //    to create the image mask.
	//    
    //    The second calling sequence is used to create a mask from a region defined by a Nx2 matrix points
	//    which has the form [x1,y1;x2,y2;...;xN,yN], where (xi,yi), i=1..N are vertices of the region.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons.png"));
    //    imout = imroi(S); // interactive selection of a region (max 10 vertices)
	//    imout = imroi(S,15); // interactive selection of a region (max 15 vertices)
    //    imout = imroi(S,[10,10;20 20;15 35]); // create a mask from a region defined by points
    //    imshow(imout);
    //
    // See also
    //    imroifill
    //    imroifilt
    //
    // Authors
    //    Tan Chin Luh
    //


    //

    if argn(2)<2 then
        nr_points = 10;
    end
	if type(nr_points)<>1 then
		error(52,2); // real matrix excepted for argument 2
	end
	if or(size(nr_points)<>[1,1]) & size(nr_points,2)<>2 then
		error(89,2); // wrong size for argument 2
	end
	if and(size(nr_points)==[1,1]) then
		if (int(nr_points)<>nr_points) | (nr_points<0) then
			error("The argument #2 must be a positive integer.");
		end
		pts = [];
	else
		pts = nr_points;
	end
    
    imshow(imin);
    sleep(500);
    imtruesize(gcf());
	if pts == [] then
		pts = imselect(nr_points, [0 0 size(imin,2) size(imin,1)]);
	end
f =gcf();
///////////////
//pause
//if f.children.zoom_box ~=[] then
//    xx = f.children.zoom_box(1);
//    yy = f.children.zoom_box(2);
//    pts(1) = pts(1) + round(xx);
//    pts(2) = pts(2) + round(yy);
//end

/////////////////

    sz = size(imin);
    
    f.children.zoom_box = [];
    delete(f.children.children);
    f.children.margins = [0 0 0 0];
    f.axes_size = [sz(2) sz(1)];

    xfpoly(pts(:,1),pts(:,2));
    sleep(100);
    imout = xs2im(0);
    imout = imout(:,:,1);
    imout(:,1) = 255;
    imout(:,$) = 255;
    imout($,:) = 255;
    imout(1,:) = 255;
    imout = im2uint8(imcomplement(imout));

    close(f);

endfunction





