//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 measurement and extrema batch
// <-- NO CHECK REF -->
//==============================================================================

mask = zeros(5, 6) == 1;
mask(2:4, 2:4) = %t;
assert_checkequal(imarea(mask), 9);
assert_checkequal(imcentroid(mask), [3 3]);
assert_checkequal(imboundingbox(mask), [2 2 3 3]);
assert_checkequal(imperimeter(mask), 12);

components = zeros(7, 8) == 1;
components(2, 2) = %t;
components(4:5, 5:6) = %t;
filtered = imbwareafilt(components, [2 4]);
assert_checkequal(sum(filtered), 4);
assert_checktrue(~filtered(2, 2));

constraint = zeros(7, 7) == 1;
constraint(2:6, 2:6) = %t;
marker = zeros(7, 7) == 1;
marker(4, 4) = %t;
reconstructed = imreconstruct(marker, constraint, 4);
assert_checkequal(sum(reconstructed), 25);

peaks = uint8([1 2 1; 2 4 2; 1 2 1]);
peakMask = imregionalmax(peaks);
assert_checkequal(sum(peakMask), 1);
assert_checktrue(peakMask(2, 2));
assert_checkequal(sum(imextendedmax(peaks, 2)), 1);

basins = uint8([4 2 4; 2 1 2; 4 2 4]);
basinMask = imregionalmin(basins);
assert_checkequal(sum(basinMask), 1);
assert_checktrue(basinMask(2, 2));
assert_checkequal(sum(imextendedmin(basins, 2)), 1);

gradientImage = uint8([0 0 0; 0 255 255; 0 255 255]);
[gx, gy] = imgradientxy(gradientImage);
magnitude = imgradientmagnitude(gradientImage);
assert_checkequal(size(gx), [3 3]);
assert_checkequal(size(gy), [3 3]);
assert_checkequal(size(magnitude), [3 3]);
assert_checktrue(sum(abs(magnitude - sqrt(gx .^ 2 + gy .^ 2))) == 0);

assert_checktrue(execstr("imbwareafilt(components, [4 2]);", "errcatch") <> 0);
assert_checktrue(execstr("imreconstruct(marker, ~constraint);", "errcatch") <> 0);

//==============================================================================
