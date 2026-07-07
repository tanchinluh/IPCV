//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated edge/detail filtering source layer
//==============================================================================

noisy = uint8([10 10 10; 10 255 10; 10 10 10]);
filtered = immedian(noisy, 3);
assert_checkequal(typeof(filtered), "uint8");
assert_checkequal(size(filtered), [3 3]);
assert_checkequal(filtered(2, 2), uint8(10));

img = uint8(zeros(7, 7));
img(:, 4:7) = uint8(255);

sobelEdges = edge(img, "sobel", 0.1, "vertical");
assert_checkequal(typeof(sobelEdges), "boolean");
assert_checkequal(size(sobelEdges), [7 7]);
assert_checktrue(sum(double(sobelEdges)) > 0);

cannyEdges = edge(img, "canny", [0.06, 0.2], 3);
assert_checkequal(typeof(cannyEdges), "boolean");
assert_checkequal(size(cannyEdges), [7 7]);
assert_checktrue(sum(double(cannyEdges)) > 0);

flatSobel = int_sobel(uint8(ones(4, 4)), 1, 0);
assert_checkequal(typeof(flatSobel), "constant");
assert_checkequal(size(flatSobel), [4 4]);
assert_checkequal(sum(flatSobel), 0);

//==============================================================================
