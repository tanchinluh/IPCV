//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imadapthistequal(x,cl)
    
    
    rhs=argn(2);

    // Error Checking
    if rhs < 1; error("Expect at least 1 argument, source image"); end    
    if rhs < 2; cl = 3; end

    // Setting default behavior
    if type(x(1))~=8 then
        x2 = im2uint8(x);
    else
        x2 = x;
    end
    
    y = int_imadapthistequal(x2,cl);
    
    if type(x(1))~=8 then
       str = 'im2'+typeof(x(1)) + '(y)';
       y =  evstr(str);
    end
        
    
    
endfunction
