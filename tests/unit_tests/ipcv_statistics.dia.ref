//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test image analysis/statistics helpers
//==============================================================================

gray = uint8([0 1 2; 3 4 5]);
[meanValue, stdValue] = immeanstddev(gray);
assert_checkequal(size(meanValue), [1 1]);
assert_checkequal(meanValue, 2.5);
assert_checktrue(abs(stdValue - sqrt(mean(([0; 1; 2; 3; 4; 5] - 2.5).^2))) < 0.000001);

[minValue, maxValue] = imminmax(gray);
assert_checkequal(minValue, 0);
assert_checkequal(maxValue, 5);

count = imcountnonzero(gray);
assert_checkequal(count, 5);

rgb = cat(3, gray, gray + 1, uint8(ones(2, 3) * 10));
[rgbMean, rgbStd] = immeanstddev(rgb);
assert_checkequal(size(rgbMean), [1 3]);
assert_checkequal(size(rgbStd), [1 3]);
assert_checkequal(rgbMean(3), 10);
assert_checkequal(rgbStd(3), 0);

[rgbMin, rgbMax] = imminmax(rgb);
assert_checkequal(rgbMin, [0 1 10]);
assert_checkequal(rgbMax, [5 6 10]);

rgbCount = imcountnonzero(rgb);
assert_checkequal(rgbCount, [5 6 6]);

//==============================================================================
