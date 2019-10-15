//////////////////////////////////////////////////////////////////////////// 
// IPD - Image Processing Design Toolbox
//
// Copyright (c) by Dr. Eng. (J) Harald Galda, 2009 - 2011
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
////////////////////////////////////////////////////////////////////////////


function PaddedImage = PadImage(Image, PadValue, Left, Right, Up, Down)


    // Global variables used as constants are declared. 

    // global TYPE_INT;
    // 
    // global TYPE_DOUBLE;

    // Input and output parameters are checked.

    [NumberOfOutputs NumberOfInputs] = argn();

    if NumberOfInputs ~= 6

        error('Wrong number of input parameters.');

    end;

    // Removed checking routine for migration purpose Trity 9-July-2012

    // CheckMatrix(Image, 'Image');
    // 
    // CheckScalar(PadValue, 'PadValue');
    // 
    // CheckScalar(Left, 'Left');
    // 
    // CheckScalar(Right, 'Right');
    // 
    // CheckScalar(Up, 'Up');
    // 
    // CheckScalar(Down, 'Down');

    if NumberOfOutputs ~= 1

        error('Wrong number of output parameters.');

    end;

    // The size of Image is determined.

    [NumberOfRows NumberOfColumns] = size(Image);

    // PaddedImage is initialized.

    DataType = type(Image);

    if (DataType == 1) | (DataType == 8)

        PaddedImage = zeros(NumberOfRows + Up + Down, NumberOfColumns + Left + Right);

        if PadValue ~= 0 then

            PaddedImage(:) = PadValue;

        end; 

    else

        CompareValue = 0;

        if PadValue

            CompareValue = 1;

        end;

        PaddedImage = (ones(NumberOfRows + Up + Down, ...
        NumberOfColumns + Left + Right) == CompareValue);

    end;

    // Image is copied into PaddedImage.

    PaddedImage(Up + 1 : Up + NumberOfRows, ...
    Left + 1 : Left + NumberOfColumns) = Image;

endfunction





