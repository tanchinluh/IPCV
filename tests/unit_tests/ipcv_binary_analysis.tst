//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated binary analysis source layer
//==============================================================================

ring = zeros(5, 5) == 1;
ring(2:4, 2) = %t;
ring(2:4, 4) = %t;
ring(2, 2:4) = %t;
ring(4, 2:4) = %t;

filled = imfill(ring);
assert_checkequal(typeof(filled), "uint8");
assert_checkequal(size(filled), [5 5]);
assert_checkequal(filled(3, 3), uint8(255));
assert_checkequal(sum(double(filled) > 0), 9);

components = zeros(5, 6) == 1;
components(2:3, 2:3) = %t;
components(4:5, 5:6) = %t;
[labels, n] = imlabel(components);
assert_checkequal(typeof(labels), "constant");
assert_checkequal(size(labels), [5 6]);
assert_checkequal(n, 2);

mask = zeros(5, 5) == 1;
mask(2:4, 2:4) = %t;
dist = imdistransf(mask, 1);
assert_checkequal(typeof(dist), "constant");
assert_checkequal(size(dist), [5 5]);
assert_checkequal(max(dist), 1);
assert_checkequal(dist(3, 3), 1);
assert_checkequal(dist(1, 1), 0);

rawDist = int_imdist(mask);
assert_checkequal(typeof(rawDist), "constant");
assert_checkequal(size(rawDist), [5 5]);
assert_checktrue(rawDist(3, 3) > rawDist(2, 2));

//==============================================================================
