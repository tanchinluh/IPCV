//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 new feature batch
// <-- NO CHECK REF -->
//==============================================================================

image = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
assert_checkequal(size(imflip(image, "horizontal")), size(image));
assert_checkequal(size(impadarray(image, [2 3], "replicate")), [size(image, 1) + 4 size(image, 2) + 6 3]);

tiles = imtile(list(image, imflip(image, "vertical")), [1 2]);
assert_checkequal(typeof(tiles), "uint8");
assert_checkequal(size(tiles, 3), 3);

se = imcreatese("ellipse", 5, 5);
assert_checkequal(size(imbothat(image, se)), size(image));

[labels, centers] = imsegkmeans(image, 3);
assert_checkequal(size(labels), [size(image, 1) size(image, 2)]);
assert_checkequal(size(centers), [3 3]);

small = imread(fullpath(getIPCVpath() + "/images/people.jpg"));
[mask, foreground] = imgrabcut(small, [20 20 size(small, 2) - 40 size(small, 1) - 40], 1);
assert_checkequal(typeof(mask), "uint8");
assert_checkequal(size(foreground), size(small));

[superLabels, contours] = imsuperpixels(image, 32, 10, 2);
assert_checkequal(size(superLabels), [size(image, 1) size(image, 2)]);
assert_checkequal(size(contours), [size(image, 1) size(image, 2)]);

binary = zeros(12, 12) == 1;
binary(3:5, 4:7) = %t;
binary(8:10, 8:10) = %t;
[componentLabels, componentCount] = imconnectedcomponents(binary, 8);
props = imregionprops(componentLabels);
assert_checkequal(componentCount, 2);
assert_checkequal(length(props), 2);
assert_checkequal(props(1).Area, 12);
assert_checktrue(imentropy(image) > 0);
assert_checktrue(imrange(image) > 0);
assert_checktrue(imvar(image) > 0);

ordered = imordfilt(uint8([1 2 3; 4 5 6; 7 8 9]), 5, [3 3]);
assert_checkequal(ordered(2, 2), uint8(5));
assert_checkequal(typeof(ordered), "uint8");
orderedDouble = imordfilt([0.1 0.2 0.3; 0.4 0.5 0.6; 0.7 0.8 0.9], 5, [3 3]);
assert_checkequal(typeof(orderedDouble), "constant");
assert_checkequal(orderedDouble(2, 2), 0.5);

deff("y=feature_mean(x)", "y=mean(x)");
filtered = imcolfilt(uint8([1 2 3; 4 5 6; 7 8 9]), [3 3], "feature_mean");
assert_checktrue(filtered(2, 2) > 0);

flat = imflatfield(image, 10);
assert_checkequal(size(flat), size(image));
