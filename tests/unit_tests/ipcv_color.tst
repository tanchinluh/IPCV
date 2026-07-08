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

labWrapperRoundTrip = lab2rgb(lab);
assert_checktrue(max(abs(double(labWrapperRoundTrip) - double(rgb))) <= 8);

hsv = rgb2hsv(rgb);
assert_checkequal(typeof(hsv), "uint8");
assert_checkequal(size(hsv), [2 2 3]);
assert_checkequal(hsv(1, 1, 1), uint8(0));
assert_checkequal(hsv(1, 1, 2), uint8(255));
assert_checkequal(hsv(1, 1, 3), uint8(255));
hsvRoundTrip = hsv2rgb2(hsv);
assert_checktrue(max(abs(double(hsvRoundTrip) - double(rgb))) <= 1);

ycc = rgb2ycbcr(rgb);
assert_checkequal(typeof(ycc), "uint8");
assert_checkequal(size(ycc), [2 2 3]);
assert_checkequal(matrix(ycc(1, 1, :), 1, 3), uint8([76 85 255]));
yccRoundTrip = ycbcr2rgb(ycc);
assert_checktrue(max(abs(double(yccRoundTrip) - double(rgb))) <= 1);

rawYCrCb = imcvtcolor(rgb, "rgb2ycrcb");
assert_checkequal(matrix(rawYCrCb(1, 1, :), 1, 3), uint8([76 255 85]));

hls = imcvtcolor(rgb, "rgb2hls");
assert_checkequal(typeof(hls), "uint8");
assert_checkequal(size(hls), [2 2 3]);
hlsRoundTrip = imcvtcolor(hls, "hls2rgb");
assert_checktrue(max(abs(double(hlsRoundTrip) - double(rgb))) <= 1);

hlsWrapper = rgb2hls(rgb);
assert_checkequal(hlsWrapper, hls);
hlsWrapperRoundTrip = hls2rgb(hlsWrapper);
assert_checktrue(max(abs(double(hlsWrapperRoundTrip) - double(rgb))) <= 1);

grayViaGeneric = imcvtcolor(rgb, "rgb2gray");
rgbViaGeneric = imcvtcolor(grayViaGeneric, "gray2rgb");
assert_checkequal(size(rgbViaGeneric), [2 2 3]);
assert_checkequal(rgbViaGeneric(:, :, 1), grayViaGeneric);
assert_checkequal(rgbViaGeneric(:, :, 2), grayViaGeneric);
assert_checkequal(rgbViaGeneric(:, :, 3), grayViaGeneric);

rgbViaWrapper = gray2rgb(grayViaGeneric);
assert_checkequal(rgbViaWrapper, rgbViaGeneric);

xyz = imcvtcolor(rgb, "rgb2xyz");
assert_checkequal(typeof(xyz), "uint8");
assert_checkequal(size(xyz), [2 2 3]);

xyzWrapper = rgb2xyz(rgb);
assert_checkequal(xyzWrapper, xyz);
xyzWrapperRoundTrip = xyz2rgb(xyzWrapper);
assert_checktrue(max(abs(double(xyzWrapperRoundTrip) - double(rgb))) <= 25);

luv = imcvtcolor(rgb, "rgb2luv");
assert_checkequal(typeof(luv), "uint8");
assert_checkequal(size(luv), [2 2 3]);

luvWrapper = rgb2luv(rgb);
assert_checkequal(luvWrapper, luv);
luvWrapperRoundTrip = luv2rgb(luvWrapper);
assert_checktrue(max(abs(double(luvWrapperRoundTrip) - double(rgb))) <= 8);

yuv = rgb2yuv(rgb);
assert_checkequal(typeof(yuv), "uint8");
assert_checkequal(size(yuv), [2 2 3]);
assert_checkequal(yuv, imcvtcolor(rgb, "rgb2yuv"));
yuvRoundTrip = yuv2rgb(yuv);
assert_checktrue(max(abs(double(yuvRoundTrip) - double(rgb))) <= 35);

//==============================================================================
