////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006 Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//============================================================================= 

//Create 2-D special filters.
function [F] = fspecial(ftype, varargin)
    // Create some 2D special filters
    //
    // Syntax
    //      F = fspecial(type)
    //      F = fspecial(type, op1)
    //      F = fspecial(type, op1, op2)
    //
    // Parameters
    //      type : Filter type. It can be one of these string: 'sobel', 'prewitt', 'gaussion', 'laplacian', 'log', 'average', 'unsharp', 'motion'. ('disk' in future.)
    //      op1 : The first parameter for the filter. Some type of filters do not need it.
    //      op2 : The second parameter for the filter. Some type of filters do not need it.
    //      FT : The returned filter, which is of type double.
    //
    // Description
    //    fspecial create some 2D special filters. If no parameters are given, fspecial will uses default values.
    //
    //    The supported filters and the syntax for each filter type are listed in the following list:
    //
    // <variablelist>
    // <varlistentry>
    //    <term>F = fspecial('sobel') : </term>
    //    <listitem>returns a 3x3 horizontal edges sobel filter. If you want avertical e dges sobel filter, you can use transposition of F. F is [ 1 2 1; 0 0 0; -1 -2 -1].</listitem>
    // </varlistentry> 
    // <varlistentry>
    //    <term>F = fspecial('prewitt') : </term>
    //    <listitem>returns a 3x3 horizontal edges prewitt filter. If you want avertical edges prewitt filter, you can use transposition of F. F is [ 1 1 1; 0 0 0; -1 -1 -1].</listitem>
    // </varlistentry> 
    // <varlistentry>
    //    <term>F = fspecial('gaussian', hsize, sigma) : </term>
    //    <listitem>returns a Gaussian lowpass filter. The size of returned filter is determined by parameter hsize. hsize can be a 1x2 vector which indicate the rows and columns of F. If hsize is a scalar, F is a square matrix. The default value for hsize is [3, 3]; the default value for sigma is 0.5.</listitem>
    // </varlistentry> 
    // <varlistentry>
    //    <term>F = fspecial('laplacian', alpha) : </term>
    //    <listitem>returns a 3-by-3 Laplacian filter. The returned filter is [alpha, 1-alpha, alpha; 1-alpha, -4, 1-alpha; alpha, 1-alpha, alpha]/(alpha+1). The default value for alpha is 0.2.</listitem>
    // </varlistentry> 
    // <varlistentry>
    //    <term>F = fspecial('log', hsize, sigma) : </term>
    //    <listitem>returns a Laplacian of Gaussian filter. The size of returned filter is determined by parameter hsize. hsize can be a 1x2 vector which indicate the rows and columns of F. If hsize is a scalar, F is a square matrix. The default value for hsize is [5, 5]; the default value for sigma is 0.5.</listitem>
    // </varlistentry> 
    // <varlistentry>
    //    <term>F = fspecial('average',hsize) : </term>
    //    <listitem>returns an averaging filter. The size of returned filter is determined by parameter hsize. hsize can be a 1x2 vector which indicate the rows and columns of F. If hsize is a scalar, F is a square matrix. The default value for hsize is [3, 3].</listitem>
    // </varlistentry> 
    // <varlistentry>
    //    <term>F = fspecial('unsharp', alpha) : </term>
    //    <listitem>returns a 3x3 unsharp contrast enhancement filter. alpha must be in the range [0.0, 1.0]. The default value of alpha is 0.2.</listitem>
    // </varlistentry> 
    // <varlistentry>
    //    <term>F = fspecial('motion', length, angle1) : </term>
    //    <listitem>returns a motion blurred filter with length and angle.</listitem>
    //  </varlistentry>    
    //  </variablelist>
    //
    //Examples
    //
    //      im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //      filter = fspecial('sobel');
    //      imf = imfilter(im, filter);
    //      imshow(imf);
    //
    //See also
    //      imfilter
    //      filter2
    //
    //Authors
    //      Shiqi Yu
    //      Tan Chin Luh
    //
    
    //check input
    if typeof(ftype)~='string' then
        error('The first argument must be a string.');
    end

    op1 = [];
    op2 = [];
    if length(varargin)>=1 then
        op1 = varargin(1);
        if ~isreal(op1) then, error("The second arguument should be real."); end
    end
    if length(varargin)>=2 then
        op2 = varargin(2);
        if ~isreal(op2) then, error("The third arguument should be real."); end
    end
    if length(varargin)>2 then
        error("Too many arguments.");
    end

    select ftype,

        //----------------------------------------------
        //sobel filter
    case 'sobel' then,
        if length(varargin)>0 then, 
            error("Too many arguments for this kind of filter");
        end
        F=[1 2 1; 0 0 0; -1 -2 -1];


        //----------------------------------------------
        //motion  filter
        //
        // Taken (with some changes) from Peter Kovesis implementation 
        // (http://www.csse.uwa.edu.au/~pk/research/matlabfns/OctaveCode/fspecial.m)
        // FIXME: The implementation is not quite matlab compatible.
    case "motion"
        if (isreal (op1))
            len = op1;
        else
            len = 9;
        end
        if (modulo (len, 2) == 1)
            sze = [len, len];
        else
            sze = [len+1, len+1];
        end
        if (isreal (op2))
            angle1 = op2;
        else
            angle1 = 0;
        end

        // First generate a horizontal line across the middle
        f = zeros (sze(1),sze(2));
        f (floor (len/2)+1, 1:len) = 1;

        // Then rotate to specified angle1
        f = imrotate (f, angle1);
        F = f / sum (f (:));


        //----------------------------------------------
        //prewitt filter
    case 'prewitt' then,
        if length(varargin)>0 then, 
            error("Too many arguments for this kind of filter");
        end
        F=[1 1 1; 0 0 0; -1 -1 -1];

        //----------------------------------------------
        //average filter
    case 'average' then,
        if length(varargin)>1 then, 
            error("Too many arguments for this kind of filter");
        end
        if isempty(op1) then, 
            op1=3; 
        else
            if op1 ~= floor(op1) then, error('The second argument must be an integer.'); end;
        end
        F = ones(op1,op1)/op1/op1;

        //----------------------------------------------
        //gaussian low pass filter
    case 'gaussian' then,
        //set the size for the filter
        if isempty(op1) then
            siz = [3,3];
        else
            if length(op1)==1 then
                siz = [op1, op1];
            elseif length(op1)==2 then
                siz = op1;
            else
                error("The second argument should have 1 or 2 elements for gaussian filter");
            end
        end
        //set std for the filter
        if isempty(op2) then
            g_std = 0.5;
        else
            if length(op2)>1 then
                error("The third argument should have only 1 element for gaussian filter");
            else
                g_std = op2;
            end
        end
        //
        sizx = (siz(2)-1)/2;
        sizy = (siz(1)-1)/2;
        x2 = ones(siz(1),1) * ([-sizx:sizx].^2);
        y2 = ([-sizy:sizy].^2)' * ones(1, siz(2));
        F = exp( -(x2+y2)/(2*g_std^2) );
        F(F<%eps*max(F)) = 0;
        sumF=sum(F);
        if sumF~=0 then
            F = F / sum(F);
        end
        //----------------------------------------------
        //laplacian filter
    case 'laplacian' then,
        if length(varargin)>1 then, 
            error("Too many arguments for this kind of filter");
        end
        if isempty(op1) then, 
            op1=0.2; 
        else
            if (op1 < 0 | op1 > 1) then, error("The second argument should be in range [0, 1]"); end,
        end
        op1d=1-op1;
        F = [op1, op1d, op1; op1d, -4, op1d; op1, op1d, op1]/(op1+1);

        //----------------------------------------------
        //log filter:a rotationally symmetric Laplacian of Gaussian filter 
    case 'log' then,
        //get faussian filter first
        if isempty(op1) then
            siz = [5,5];
        else
            if length(op1)==1 then
                siz = [op1, op1];
            elseif length(op1)==2 then
                siz = op1;
            else
                error("The second argument should have 1 or 2 elements for log filter");
            end
        end
        //set std for the filter
        if isempty(op2) then
            g_std = 0.5;
        else
            if length(op2)>1 then
                error("The third argument should have only 1 element for log filter");
            else
                g_std = op2;
            end
        end
        //
        sizx = (siz(2)-1)/2;
        sizy = (siz(1)-1)/2;
        x2 = ones(siz(1),1) * ([-sizx:sizx].^2);
        y2 = ([-sizy:sizy].^2)' * ones(1, siz(2));
        F = exp( -(x2+y2)/(2*g_std^2) );
        F(F<%eps*max(F)) = 0;
        sumF=sum(F);
        if sumF~=0 then
            F = F / sum(F);
        end
        //now laplacian
        Ftmp = F.*(x2+y2-2*g_std^2)/(g_std^4);
        F = Ftmp - sum(Ftmp(:))/prod(siz);

        //----------------------------------------------
        //unsharp contrast enhancement filter
    case 'unsharp' then,
        if length(varargin)>1 then, 
            error("Too many arguments for this kind of filter");
        end
        if isempty(op1) then, 
            op1=0.2; 
        else
            if (op1 < 0 | op1 > 1) then, error("The second argument should be in range [0, 1]"); end,
        end
        F = [0, 0,0; 0, 1, 0; 0, 0, 0] - fspecial('laplacian',op1);

    else
        error('No such kind of filter: ' + ftype );
    end


endfunction
