////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006 Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [counts, cells] = imhist(im, varargin)
    // get the histogram of an image
    //
    // Syntax
    //  [counts, cells] = imhist(im)
    //  [counts, cells] = imhist(im, bins)
    //  [counts, cells] = imhist(im, bins [,width [,color]])
    //
    // Parameters
    //  im : An image, which can be a boolean, uint8 , int8 , uint16 , int16 , int32 or double image.
    //  bins : The number of bins of the histogram. If bins is not specified, the function will used default value which determined by the image type: 2 for boolen, 2^8 for uint8 and int8, 2^16 for uint16 and int16, 2^16 for int32 (2^32 will need huge computer memory), and 10 for double. 
    //  width : This argument will be sent to bar function. It is a real scalar, defines the width (a percentage of the available room) for the bar (default: 0.8, i.e 80%).
    //  color : This argument will be sent to bar function. It is a string (default: 'blue'), specifing the inside color bar.
    //  counts : the returned histogram.
    //  cells : the intervals for bins.
    //   
    // Description
    //    imhist return the histogram of an image. If more than 2 arguments are give, the histogram will be shown in a figure.
    //    
    //    If step is the step of scalar cells (cells(i+1)=cells(i)+step), the i'th bin is half-open interval (cells(i)-step/2, cells(i)+step/2] for i > 1, and [cells(1)-step/2, cells(1)+step/2] for i=1.
    //  
    //    If more than 2 arguments are given, the function will call bar(cells, counts, ...) and send rest arguments to bar function to display the histogram.
    //
    // Supported image type
    //    BOOLEAN, UINT8, INT8, UINT16, INT16, INT32, DOUBLE.
    //
    // Examples
    //  im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //  im = rgb2gray(im);
    //  [count, cells]=imhist(im);
    //  [count, cells]=imhist(im, 10);
    //  scf(0); imhist(im, 10, '');
    //  scf(1); imhist(im, 10, 0.5);
    //  scf(2); imhist(im, 10, 'green');
    //  scf(3); imhist(im, 10, 0.8, 'green');
    //
    // See also
    //    mean2
    //    corr2
    //
    // Authors
    //    Shiqi Yu
    //    Tan Chin Luh
    
    
    
    if(size(size(im),2)>2)
        error("The input matrix im should be 2D matrix.");
    end

    bin=[];
    //if user specified 
    if length(varargin)>=1 then
        if varargin(1)~=floor(varargin(1)) then
            error("The seccond argument must be an integer.");
        elseif varargin(1)<=0 then
            error("The seccond argument must be a positive integer.");
        end
        bin = varargin(1);
        //elseif length(varargin)>2 then
        //  error("Too many arguments.");
    end

    imtype = typeof(im(1));

    select imtype
    case 'boolean' then
        if (isempty(bin) | bin>2) then, bin=2; end
        cells = linspace(0,1,bin);
    case 'uint8' then
        if isempty(bin) then, bin=2^8; end
        cells = linspace(0, 255, bin)
    case 'int8' then
        if isempty(bin) then, bin=2^8; end
        cells = linspace(-128, 127, bin)
    case 'uint16' then
        if isempty(bin) then, bin=2^16; end
        cells = linspace(0, 2^16-1, bin)
    case 'int16' then
        if isempty(bin) then, bin=2^16; end
        cells = linspace(-2^15, 2^15-1, bin)
    case 'int32' then
        if isempty(bin) then, 
            bin=2^16; 
            printf("The number of bins is set to 2^16 for int32 images."); 
        end
        cells = linspace(-2^31, 2^31-1, bin)
    case 'constant' then
        if isempty(bin) then, bin=10; end
        cells = linspace(0, 1, bin)
    else
        error("Data type " + imtype + " is not supported.");
    end

    if(bin > 1) then
        //such as for 256 bins of uint8 image
        //cells=[0,1,2,...,254,255]
        //new_cells=[-0.5, 0.5, 1.5, 2.5, ..., 254.5, 255.5]
        step2 = cells(2)-cells(1);
        new_cells = [cells, cells(length(cells))+step2 ] - step2/2;
        [tmp, counts, info]=dsearch(double(im), new_cells);
    elseif(bin ==1) then
        counts=length(im);
    end

    cells = cells';
    counts = counts';

    if length(varargin)>1 then
        if  bin < 50 then
            bar(cells, counts, varargin(2:length(varargin)));
            a = gca();
            a.auto_ticks = ['on' 'on' 'on' ];
        else
            plot2d3(cells,counts);
        end

    end
endfunction
