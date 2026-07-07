//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated color conversion source layer
//==============================================================================

rgb = uint8(zeros(2, 2, 3));
rgb(:, :, 1) = uint8([255 0; 0 255]);
rgb(:, :, 2) = uint8([0 255; 0 255]);
rgb(:, :, 3) = uint8([0 0; 255 255]);

gray = rgb2gray(rgb);
assert_checkequal(typeof(gray), "uint8");
assert_checkequal(size(gray), [2 2]);
assert_checkequal(gray(1, 1), uint8(76));

rgbDouble = double(rgb) / 255;
grayDouble = rgb2gray(rgbDouble);
assert_checkequal(typeof(grayDouble), "constant");
assert_checkequal(size(grayDouble), [2 2]);
assert_checktrue(abs(grayDouble(1, 1) - 0.299) < 0.001);

lab = rgb2lab(rgb);
assert_checkequal(typeof(lab), "uint8");
assert_checkequal(size(lab), [2 2 3]);

labRoundTrip = int_cvtcolor(lab, "lab2rgb");
assert_checkequal(typeof(labRoundTrip), "uint8");
assert_checkequal(size(labRoundTrip), [2 2 3]);
assert_checktrue(max(abs(double(labRoundTrip) - double(rgb))) <= 8);

hsv = rgb2hsv(rgb);
assert_checkequal(typeof(hsv), "uint8");
assert_checkequal(size(hsv), [2 2 3]);
hsvRoundTrip = hsv2rgb2(hsv);
assert_checktrue(max(abs(double(hsvRoundTrip) - double(rgb))) <= 1);

ycc = rgb2ycbcr(rgb);
assert_checkequal(typeof(ycc), "uint8");
assert_checkequal(size(ycc), [2 2 3]);
yccRoundTrip = ycbcr2rgb(ycc);
assert_checktrue(max(abs(double(yccRoundTrip) - double(rgb))) <= 1);

//==============================================================================
