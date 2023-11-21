//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imsuperres
//==============================================================================
S = list();
S(1) = imread(fullpath(getIPCVpath() + "/images/superres/input001.png"));
S(2) = imread(fullpath(getIPCVpath() + "/images/superres/input002.png"));
p = imsuperres_params();
p.iter = 1;
assert_checkalmostequal(size(imsuperres(S,p)),[256,256,3]);

//==============================================================================
