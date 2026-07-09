//==============================================================================
// IPCV OpenCV 5 visualization helpers
//==============================================================================

image = uint8(zeros(20, 30, 3));
boxes = [5 6 10 8];
boxed = imdrawboxes(image, boxes, [0 255 0]);
assert_checkequal(size(boxed), [20 30 3]);
assert_checktrue(max(double(boxed(:, :, 2))) == 255);

mask = zeros(20, 30);
mask(6:12, 5:14) = 1;
overlay = imoverlaymask(image, mask, [255 0 0], 0.5, %f);
assert_checkequal(size(overlay), [20 30 3]);
assert_checktrue(max(double(overlay(:, :, 1))) > 0);
assert_checktrue(max(double(overlay(:, :, 2))) == 0);

overlayBoundary = imoverlaymask(image, mask, [255 0 0], 0.5, %t);
assert_checkequal(size(overlayBoundary), [20 30 3]);
assert_checktrue(max(double(overlayBoundary(:, :, 1))) == 255);

//==============================================================================
