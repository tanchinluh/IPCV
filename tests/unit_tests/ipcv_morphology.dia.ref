//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated morphology source layer
//==============================================================================

se = imcreatese("rect", 3, 3);
assert_checkequal(typeof(se), "uint8");
assert_checkequal(size(se), [3 3]);
assert_checkequal(sum(double(se)), 9);

diamond = imcreatese("diamond", 5, 5);
assert_checkequal(typeof(diamond), "uint8");
assert_checkequal(size(diamond), [5 5]);
assert_checkequal(sum(double(diamond)), 13);

img = uint8(zeros(5, 5));
img(3, 3) = 255;

dilated = imdilate(img, se);
assert_checkequal(typeof(dilated), "uint8");
assert_checkequal(sum(double(dilated) > 0), 9);

wideDilated = imdilate(img, se, 2);
assert_checkequal(typeof(wideDilated), "uint8");
assert_checkequal(sum(double(wideDilated) > 0), 25);

eroded = imerode(dilated, se);
assert_checkequal(typeof(eroded), "uint8");
assert_checkequal(sum(double(eroded) > 0), 1);

opened = imopen(img, se);
assert_checkequal(typeof(opened), "uint8");
assert_checkequal(sum(double(opened)), 0);

closedInput = uint8(255 * ones(5, 5));
closedInput(3, 3) = 0;
closed = imclose(closedInput, se);
assert_checkequal(typeof(closed), "uint8");
assert_checkequal(min(double(closed)), 255);

gradient = imgradient(dilated, se);
assert_checkequal(typeof(gradient), "uint8");
assert_checktrue(sum(double(gradient)) > 0);

genericGradient = immorphologyex(dilated, se, "gradient");
assert_checkequal(genericGradient, gradient);

binaryMask = img > 0;
assert_checkequal(typeof(binaryMask), "boolean");
binaryDilated = imdilate(binaryMask, se);
assert_checkequal(typeof(binaryDilated), "uint8");
assert_checkequal(sum(double(binaryDilated) > 0), 9);

thickLine = uint8(zeros(7, 7));
thickLine(2:6, 3:5) = 255;
thinLine = imthin(thickLine);
assert_checkequal(typeof(thinLine), "uint8");
assert_checktrue(sum(double(thinLine) > 0) < sum(double(thickLine) > 0));
assert_checktrue(sum(double(thinLine) > 0) > 0);

//==============================================================================
