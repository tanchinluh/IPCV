//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2020  Tan Chin Luh
//=============================================================================
function varargout = rect2cart(dim, varargin)
    // Convert from image rectangular coordinate to cartesian coordinate in pixel mode
    //
    // Syntax
    //    [cart_x,cart_y] = rect2cart(dim, rect_x, rect_y)
    //
    // Parameters
    //     dim : Dimention of the Scilab matrix (first 2 dim of the matrix) in row and column format, in [row col].
    //     varargin : Input could be in rect_x and rect_y pairs (each in m x 1 matrix), or in m x 2 matrix which consist of [rect_x rect_y]
    //          rect_x : X in rectangular coordinate system
    //          rect_y : Y in rectangular coordinate system
    //     varargout : Output in cart_x and cart_y pairs or matrix of [cart_x cart_y] following in the input format
    //          cart_x : X in cartesian coordinate system
    //          cart_y : Y in cartesian coordinate system
    //     
    // Description
    //    This function used to convert from image rectangular coordinate to cartesian coordinate in pixel mode.
    //
    // Examples
    //     S = rand(10,10);
    //     S2 = repmat(S,[1,1,3]); 
    //     S2(3,4,:) = [1,0,0];
    //     imshow(S2); 
    //     rect_x = 4; rect_y = 3; 
    //     [cart_x,cart_y] = rect2cart([10,10], rect_x, rect_y);
    //     plot(cart_x,cart_y, 'bx');
    //
    // See also
    //     sub2cart
    //
    // Authors
    //    Tan Chin Luh
    //
    rhs=argn(2);
    // Error Checking
    if rhs < 2; error("This function needs at least 2 inputs"); end    
    if rhs == 2;  then
        rect_coor = varargin(1);
        if size(rect_coor,2) == 2
            rect_x = rect_coor(:,1);
            rect_y = rect_coor(:,2);
            out = 1;
        else
        error("Invalid 2nd argument."); end    
    end

    if rhs == 3;  then
        rect_x = varargin(1);
        rect_y = varargin(2);
        out = 2;
    end

    cart_x = rect_x;
    cart_y = dim(1) - rect_y + 1;
    varargout = list();
    
    if out == 2
        varargout = list(cart_x,cart_y);
    else
        varargout = list([cart_x cart_y]);
    end
    
endfunction
