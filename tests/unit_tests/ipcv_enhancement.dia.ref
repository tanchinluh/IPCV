//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated enhancement/restoration source layer
//==============================================================================

base = [10 20 30 40; 50 60 70 80; 90 100 110 120; 130 140 150 160];

freq = imdct(base);
assert_checkequal(typeof(freq), "constant");
assert_checkequal(size(freq), [4 4]);

roundTrip = imidct(freq);
assert_checktrue(max(abs(roundTrip - base)) < 0.000001);

gray = uint8(base);
equalized = imadapthistequal(gray, 2);
assert_checkequal(typeof(equalized), "uint8");
assert_checkequal(size(equalized), [4 4]);

rgb = uint8(zeros(4, 4, 3));
rgb(:, :, 1) = gray;
rgb(:, :, 2) = uint8(160 - base);
rgb(:, :, 3) = uint8(80 * ones(4, 4));
equalizedRgb = imadapthistequal(rgb, 2);
assert_checkequal(typeof(equalizedRgb), "uint8");
assert_checkequal(size(equalizedRgb), [4 4 3]);
assert_checktrue(sum(abs(double(equalizedRgb) - double(rgb))) > 0);

globalEqualizedGray = imhistequal(gray);
assert_checkequal(typeof(globalEqualizedGray), "uint8");
assert_checkequal(size(globalEqualizedGray), [4 4]);

globalEqualizedRgb = imhistequal(rgb);
assert_checkequal(typeof(globalEqualizedRgb), "uint8");
assert_checkequal(size(globalEqualizedRgb), [4 4 3]);
assert_checktrue(sum(abs(double(globalEqualizedRgb) - double(rgb))) > 0);

damaged = uint8(100 * ones(5, 5));
damaged(3, 3) = uint8(0);
mask = uint8(zeros(5, 5));
mask(3, 3) = uint8(255);
restored = iminpaint(damaged, mask, 1, 1);
assert_checkequal(typeof(restored), "uint8");
assert_checkequal(size(restored), [5 5]);
assert_checktrue(restored(3, 3) > uint8(0));

denoised = imdenoise(rgb, 3, 3, 7, 21);
assert_checkequal(typeof(denoised), "uint8");
assert_checkequal(size(denoised), [4 4 3]);

//==============================================================================
