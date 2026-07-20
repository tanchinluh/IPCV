//==============================================================================
// IPCV native 3-D volume processing regression tests
// <-- NO CHECK REF -->
//==============================================================================

// 3-D connected-component labeling must distinguish face and corner contact.
mask = zeros(4, 4, 3) == 1;
mask(2, 2, 1) = %t;
mask(3, 3, 2) = %t;
[labels6, count6] = imlabeln(mask, 6);
[labels18, count18] = imlabeln(mask, 18);
[labels26, count26] = imlabeln(mask, 26);
assert_checkequal(count6, 2);
assert_checkequal(count18, 2);
assert_checkequal(count26, 1);
assert_checkequal(size(labels26), [4 4 3]);
assert_checkequal(typeof(labels26), "constant");

// Entire flat plateaus are regional maxima.
peaks = zeros(5, 5, 3);
peaks(2:3, 2:3, 2) = 5;
maxima = imregionalmax3(peaks, 26);
assert_checkequal(typeof(maxima), "boolean");
assert_checkequal(sum(matrix(maxima, -1, 1)), 4);
assert_checktrue(and(maxima(2:3, 2:3, 2)));

peaks(4, 4, 3) = 6;
maxima = imregionalmax3(peaks, 26);
assert_checkequal(sum(matrix(maxima, -1, 1)), 1);
assert_checktrue(maxima(4, 4, 3));

// Native dilation observes the selected 3-D neighborhood.
seed = zeros(5, 5, 5) == 1;
seed(3, 3, 3) = %t;
dilated6 = imbwmorph3(seed, "dilate", 1, 6);
dilated26 = imbwmorph3(seed, "dilate", 1, 26);
assert_checkequal(sum(matrix(dilated6, -1, 1)), 7);
assert_checkequal(sum(matrix(dilated26, -1, 1)), 27);

solid = zeros(5, 5, 5) == 1;
solid(2:4, 2:4, 2:4) = %t;
eroded = imbwmorph3(solid, "erode", 1, 26);
assert_checkequal(sum(matrix(eroded, -1, 1)), 1);
assert_checktrue(eroded(3, 3, 3));

// Area opening, perimeter extraction, and cavity filling are volumetric.
objects = solid;
objects(1, 1, 1) = %t;
opened = imbwareaopen3(objects, 2, 6);
assert_checkequal(sum(matrix(opened, -1, 1)), 27);

perimeter = imbwperim3(solid, 6);
assert_checkequal(sum(matrix(perimeter, -1, 1)), 26);
assert_checkfalse(perimeter(3, 3, 3));

shell = solid;
shell(3, 3, 3) = %f;
filled = imfill3(shell, 6);
assert_checkequal(sum(matrix(filled, -1, 1)), 27);
assert_checktrue(filled(3, 3, 3));

// Native filters normalize integer inputs and preserve double-volume intensity ranges.
impulse = zeros(5, 5, 5);
impulse(3, 3, 3) = 1;
box = imboxfilt3(impulse, [3 3 3]);
assert_checkequal(size(box), [5 5 5]);
assert_checkalmostequal(box(3, 3, 3), 1 / 27, 1e-12);
assert_checkalmostequal(sum(matrix(box, -1, 1)), 1, 1e-12);

constantVolume = ones(5, 6, 4) * 0.25;
gaussian = imgaussianblur3(constantVolume, 1.2);
assert_checkalmostequal(gaussian, constantVolume, 1e-12);

salt = zeros(5, 5, 5);
salt(3, 3, 3) = 1;
median = immedian3(salt, [3 3 3]);
assert_checkequal(median(3, 3, 3), 0);

// Native-range double volumes must not be clamped to [0, 1] before processing.
nativeRange = matrix(linspace(100, 4100, 7 * 9 * 5), 7, 9, 5);
nativeBox = imboxfilt3(nativeRange, 3);
nativeGaussian = imgaussianblur3(nativeRange, 1);
nativeMedian = immedian3(nativeRange, 3);
nativeGradient = imgradient3(nativeRange);
nativeAdjusted = imadjust3(nativeRange);
assert_checktrue(max(nativeBox) > 1000);
assert_checktrue(max(nativeGaussian) > 1000);
assert_checktrue(max(nativeMedian) > 1000);
assert_checktrue(max(nativeMedian) > min(nativeMedian));
assert_checktrue(max(nativeGradient) > 1);
assert_checkalmostequal(min(nativeAdjusted), 0, 1e-12);
assert_checkalmostequal(max(nativeAdjusted), 1, 1e-12);
[nativeUri, nativeDimensions, nativeRangeInfo] = int_volshowencode( ..
    nativeMedian, 64, [%nan %nan], 0);
assert_checkequal(nativeDimensions, [7 9 5]);
assert_checktrue(nativeRangeInfo(2) - nativeRangeInfo(1) > 1000);
assert_checktrue(strindex(nativeUri, "data:application/octet-stream;base64,") == 1);

integerRange = uint16(matrix(round(linspace(0, 65535, 7 * 9 * 5)), 7, 9, 5));
integerMedian = immedian3(integerRange, 3);
assert_checktrue(min(integerMedian) >= 0);
assert_checktrue(max(integerMedian) <= 1);
