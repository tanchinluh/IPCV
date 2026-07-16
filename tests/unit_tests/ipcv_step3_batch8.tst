//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 Batch 8
// <-- NO CHECK REF -->
//==============================================================================

gray = uint8(matrix(modulo(1:256, 256), 16, 16));
image = cat(3, gray, gray, gray);
reference = uint8(255 - double(gray));
matched = imhistmatch(gray, reference, 32);
assert_checkequal(size(matched), size(gray));

contrast = imlocalcontrast(gray, 2, 1);
assert_checkequal(size(contrast), size(gray));
hmax = imhmax(gray, 10);
hmin = imhmin(gray, 10);
assert_checkequal(size(hmax), size(gray));
assert_checkequal(size(hmin), size(gray));
assert_checkequal(typeof(hmax), "uint8");
assert_checkequal(typeof(hmin), "uint8");

minimums = zeros(16, 16) == 1;
minimums(8, 8) = %t;
imposed = imimposemin(gray, minimums);
assert_checkequal(size(imposed), size(gray));

majority = immajority(gray <> 0, [3 3]);
assert_checkequal(size(majority), size(gray));
entropyMap = imlocalentropy(gray, [3 3]);
assert_checkequal(size(entropyMap), size(gray));
texture = imtexture(gray, [3 3]);
assert_checktrue(isfield(texture, "Entropy"));

rectangleMask = imroi2mask([3 3 5 4], [16 16], "rectangle");
ellipseMask = imroi2mask([3 3 5 4], [16 16], "ellipse");
polygonMask = imroi2mask([2 2; 12 2; 8 12], [16 16], "polygon");
assert_checktrue(sum(rectangleMask) > 0);
assert_checktrue(sum(ellipseMask) > 0);
assert_checktrue(sum(polygonMask) > 0);

smoothed = immeanshift(gray, 2, 0.1, 1);
assert_checkequal(size(smoothed), size(gray));
template = gray(5:8, 5:8);
score = imtemplatematch(gray, template);
assert_checkequal(size(score), [13 13]);
assert_checktrue(min(score) >= 0 & max(score) <= 1);
backprojection = imbackproject(gray, template, 16);
assert_checkequal(size(backprojection), size(gray));

cameraMatrix = [10 0 8; 0 10 8; 0 0 1];
undistorted = imundistort(gray, cameraMatrix, [0 0 0 0]);
assert_checkequal(size(undistorted), size(gray));
identity = [1 0 0; 0 1 0; 0 0 1];
rectified = imrectify(gray, identity, [16 16]);
assert_checkequal(size(rectified), size(gray));
assert_checkequal(typeof(rectified), typeof(gray));
translationHomography = [1 0 1; 0 1 1; 0 0 1];
rectified = imrectify(gray, translationHomography, [16 16]);
assert_checkequal(typeof(rectified), "uint8");
assert_checkequal(rectified(3, 3), gray(2, 2));
rectified16 = imrectify(uint16(gray), translationHomography, [16 16]);
assert_checkequal(typeof(rectified16), "uint16");
rectifiedDouble = imrectify(double(gray) / 255, translationHomography, [16 16]);
assert_checkequal(typeof(rectifiedDouble), "constant");
rectifiedBoolean = imrectify(gray > 127, translationHomography, [16 16]);
assert_checkequal(typeof(rectifiedBoolean), "boolean");

noisy = imnoise(gray, "gaussian", 0, 0.001);
assert_checkequal(size(noisy), size(gray));
localNoisy = imnoise(gray, "localvar", zeros(gray) + 0.001);
assert_checkequal(size(localNoisy), size(gray));
lookupNoisy = imnoise(gray, "localvar", [0 0.5 1], [0.001 0.002 0.003]);
assert_checkequal(size(lookupNoisy), size(gray));

[profileX, profileY, profileValues] = improfile(gray, [1 1; 16 16]);
assert_checktrue(size(profileX, 1) > 1);
assert_checkequal(size(profileValues, 1), size(profileX, 1));
[registered, shift, rotation, scale] = imphasecorr(gray, gray);
assert_checkequal(size(registered), size(gray));
assert_checkequal(shift, [0 0]);
assert_checkequal(rotation, 0);
assert_checkequal(scale, 1);
smaller = gray(1:8, 1:8);
[registeredSmall, shiftSmall, rotationSmall, scaleSmall] = imphasecorr(gray, smaller);
assert_checkequal(size(registeredSmall), size(gray));
assert_checktrue(~isnan(rotationSmall) & abs(rotationSmall) <= 90);
assert_checktrue(scaleSmall > 1);

lenaTarget = imread(fullpath(getIPCVpath() + "/images/lena.bmp"));
lenaSource = imread(fullpath(getIPCVpath() + "/images/lena7030.bmp"));
[lenaRegistered, lenaShift, lenaRotation, lenaScale] = imphasecorr(lenaTarget, lenaSource);
assert_checkequal(size(lenaRegistered), [size(lenaTarget, 1) size(lenaTarget, 2)]);
assert_checktrue(lenaRotation > 25 & lenaRotation < 35);
assert_checktrue(lenaScale > 3 & lenaScale < 4);

filled = imfloodfill(gray, [8 8], 10, 4);
assert_checkequal(size(filled), size(gray));
localRange = imlocalrange(gray, [3 3]);
assert_checkequal(size(localRange), size(gray));

smallRgb = imresize(image, [32 32]);
transferred = imcolortransfer(smallRgb, smallRgb);
assert_checkequal(size(transferred), size(smallRgb));
diffused = imdiffusefilt(gray, 1, 0.1, 0.2);
guided = imguidedfilter(gray, gray, 2, 0.01);
assert_checkequal(size(diffused), size(gray));
assert_checkequal(size(guided), size(gray));

cloneMask = imroi2mask([4 4 8 8], [16 16], "rectangle");
cloned = imseamlessclone(gray, gray, cloneMask, [8 8], "normal");
normalized = imlocalnormalize(gray, [3 3], 0.01);
assert_checkequal(size(cloned), [16 16 3]);
assert_checkequal(size(normalized), size(gray));

[registered2, transform] = imregister(gray, gray, "phasecorr");
assert_checkequal(size(registered2), size(gray));
assert_checkequal(size(transform), [3 3]);

objectPoints = [0 0 0; 1 0 0; 0 1 0; 1 1 0];
imagePoints = [1 1; 10 1; 1 10; 10 10];
[cameraMatrix, distortion, calibrationError] = imcalibratecamera(objectPoints, imagePoints, [16 16]);
assert_checkequal(size(cameraMatrix), [3 3]);
assert_checkequal(size(distortion), [1 5]);
assert_checktrue(isnan(calibrationError));

objectPoints = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1];
imagePoints = [224 72; 508 76; 514 379; 226 382; 360 220; 500 218];
[cameraMatrix, distortion, calibrationError] = imcalibratecamera(objectPoints, imagePoints, [480 640]);
assert_checkequal(size(cameraMatrix), [3 3]);
assert_checkequal(size(distortion), [1 5]);
assert_checktrue(~isnan(calibrationError));

right = imtranslate(gray, [-2 0]);
disparityBM = imstereobm(gray, right, 4, 3);
disparitySGBM = imstereosgbm(gray, right, 4, 3);
assert_checkequal(size(disparityBM), size(gray));
assert_checkequal(size(disparitySGBM), size(gray));

linePoints = [1 2; 2 4; 3 6; 4 8; 5 10];
line = imfitline(linePoints);
assert_checkequal(size(line), [1 4]);
ellipsePoints = [8 4; 10 5; 12 8; 10 11; 8 12; 6 11; 4 8; 6 5];
ellipse = imellipsefit(ellipsePoints);
assert_checktrue(isfield(ellipse, "Center"));
