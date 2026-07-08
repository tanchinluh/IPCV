//==============================================================================
// unit test immorphologyex
//==============================================================================

img = uint8(zeros(5, 5));
img(3, 3) = 255;
se = imcreatese("diamond", 3, 3);

dilated = immorphologyex(img, se, "dilate");
assert_checkequal(typeof(dilated), "uint8");
assert_checkequal(sum(double(dilated) > 0), 5);

dilated2 = immorphologyex(img, se, "dilate", 2);
assert_checkequal(sum(double(dilated2) > 0), 13);

eroded = immorphologyex(dilated, se, "erode");
assert_checkequal(sum(double(eroded) > 0), 1);

//==============================================================================
