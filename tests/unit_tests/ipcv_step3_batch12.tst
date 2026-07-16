//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 Batch 12
// <-- NO CHECK REF -->
//==============================================================================

image = uint8(matrix(modulo(1:64, 256), 8, 8));
wideImage = im2uint32(image);
assert_checkequal(typeof(wideImage), "uint32");

lut = uint8(255 - (0:255));
negative = imlut(image, lut);
assert_checkequal(negative(1, 1), uint8(254));
assert_checkequal(typeof(negative), "uint8");
assert_checkequal(size(negative), size(image));
colored = imapplycolormap(image, [0 0 0; 1 0 0]);
assert_checkequal(size(colored), [8 8 3]);

integralImage = imintegral(image);
assert_checkequal(size(integralImage), [9 9]);
assert_checkalmostequal(integralImage($, $), sum(matrix(double(image), -1, 1)), 1e-12);

mask = zeros(9, 9) == 1;
mask(3:7, 3:7) = %t;
distance = imbwdist(mask, "euclidean");
assert_checkequal(size(distance), size(mask));
assert_checkequal(distance(1, 1), 0);
assert_checktrue(max(distance) > 0);
grayDistance = imgraydist(ones(9, 9), [1 1], 4);
assert_checkequal(grayDistance(1, 1), 0);
ultimate = imbwulterode(mask);
assert_checktrue(sum(matrix(ultimate, -1, 1)) > 0);

enhanced = imlocallapfilt(image, 1, 1);
assert_checkequal(size(enhanced), size(image));
rgb = uint8(cat(3, image, image, image));
clearer = imreducehaze(rgb);
assert_checkequal(size(clearer), size(rgb));

volume = zeros(9, 10, 4);
volume(3:7, 4:8, 2:3) = 1;
translated = imtranslate3(volume, [1 1 1]);
maxima = imregionalmax3(volume, 26);
opened = imbwmorph3(volume, "open", 1, 6);
assert_checkequal(size(translated), size(volume));
assert_checkequal(size(maxima), size(volume));
assert_checkequal(size(opened), size(volume));
[x, y, z, values] = improfile3(volume, [1 1 1; 10 9 4]);
assert_checktrue(size(values, "*") > 1);

points = [2 3; 8 2; 11 7; 4 9];
rectangle = imminarearect(points);
circle = imminenclosingcircle(points);
assert_checktrue(rectangle.Area > 0);
assert_checktrue(circle.Radius > 0);
