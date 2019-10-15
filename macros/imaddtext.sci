////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function SS = imaddtext(S,str,x,y,font_sz,font_style,font_color,angleval,box)
    // Adding text to a color image
    //
    // Syntax
    //    SS = imaddtext(S,str,x,y,font_sz,font_style,font_color [,angle [,box]])
    //
    // Parameters
    //    S : Input image
    //    str : String to add
    //    x : Offset from lower left corner, x
    //    y : Offset from lower left corner, y
    //    font_sz : Font size, 0-10. Type "help graphic_fonts" for details
    //    font_style : Font style, 0-10. Type "help graphic_fonts" for details
    //    font_color : Font color. Type "help color_list" for details
	//    angle : optional real scalar, clockwise angle of string in degrees; default is 0.
	//    box : optional integer scalar; if box=1 and angle=0, a box is drawn around the string; otherwise, no box is drawn.
    //    SS : Output image
    //
    // Description
    //    Add text provided by the user to a color image with specified location, font size, style and color.
    //
    // Examples
    //    I1 = imread(fullpath(getIPCVpath() + "/images/measure.jpg"));
    //    I2 = imaddtext(I1,'Testing',100,100,5,6,'blue');
    //    imshow(I2);
    //
    // See also
    //     imshow
    //     xs2im
    //  
    // Authors
    //    Tan Chin Luh
    

    nargin = argn(2);
	if nargin <9 then box = 0; end
	if nargin <8 then angleval = 0; end
	if nargin <7 then font_color = 'black'; end
    if nargin <6 then font_style = 6; end
    if nargin <5 then font_sz = 5; end
    if nargin <4 then y = 10; end
    if nargin <3 then x = 10; end

    if nargin <2 then error('At least 2 inputs required, image and text'); end


    imshow(S);
    sz = size(S);
    f =gcf();
    //delete(f.children.children);
    f.children.margins = [0 0 0 0];
    f.axes_size = [sz(2) sz(1)];

    xstring(x,y,str);
    t=get("hdl");
    t.font_size  = font_sz;
    t.font_style = font_style;
    t.font_foreground = color(font_color);
	if box > 0 then
		t.box = "on";
	end
	t.font_angle = -angleval;
    sleep(1000);
    SS = xs2im(f.figure_id);
    close;
endfunction

