//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 Batch 11
// <-- NO CHECK REF -->
//==============================================================================

image = uint8(matrix(modulo(1:96, 256), 8, 12));
threshold = imadaptthresh(image, [3 3], 0.5);
assert_checkequal(size(threshold), size(image));
weight = imgradientweight(image);
assert_checkequal(size(weight), size(image));

glcm = imgraycomatrix(image, 8, [1 0; 0 1]);
assert_checkequal(size(glcm), [8 8 2]);
properties = imgraycoprops(glcm);
assert_checkequal(size(properties.Contrast), [1 2]);

[descriptor, codes] = imlbp(image, 1, 8);
assert_checkequal(size(codes), size(image));
assert_checkalmostequal(sum(descriptor), 1, 1e-12);

moments = immoments(image);
assert_checktrue(moments.M00 > 0);
angle = imorientation(image);
assert_checktrue(angle >= -90 & angle <= 90);
mask = zeros(8, 12) == 1;
mask(2:7, 3:9) = %t;
feret = imferet(mask);
assert_checktrue(feret.MaxDiameter > 0);
localVariance = imlocalvar(image, [3 3]);
assert_checkequal(size(localVariance), size(image));

rgb = uint8(cat(3, image, image, image));
colorMask = imcolormask(rgb, [0 0 0], [1 1 1], "rgb");
assert_checkequal(size(colorMask), size(image));
cropped = imresizecrop(rgb, [6 8]);
assert_checkequal(size(cropped), [6 8 3]);

volume = zeros(5, 6, 3);
volume(2:4, 2:5, 2) = 1;
adjusted = imadjust3(volume);
blurred = imgaussianblur3(volume, 1);
medianVolume = immedian3(volume, [3 3 3]);
boxed = imboxfilt3(volume, [3 3 3]);
assert_checkequal(size(adjusted), size(volume));
assert_checkequal(size(blurred), size(volume));
assert_checkequal(size(medianVolume), size(volume));
assert_checkequal(size(boxed), size(volume));
