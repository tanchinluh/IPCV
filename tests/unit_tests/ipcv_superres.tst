//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated super-resolution source layer
//==============================================================================

S = list();
S(1) = imread(fullpath(getIPCVpath() + "/images/superres/input001.png"));
S(2) = imread(fullpath(getIPCVpath() + "/images/superres/input002.png"));
p = imsuperres_params();
p.iter = 1;
out = imsuperres(S, p);
assert_checkequal(size(out), [256 256 3]);
assert_checkequal(typeof(out), "uint8");

//==============================================================================
