//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
// Undocumented function which in called by IPCV 
function p = angle(h)

    p = atan(imag(h), real(h));


endfunction

