//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 image-processing completeness
// <-- NO CHECK REF -->
//==============================================================================

gray = uint8([0 100; 150 255]);
[binary, fixedLevel] = imthreshold(gray, 0.5, "binary");
assert_checkequal(binary, uint8([0 0; 255 255]));
assert_checkequal(fixedLevel, 0.5);

[inverse, inverseLevel] = imthreshold(gray, 0.5, "binary_inv");
assert_checkequal(inverse, uint8([255 255; 0 0]));
assert_checkequal(inverseLevel, 0.5);

[truncated, truncatedLevel] = imthreshold(gray, 0.5, "trunc");
assert_checkequal(truncated, uint8([0 100; 128 128]));
assert_checkequal(truncatedLevel, 0.5);

bimodal = uint8([zeros(4, 4), 255 * ones(4, 4)]);
[otsu, otsuLevel] = imthreshold(bimodal);
assert_checkequal(typeof(otsu), "uint8");
assert_checktrue(otsuLevel >= 0 & otsuLevel <= 1);
assert_checkequal(sum(double(otsu) > 0), 16);

[bw, bwLevel] = imbinarize(gray, 0.5);
assert_checkequal(typeof(bw), "boolean");
assert_checkequal(bw, [%f %f; %t %t]);
assert_checkequal(bwLevel, 0.5);

components = zeros(5, 6) == 1;
components(2:3, 2:3) = %t;
components(4:5, 5:6) = %t;
[labels, count, stats, centroids] = imconnectedcomponents(components, 8);
assert_checkequal(typeof(labels), "constant");
assert_checkequal(size(labels), [5 6]);
assert_checkequal(count, 2);
assert_checkequal(stats, [2 2 2 2 4; 5 4 2 2 4]);
assert_checkequal(centroids, [2.5 2.5; 5.5 4.5]);

diagonal = [%t %f; %f %t];
[labels4, count4] = imconnectedcomponents(diagonal, 4);
[labels8, count8] = imconnectedcomponents(diagonal, 8);
assert_checkequal(count4, 2);
assert_checkequal(count8, 1);
assert_checkequal(max(labels4), 2);
assert_checkequal(max(labels8), 1);

[legacyLabels, legacyCount] = imlabel(diagonal);
assert_checkequal(legacyCount, 2);
assert_checkequal(legacyLabels, labels4);

assert_checktrue(execstr("imconnectedcomponents(components, 6);", "errcatch") <> 0);
assert_checktrue(execstr("imthreshold(gray, [], ""binary"");", "errcatch") <> 0);

//==============================================================================
