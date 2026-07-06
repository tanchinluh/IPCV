//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated image transform and segmentation source layer
//==============================================================================

I = zeros(5, 5);
I(3, 3) = 1;
[RT, xp] = imradon(I, [0 90]);
assert_checkequal(typeof(RT), "constant");
assert_checkequal(size(RT), [9 2]);
assert_checkequal(size(xp), [1 9]);
assert_checktrue(max(RT) > 0);

rgb = uint8(zeros(10, 10, 3));
rgb(1:5, :, 1) = uint8(200);
rgb(6:10, :, 2) = uint8(200);
rgb(:, :, 3) = uint8(40);

markers = zeros(10, 10);
markers(2, 2) = 1;
markers(8, 8) = 2;

labels = imwatershed(rgb, markers);
assert_checkequal(size(labels), [10 10]);
assert_checktrue(max(labels) >= 0);

//==============================================================================
