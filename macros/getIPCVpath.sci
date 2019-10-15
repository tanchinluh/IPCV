//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function p = getIPCVpath()
    p = [];
    if isdef('ipcvlib') then
        [m, mp] = libraryinfo('ipcvlib');
        p = pathconvert(fullpath(mp + "/../"), %t, %t);
    end
endfunction
