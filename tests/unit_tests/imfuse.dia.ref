//==============================================================================
// IPCV - imfuse
//==============================================================================

a = uint8([10 20; 30 40]);
b = uint8([40 30; 20 10]);

cdiff = imfuse(a, b, "colordiff");
assert_checkequal(size(cdiff), [2 2 3]);
assert_checkequal(cdiff(:, :, 1), b);
assert_checkequal(cdiff(:, :, 2), a);
assert_checkequal(cdiff(:, :, 3), a);

comp = imfuse(a, b, "composite", 0.25);
assert_checkequal(size(comp), [2 2]);
assert_checktrue(abs(comp(1, 1) - (10 / 255 * 0.75 + 40 / 255 * 0.25)) < 0.000001);

assert_checkequal(imfuse(a, b, "diff"), uint8([30 10; 10 30]));
assert_checkequal(imfuse(a, b, "max"), uint8([40 30; 30 40]));
assert_checkequal(imfuse(a, b, "min"), uint8([10 20; 20 10]));

rgb = cat(3, a, a, a);
cdiffRgbGray = imfuse(rgb, b, "colordiff");
assert_checkequal(size(cdiffRgbGray), [2 2 3]);
assert_checkequal(cdiffRgbGray(:, :, 1), b);

compRgbGray = imfuse(rgb, b, "composite", 0.5);
assert_checkequal(size(compRgbGray), [2 2 3]);

//==============================================================================
