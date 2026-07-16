//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 Batch 13
// <-- NO CHECK REF -->
//==============================================================================

mask = zeros(32, 32) == 1;
mask(8:14, 8:14) = %t;
mask(20:28, 20:28) = %t;
filtered = imbwpropfilt(mask, "area", [40 %inf]);
assert_checktrue(sum(matrix(filtered, -1, 1)) > sum(matrix(mask, -1, 1)) / 2);
boundary = imbwtraceboundary(mask, [10 10]);
assert_checktrue(size(boundary, 1) > 0);

ref2 = imref2d([32 32], [0 32], [0 32]);
ref3 = imref3d([8 9 4]);
config = imregconfig("multimodal");
assert_checkequal(ref2.ImageSize, [32 32]);
assert_checkequal(ref3.ImageSize, [8 9 4]);
assert_checkequal(config.Metric, "mutual-information");

volume = zeros(12, 14, 5);
volume(3:6, 4:8, 2:3) = 1;
volume(10, 12, 5) = 1;
clean = imbwareaopen3(volume, 4);
surface = imbwperim3(clean);
filled = imfill3(clean);
[labels, centers] = imsegkmeans3(double(volume), 2);
assert_checkequal(size(clean), size(volume));
assert_checkequal(size(surface), size(volume));
assert_checkequal(size(filled), size(volume));
assert_checkequal(size(labels), size(volume));
assert_checkequal(size(centers, "*"), 2);

a = uint8([0 15 255]);
b = uint8([255 3 15]);
assert_checkequal(imbitwise(a, b, "and"), uint8([0 3 15]));
assert_checkequal(imbitwise(a, "not"), bitcmp(a, 8));
[map1, map2] = imconvertmaps([0.1 1.2], [2.3 3.4], 10);
assert_checkequal(map1, int32([1 12]));
assert_checkequal(map2, int32([23 34]));

image = imread(fullpath(getIPCVpath() + "/images/opencv_smarties.png"));
harris = imdetect_HARRIS(image, 100, 0.01, 3, 3, 0.04);
kaze = imdetect_KAZE(image);
akaze = imdetect_AKAZE(image);
assert_checkequal(harris.type, "HARRIS");
assert_checkequal(kaze.type, "KAZE");
assert_checkequal(akaze.type, "AKAZE");
assert_checkequal(size(harris.x, 2), harris.n);
assert_checkequal(size(kaze.x, 2), kaze.n);
assert_checkequal(size(akaze.x, 2), akaze.n);
if kaze.n > 0 then
    kazeDescriptors = imextract_DescriptorKAZE(image, kaze);
    assert_checkequal(size(kazeDescriptors, 1), kaze.n);
end
if akaze.n > 0 then
    akazeDescriptors = imextract_DescriptorAKAZE(image, akaze);
    assert_checkequal(size(akazeDescriptors, 1), akaze.n);
end

drawn = imdrawkeypoints(image, akaze, [255 0 0]);
assert_checkequal(size(drawn), size(image));
