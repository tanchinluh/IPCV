//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated Hough and stitching source layer
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/2lines.png"));
[HM, rho, th] = imhough(S);
assert_checkequal(sum(HM > 30), 2);

overlay = int_imhough(S);
assert_checkequal(size(overlay), [100 100 3]);

circles = int_imhoughcircles(imread(fullpath(getIPCVpath() + "/images/coins.png")));
assert_checktrue(size(circles, 1) == 0 | size(circles, 1) == 3);

C = uint8(zeros(120, 120));
t = 0:%pi/180:2*%pi;
x = round(60 + 30*cos(t));
y = round(60 + 30*sin(t));
C(sub2ind(size(C), y, x)) = 255;
circles = imhoughc(C);
assert_checkequal(size(circles, 1), 3);
assert_checktrue(size(circles, 2) >= 1);

imgs = list();
imgs(1) = imread(fullpath(getIPCVpath() + "/images/stitching/sk1.jpg"));
imgs(2) = imread(fullpath(getIPCVpath() + "/images/stitching/sk2.jpg"));
stitched = imstitchimage(imgs);
assert_checktrue(size(stitched, 1) >= 590);
assert_checktrue(size(stitched, 2) >= 1090);
assert_checkequal(size(stitched, 3), 3);

//==============================================================================
