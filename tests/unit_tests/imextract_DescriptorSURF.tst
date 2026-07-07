//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imextract_DescriptorSURF 
// <-- NO CHECK REF -->
//==============================================================================

S = imcreatechecker(8,8,[1 0.5]);
fobj = imdetect_SURF(S);
assert_checkequal(fobj.type, "SURF");
if isfield(fobj, "available") & ~fobj.available then
    assert_checkequal(fobj.n, 0);
else
    des = imextract_DescriptorSURF(S,fobj);
    assert_checkequal(size(des),[392 64]);
end

//==============================================================================
