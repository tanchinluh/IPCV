//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated image I/O source layer
//==============================================================================

imagePath = fullpath(getIPCVpath() + "/images/baboon.png");

img = imread(imagePath);
assert_checkequal(typeof(img), "uint8");
assert_checkequal(size(img), [512 512 3]);

info = imfinfo(imagePath);
assert_checkequal(info(1), [512 512]);
assert_checkequal(info(3), 3);
assert_checkequal(info(4), 1);

patch = img(1:16, 1:16, :);
outPath = fullpath(TMPDIR + "/ipcv_image_io.png");
ret = imwrite(patch, outPath);
assert_checkequal(ret, 1);

roundtrip = imread(outPath);
assert_checkequal(size(roundtrip), [16 16 3]);
assert_checkequal(roundtrip, patch);

compressedPngPath = fullpath(TMPDIR + "/ipcv_image_io_compressed.png");
ret = imwrite(patch, compressedPngPath, 9);
assert_checkequal(ret, 1);
compressedPngRoundtrip = imread(compressedPngPath);
assert_checkequal(compressedPngRoundtrip, patch);

jpegPath = fullpath(TMPDIR + "/ipcv_image_io.jpg");
ret = imwrite(patch, jpegPath, 90);
assert_checkequal(ret, 1);
jpegRoundtrip = imread(jpegPath);
assert_checkequal(size(jpegRoundtrip), [16 16 3]);

multiPath = fullpath(getIPCVpath() + "/images/circbw.tif");
multiInfo = imfinfo(multiPath);
assert_checktrue(multiInfo(4) >= 1);
multi = imreadmulti(multiPath);
assert_checkequal(typeof(multi), "uint8");
assert_checktrue(size(multi, "*") > 0);

//==============================================================================
