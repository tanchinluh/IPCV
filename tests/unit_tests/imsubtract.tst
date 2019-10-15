//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imsubtract
//==============================================================================

a = uint8(rand(100,100).*100);
b = uint8(rand(100,100).*100);
y = imsubtract(a,b);
assert_checkequal(type(a),type(y));
y2 = imsubtract(a,10);
assert_checkequal(type(a),type(y2));
//==============================================================================
