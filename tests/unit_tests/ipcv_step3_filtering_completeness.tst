//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 filtering compatibility batch
// <-- NO CHECK REF -->
//==============================================================================

source = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
gray = rgb2gray(source);

box = imboxfilt(source, [3 3]);
gaussian = imgaussfilt(source, [3 3], 1);
bilateral = imbilateralfilt(source, 3, 25, 25);
assert_checkequal(size(box), size(source));
assert_checkequal(size(gaussian), size(source));
assert_checkequal(size(bilateral), size(source));

medianColor = immedianfilt(source, 3);
medianGray = immedian(gray, 3);
assert_checkequal(size(medianColor), size(source));
assert_checkequal(size(medianGray), size(gray));

wiener = imwiener2(double(gray), [3 3]);
nonLocal = imnlmfilt(source, 3, 3, 7, 21);
equalized = imadapthistequal(gray, 3);
assert_checkequal(size(wiener), size(gray));
assert_checkequal(size(nonLocal), size(source));
assert_checkequal(size(equalized), size(gray));

sharp = imsharpen(source, 1, 1);
laplacian = imlaplacian(gray);
[gx, gy] = imgradientxy(gray);
direction = imgradientdirection(gray);
localMean = imlocalmean(gray, [5 5]);
localStd = imlocalstd(gray, [5 5]);
assert_checkequal(typeof(sharp), "uint8");
assert_checkequal(size(laplacian), size(gray));
assert_checkequal(size(gx), size(gray));
assert_checkequal(size(gy), size(gray));
assert_checkequal(size(direction), size(gray));
assert_checkequal(size(localMean), size(gray));
assert_checkequal(size(localStd), size(gray));
assert_checktrue(sum(isnan(direction)) == 0);
assert_checktrue(min(localStd) >= 0);

assert_checktrue(execstr("immedianfilt(gray, 4);", "errcatch") <> 0);
assert_checktrue(execstr("imsharpen(gray, 0, 1);", "errcatch") <> 0);

//==============================================================================
