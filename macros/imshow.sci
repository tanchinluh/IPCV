////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006 Shiqi Yu
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
//============================================================================= 
function imshow(im, varargin)
    // Display image in graphic window
    //
    // Syntax
    //    imshow(im)
    //    imshow(im, varargin)
    //    imshow(im, [colormap, outopt, handle]) 
    //
    // Parameters
    //    im : Input image
    //    varargin (colormap): Colormap for the image, defined in Nx3 matrix
    //    varargin (outopt) : Output options, 0 for Scilab graphics, 1 for uicontrol, 2 for tcl/tk
    //    varargin (handle) : Handle for which the image will shown
    //
    // Description
    //    Show images in different types, double (0-1), uint8(0-255), binary, and others supported image datatype.
    //
    // Examples 
    //    im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    imshow(im);
    //    f = scf();
    //    imshow(im, 1);
    //    if with_tk() then
    //      imshow(im, 2);
    //    end
    //
    // See also
    //    imread
    //    imwrite
    //    imfinfo
    //
    // Authors
    //    Shiqi Yu
    //    Allan CORNET
    //    Tan Chin Luh

    //


    function r = imshow_tcltk(im)
        r = [];
        if ~with_tk() then
            warning('Cannot display (no tcl/tk installed).');
            return;
        end

        // get dim of image
        //    width = size(im, 2);
        //    height = size(im, 1);
        //    channel = size(im, 3);
        dim = size(im);
        height = dim(1);
        width = dim(2);

        if length(dim) == 3 then
            channel = dim(3);
        else
            channel = 1;
        end    

        imc = mat2utfimg(im2uint8(im));
        //imc = (im2uint8(im));

        if (channel == 1)
            imc = 'P5' + ascii(10) + msprintf("%d %d", width, height) + ascii(10) + '255' + ascii(10) + ascii(imc);
        else
            imc = 'P6' + ascii(10) + msprintf("%d %d", width, height) + ascii(10) + '255' + ascii(10) + ascii(imc);
        end

        TCL_SetVar('imagewidth', msprintf("%d", width));
        TCL_SetVar('imageheight', msprintf("%d", height));
        TCL_SetVar('imagechannel', msprintf("%d", channel));
        TCL_SetVar('imagedata', imc);
        TCL_EvalFile(getIPCVpath() +'/tcl/imshow.tcl');
    endfunction
    //============================================================================== 
    function r = imshow_graphics(im, ColorMap, imParent) // Added for custom colormap display by CL Tan 9-July-2012

        r = []; 
        version = getversion('scilab')

        // Scilab Version 5.5 onwards 
        if version(2)>=5 | version(1)>=6 then

            if imParent == [] //| imParent.children ==[]
                //scf();
                drawlater();
                dim = size(im);

                if typeof(im) == 'boolean' //boolean
                    Matplot((2 ^ 8 - 1) *im, '082');
                elseif typeof(im(1)) == 'int8' | typeof(im(1)) == 'int16' |  typeof(im(1)) == 'uint16' | typeof(im(1)) == 'uint32'   
                    Matplot(im2double(im), '082');           
                else
                    Matplot(im, '082');
                end

                if size(dim,2) == 2 & ColorMap == []
                    e = gce();
                    e.image_type = 'gray';
                elseif ColorMap ~= []
                    e = gce();
                    e.image_type = 'index';                
                    e.parent.parent.color_map = ColorMap;
                end
                drawnow();
            else
                imChildren = imParent.children($);
                dim = size(im);
                if typeof(im) == 'boolean' //boolean
//                    imParent.children.data = (2 ^ 8 - 1) *im;
                    imChildren.data = (2 ^ 8 - 1) *im;
                elseif typeof(im(1)) == 'int8' | typeof(im(1)) == 'int16' |  typeof(im(1)) == 'uint16' | typeof(im(1)) == 'uint32'   
//                    imParent.children.data = im2double(im);   
                    imChildren.data = im2double(im);   
                else
//                    imParent.children.data = im;
                    imChildren.data = im;
                end

                if size(dim,2) == 2 & ColorMap == []
//                    e = gce();
//                    e.image_type = 'gray';
                    imChildren.image_type = 'gray';
                elseif ColorMap ~= []
//                    e = gce();
//                    e.image_type = 'index';                
//                    e.parent.parent.color_map = ColorMap;
                    imChildren.image_type = 'index';                
                    imChildren.parent.parent.color_map = ColorMap;
                end


            end

        else
            //im = im2double(im);
            //[width, height, channel] = size(im);

            dim = size(im);
            height = dim(1);
            width = dim(2);

            if length(dim) == 3 then
                channel = dim(3);
            else
                channel = 1;
            end    

            if channel == 1 then
                IndexImage = im;
                if ColorMap == [] then
                    ColorMap = graycolormap(256);
                end
            else

                // Improve the way of showing colorimage with SIP functions, by CL Tan 9-July-2012   
                IndexImage = sip_index_true_cmap(im,40);
                if ColorMap == [] then
                    ColorMap = sip_approx_true_cmap(40);
                end

            end

            if imParent == [] then
                imParent = gca();
            end

            //if imParent.figure_id == 100000 then // demos window
            //    imParent = scf(); 
            //end

            if imParent.parent.figure_id == 100000 then // demos window
                imParent = scf(); 
            end

            if ~is_handle_valid(imParent) then
                imParent = scf();
                //imParent = sca();
            end

            drawlater();
            //imParent.color_map = ColorMap;
            imParent.parent.color_map = ColorMap;

            //Matplot(IndexImage,'082');
            select type(im(1))
            case 4 //TYPE_BOOLEAN
                Matplot((2 ^ 8 - 1) * bool2s(IndexImage), '082');
            case 8 //TYPE_INT    
                Matplot(IndexImage, '082');
            case 1 //TYPE_DOUBLE
                if max(IndexImage) > 2 then // change to cater the image from operation outcome
                    Matplot(IndexImage, '082') 
                else 
                    Matplot(round((2 ^ 8 - 1) * IndexImage), '082'); 
                end;

            end;

            //imParent.background = -2;
            //imParent.children.axes_visible = ['off' 'off' 'off'];
            imParent.parent.background = -2;
            imParent.axes_visible = ['off' 'off' 'off'];

            drawnow();
        end

    endfunction
    //============================================================================== 
    function r = imshow_uicontrol(im, imParent)
        r = [];
        im = im2uint8(im);

        dim = size(im);
        height = dim(1);
        width = dim(2);

        if length(dim) == 3 then
            channel = dim(3);
        else
            channel = 1;
        end    


        imshow_filename = fullpath(TMPDIR + '/imshow_tmp.png');
        if execstr('imwrite(im, imshow_filename);', 'errcatch') == 0 then
            str = "";
            str = str + "<html>";
            str = str + "<img src = ""file:///" + imshow_filename + """ />";
            str = str + "</html>";

            if imParent == [] then
                imParent = gcf();
            end

            if imParent.figure_id == 100000 then // demos window
                imParent = scf(); 
            end

            if ~is_handle_valid(imParent) then
                imParent =  scf();
            end

            drawlater();
            imParent.figure_size = [width + 20, height + 100];
            imshow_image = uicontrol("parent", imParent, ..
            "style", "pushbutton", ..
            "string", str, ..
            "units", "pixels", ..
            "position", [ 0, 0, width, height], ..
            "background", [1 1 1], ..
            "tag", "imshow_image", ..
            "horizontalalignment" , "left", ..
            "verticalalignment"   , "bottom", ..
            "Callback", '' );
            imParent.figure_size = [width+20, height+100];
            drawnow();
        end
    endfunction
    //============================================================================== 
    function [imParent,imOutputMode,ColorMap] = checkinput(nargin2,varargin)

        imParent = [];
        imOutputMode = 0;
        ColorMap = [];

        function [imParent,imOutputMode,ColorMap] = checkvalid(x,cnt)

            if typeof(x) == 'handle' then
                imParent = x;
            elseif sum(length(x))==1
                imOutputMode = x;
            elseif length(size(x)) == 2 & size(x,2) == 3
                ColorMap = x;
            else
                error(999, msprintf(_("Wrong type for input argument #%d: The input should be either a handle, colormap, or a scalar representing output mode.\n"), cnt+1));
            end
        endfunction

        for cnt = 1:nargin2
            //pause
            [imParent,imOutputMode,ColorMap] = checkvalid(varargin(1)(cnt),cnt);

        end
        //pause
    endfunction
    //==============================================================================   
    // pause
    ////////// 
    //Check whether it is an image
    // Add 4 Dims for alpha support
    //////////
    channel = 0;
    if(size(size(im), 2) == 3) then
        if( size(im, 3) == 4 | size(im, 3) == 3 | size(im, 3) == 1) then
            channel = size(im, 3);
        end
    end
    if(size(size(im), 2) == 2) then
        channel = 1;
    end

    if(channel == 0)
        error("The input should be an image.");
        return;
    end

    ////////// 
    // Check variable argument inputs 
    ////////// 

    nargin2 = size(varargin);

    if nargin2>3 then
        error(999, msprintf(_("%s: Wrong number of input argument, #%d to #%d required.\n"), 'imshow', 1, 4));
    end

    if nargin2 == 0 then
        varargin = list(0);
        nargin2 = 1;
    end

    [imParent,imOutputMode,ColorMap] = checkinput(nargin2,varargin)
    //pause
    select imOutputMode
    case 0
        r = imshow_graphics(im, ColorMap, imParent); 
    case 1
        r = imshow_uicontrol(im, imParent); 
    case 2
        r = imshow_tcltk(im); 
    else
        error(999, msprintf("Choose only output option 0 for Scilab graphic, option 1 for Scilab uicontrol, and option 2 for TCL/TK graphic.\n"));
    end


endfunction


// Following parts are the extra functions adopted from SIP toolbox to improve the efficiency of imshow

function [A] = sip_index_true_cmap(Im,n)
    //
    // On input Im is a n1 x n2 x 3 hypermat describing a 
    // true color image  Im(i,j,:) giving the R-G-B of the 
    // pixel (i,j)
    //
    // On output A is a n1 x n2 matrix, A(i,j) given the 
    // index on the "true" color map of the (i,j) pixel. 
    // 
    // This new version doesn't use anymore hypermatrices
    // extraction for a gain in speed (as hypermatrix extraction 
    // is not currently too efficient in scilab); this result in
    // a less aesthetic code than before...  Also it uses
    // round in place of floor for a better color reduction
    // (from 0-255 levels to 0-39). 
    //
    // Author : Bruno Pincon
    //
    if argn(2)==1
        n = 40
    end
    dims = size(Im)

    if type(Im(1))== 8 
        v = (uint32(Im("entries"))*(n-1))./255;
    else
        v = round(Im("entries")*(n-1))       
    end

    //v = round(double(Im("entries"))./255*(n-1))
    m = dims(1)*dims(2)
    A = v(1:m)*(n^2) + v(m+1:2*m)*n + v(2*m+1:$) + 1
    A = matrix(A,dims(1),dims(2))
endfunction


function cmap = sip_approx_true_cmap(n)
    //
    // There are n levels for each color channel intensity
    // (each intensity being given by an integer I between 0 and n-1)
    // To the "color" R,G,B (R,G,B in [0,n-1]) must correspond the
    // index k= R n^2 + G n + B + 1 of the table cmap of size n^3 x 3
    // and cmap(k,:) =  [R/(n-1) G/(n-1) B/(n-1)]
    //
    // As the max size of a cmap in scilab is 2^16-2, 
    // n = 40 is the max possible (40^3 <= 2^16 - 2 < 41^3).
    // 
    // This function returns this colormap.
    //
    // ORIGINAL AUTHOR 
    //	   Bruno Pincon <bruno.pincon@free.fr>
    //

    if argn(2)==0
        n = 40
    end
    nb_col = n^3
    temp = (0:nb_col-1)'
    cmap = zeros(nb_col,3)
    q = int(temp/n^2)
    cmap(:,1) = q/(n-1)
    q = modulo(int(temp/n),n)
    cmap(:,2) = q/(n-1)
    cmap(:,3) = modulo(temp,n)/(n-1)
endfunction
