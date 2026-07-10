//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 IPCV-style naming batch
// <-- NO CHECK REF -->
//==============================================================================

gray = uint8([0 0 0 0 0; 0 20 40 20 0; 0 40 80 40 0; 0 20 40 20 0; 0 0 0 0 0]);
kernel = imfspecial("average", 3);
filtered = imfilter2(gray, kernel);
assert_checkequal(typeof(filtered), "constant");
assert_checkequal(size(filtered), [5 5]);

edges = imedge(gray, "sobel", 0.1, "both");
assert_checkequal(size(edges), [5 5]);

assert_checktrue(immean2(gray) > 0);
assert_checktrue(imstd2(gray) > 0);
assert_checktrue(imstdev2(gray) > 0);
assert_checkalmostequal(imcorr2(gray, gray), 1, 1e-12);
normalized = immat2gray(gray);
assert_checktrue(min(normalized) >= 0);
assert_checktrue(max(normalized) <= 1);

mask = zeros(7, 7) == 1;
mask(2:4, 2:4) = %t;
mask(6, 6) = %t;
assert_checkequal(typeof(imbwareaopen(mask, 2)), "boolean");
assert_checkequal(typeof(imbwareafilt(mask, [2 20])), "boolean");
assert_checkequal(typeof(imbwperim(mask)), "boolean");
assert_checkequal(typeof(imbwselect(mask, 2, 2)), "boolean");
assert_checkequal(typeof(imbwhitmiss(mask, imcreatese("cross", 3, 3))), "boolean");
assert_checkequal(typeof(imbwthin(mask)), "boolean");
assert_checkequal(typeof(imbwmorph(mask, "open")), "boolean");

[labels, count] = imlabel(mask);
rgb = imlabel2rgb(labels);
assert_checkequal(count, 2);
assert_checkequal(typeof(rgb), "uint8");
assert_checkequal(size(rgb), [7 7 3]);

polygon = impoly2mask([2 5 5 2], [2 2 5 5], 7, 7);
assert_checktrue(polygon(3, 3));
boundaries = imbwboundaries(mask);
assert_checktrue(size(boundaries) > 0);

//==============================================================================
