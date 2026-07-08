//==============================================================================
// unit test imthin
//==============================================================================

img = uint8(zeros(7, 7));
img(2:6, 3:5) = 255;

out1 = imthin(img);
out2 = imthin(img, "guo-hall");

assert_checkequal(typeof(out1), "uint8");
assert_checkequal(typeof(out2), "uint8");
assert_checktrue(sum(double(out1) > 0) > 0);
assert_checktrue(sum(double(out1) > 0) < sum(double(img) > 0));
assert_checktrue(sum(double(out2) > 0) > 0);

//==============================================================================
