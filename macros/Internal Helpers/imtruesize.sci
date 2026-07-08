//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
// Non-documented internal function
function imtruesize(fig_handle)
     
     
    rhs=argn(2);

    if rhs < 1;  fig_handle = gcf(); end

    sz = size(fig_handle.children.children($).data);
    
    fig_handle.axes_size = [sz(2) sz(1)];
endfunction
