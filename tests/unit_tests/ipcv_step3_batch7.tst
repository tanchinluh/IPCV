//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 Batch 7
// <-- NO CHECK REF -->
//==============================================================================

image = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
translated = imtranslate(image, [3 2]);
assert_checkequal(size(translated), size(image));

pair = imshowpair(image, imflip(image, "vertical"), "diff");
assert_checkequal(size(pair, 1), size(image, 1));

limits = imstretchlim(image);
assert_checkequal(size(limits), [2 3]);
assert_checktrue(min(limits) >= 0);
assert_checktrue(max(limits) <= 1);
bright = imlocalbrighten(image, 0.5, 10);
assert_checkequal(size(bright), size(image));

gray = rgb2gray(image);
connected = imgrayconnected(gray, [100 100], 30, 8);
assert_checkequal(typeof(connected), "boolean");

[quantized, edges] = imquantize(gray, [64 128 192]);
assert_checkequal(size(quantized), size(gray));
assert_checktrue(max(quantized) <= 4);
multiEdges = immultithresh(gray, 2);
assert_checkequal(size(multiEdges, "*"), 2);
[quantizedMulti, multiEdges2] = imquantize(gray, 2);
assert_checkequal(size(quantizedMulti), size(gray));
assert_checkequal(size(multiEdges2, "*"), 2);

euler = imbweuler(connected, 8);
assert_checktrue(type(euler) == 1);
[eulerX, eulerY] = meshgrid(1:260, 1:180);
eulerSolid = (eulerX - 45).^2 + (eulerY - 50).^2 <= 25^2;
eulerRing = ((eulerX - 125).^2 + (eulerY - 50).^2 <= 30^2) & ((eulerX - 125).^2 + (eulerY - 50).^2 >= 13^2);
eulerPlate = (eulerX >= 130) & (eulerX <= 235) & (eulerY >= 105) & (eulerY <= 165);
eulerHoles = ((eulerX - 160).^2 + (eulerY - 135).^2 < 12^2) | ((eulerX - 205).^2 + (eulerY - 135).^2 < 12^2);
eulerMask = eulerSolid | eulerRing | (eulerPlate & ~eulerHoles);
assert_checkequal(imbweuler(eulerMask, 8), 0);
assert_checkequal(imbweuler(imfill(eulerMask), 8), 3);
geodesic = imbwdistgeodesic(connected, [100 100], 8);
assert_checkequal(size(geodesic), size(connected));

labelImage = gray > 128;
[labels2d, count2d] = imlabeln(labelImage, 8);
assert_checktrue(count2d > 0);
assert_checkequal(size(labels2d), size(gray));

[projection, radius] = imradon(gray, 0:45:135);
reconstructed = imiradon(projection, 0:45:135, 32);
assert_checkequal(size(reconstructed), [32 32]);

[accumulator, rho, theta] = imhough(gray);
peaks = imhoughpeaks(accumulator, 2);
assert_checkequal(size(peaks, 1), 2);
lines = imhoughlines(rho, theta, peaks, size(gray));
assert_checkequal(size(lines, 2), 4);
assert_checktrue(and(lines(:, 1) >= 1 & lines(:, 1) <= size(gray, 2)));
assert_checktrue(and(lines(:, 2) >= 1 & lines(:, 2) <= size(gray, 1)));
assert_checktrue(and(lines(:, 3) >= 1 & lines(:, 3) <= size(gray, 2)));
assert_checktrue(and(lines(:, 4) >= 1 & lines(:, 4) <= size(gray, 1)));
assert_checktrue(and(sqrt((lines(:, 3) - lines(:, 1)).^2 + (lines(:, 4) - lines(:, 2)).^2) > 0));

corners = imcorner(image, 20, 0.01, 2);
assert_checkequal(size(corners, 2), 2);
hog = imhog(image, [16 16], [2 2], 9);
assert_checktrue(size(hog, "*") > 0);

psf = imfspecial("gaussian", 5, 1);
restored1 = imdeconvblind(gray, psf, 2);
restored2 = imdeconvreg(gray, psf, 0.01);
assert_checkequal(size(restored1), size(gray));
assert_checkequal(size(restored2), size(gray));
