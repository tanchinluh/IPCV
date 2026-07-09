//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated filtering source layer
//==============================================================================

kernel = [1 1 1; 1 1 1; 1 1 1] ./ 9;

gray = uint8([10 20 30; 40 50 60; 70 80 90]);
filteredSame = imfilter(gray, kernel);
assert_checkequal(typeof(filteredSame), "uint8");
assert_checkequal(size(filteredSame), [3 3]);

filteredDouble = filter2(gray, kernel);
assert_checkequal(typeof(filteredDouble), "constant");
assert_checkequal(size(filteredDouble), [3 3]);

color = cat(3, gray, gray + 1, gray + 2);
filteredColor = imfilter(color, kernel);
assert_checkequal(typeof(filteredColor), "uint8");
assert_checkequal(size(filteredColor), [3 3 3]);

blurred = imblur(gray, [3 3]);
assert_checkequal(typeof(blurred), "uint8");
assert_checkequal(size(blurred), [3 3]);
assert_checkequal(blurred, filteredSame);

blurredColor = imblur(color, 3);
assert_checkequal(typeof(blurredColor), "uint8");
assert_checkequal(size(blurredColor), [3 3 3]);

gaussian = imgaussianblur(gray, [3 3], 0);
assert_checkequal(typeof(gaussian), "uint8");
assert_checkequal(size(gaussian), [3 3]);

bilateral = imbilateralfilter(gray, 3, 30, 30);
assert_checkequal(typeof(bilateral), "uint8");
assert_checkequal(size(bilateral), [3 3]);

//==============================================================================
