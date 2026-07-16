//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 Batch 9
// <-- NO CHECK REF -->
//==============================================================================

image = uint8(matrix(modulo(1:256, 256), 16, 16));
mask = zeros(16, 16) == 1;
mask(5:12, 5:12) = %t;

autocorrelation = imautocorr(image);
assert_checkequal(size(autocorrelation), size(image));
assert_checktrue(imskewness(image) <> %nan);
assert_checktrue(imkurtosis(image) <> %nan);
assert_checktrue(immad(image) >= 0);

[fcmLabels, fcmCenters] = imsegfcm(image, 3, 3, 2);
assert_checkequal(size(fcmLabels), size(image));
assert_checkequal(size(fcmCenters), [3 1]);
activeMask = imsegactivecontour(image, mask, 2, 1);
assert_checkequal(size(activeMask), size(image));
phase = imphasecong(image, 0.1);
ridge = imridge(image);
assert_checkequal(size(phase), size(image));
assert_checkequal(size(ridge), size(image));

volume = zeros(4, 5, 3);
volume(2:3, 2:4, 2) = 1;
resized = imresize3(volume, [8 10 6]);
cropped = imcrop3(volume, [1 1 1], [2 3 2]);
rotated = imrotate3(volume, 90, 3);
assert_checkequal(size(resized), [8 10 6]);
assert_checkequal(size(cropped), [2 3 2]);
assert_checkequal(size(rotated), [5 4 3]);
[magnitude, gx, gy, gz] = imgradient3(volume);
assert_checkequal(size(magnitude), size(volume));
assert_checkequal(size(gx), size(volume));

labelVolume = zeros(4, 5, 3);
labelVolume(2:3, 2:4, 2) = 1;
props3 = imregionprops3(labelVolume);
assert_checkequal(props3(1).Volume, 6);
slice = volume(:, :, 2);
assert_checkequal(size(slice), [4 5]);

objectPoints = [0 0 0; 1 0 0; 0 1 0; 1 1 0; 0 0 1; 1 0 1; 0 1 1; 1 1 1];
imagePoints = [320 240; 420 240; 320 340; 420 340; 320 240; 420 240; 320 340; 420 340];
cameraMatrix = [100 0 320; 0 100 240; 0 0 1];
[rotationVector, translationVector] = imsolvepnp(objectPoints, imagePoints, cameraMatrix);
assert_checkequal(size(rotationVector), [3 1]);
assert_checkequal(size(translationVector), [3 1]);

points1 = [10 10; 20 12; 30 15; 40 18; 12 25; 24 28; 36 32; 48 35];
points2 = [12 11; 24 13; 35 17; 46 21; 14 27; 26 31; 38 36; 52 41];
fundamental = imestimatefundamental(points1, points2);
assert_checkequal(size(fundamental), [3 3]);
projection1 = [100 0 0 0; 0 100 0 0; 0 0 1 0];
projection2 = [100 0 0 -10; 0 100 0 0; 0 0 1 0];
points3d = imtriangulate(points1, points2, projection1, projection2);
assert_checkequal(size(points3d), [8 3]);
