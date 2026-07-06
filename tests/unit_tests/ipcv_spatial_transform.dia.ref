//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated spatial transform source layer
//==============================================================================

img = imread(fullpath(getIPCVpath() + "/images/baboon.png"));

scaled = imresize(img, 0.5, "nearest");
assert_checkequal(typeof(scaled), "uint8");
assert_checkequal(size(scaled), [256 256 3]);

sized = imresize(img, [100 200], "bilinear");
assert_checkequal(typeof(sized), "uint8");
assert_checkequal(size(sized), [100 200 3]);

reduced = impyramid(img, "reduce");
assert_checkequal(typeof(reduced), "uint8");
assert_checkequal(size(reduced), [256 256 3]);

expanded = impyramid(reduced, "expand");
assert_checkequal(typeof(expanded), "uint8");
assert_checkequal(size(expanded), [512 512 3]);

//==============================================================================
