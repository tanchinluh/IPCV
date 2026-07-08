//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2020  Tan Chin Luh
//=============================================================================
function varargout = sub2cart(dim, varargin)
// Convert from matrix subscript notation to cartesian coordinate in pixel mode
//
// Syntax
//    [cart_x,cart_y] = sub2cart(dim, sub_r,sub_c)
//
// Parameters
//     dim : Dimention of the Scilab matrix (first 2 dim of the matrix) in row and column format.
//     varargin : Input could be in sub_r and sub_c pairs (each in m x 1 matrix), or in m x 2 matrix which consist of [sub_r sub_c]
//          sub_r : Row index ins ubscript notation
//          sub_c : Column index ins ubscript notation
//     varargout : Output in cart_x and cart_y pairs or matrix of [cart_x cart_y] following in the input format
//          cart_x : X in cartesian coordinate system
//          cart_y : Y in cartesian coordinate system
//     
// Description
//    This function used to convert from matrix subscript notation to cartesian coordinate in pixel mode.
//
// Examples
//     S = rand(10,10);
//     S2 = repmat(S,[1,1,3]); 
//     S2(3,4,:) = [1,0,0];
//     imshow(S2); 
//     sub_r = 3; sub_c = 4; 
//     [cart_x,cart_y] = sub2cart([10 10], sub_r,sub_c)
//     plot(cart_x,cart_y, 'bx');
//
// See also
//     rect2cart
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
            sub_r = rect_coor(:,1);
            sub_c = rect_coor(:,2);
            out = 1;
        else
        error("Invalid 2nd argument."); end    
    end

    if rhs == 3;  then
        sub_r = varargin(1);
        sub_c = varargin(2);
        out = 2;
    end

    cart_x = sub_c;
    cart_y = dim(1) - sub_r + 1;
    varargout = list();
    
    if out == 2
        varargout = list(cart_x,cart_y);
    else
        varargout = list([cart_x cart_y]);
    end
    

    
endfunction
