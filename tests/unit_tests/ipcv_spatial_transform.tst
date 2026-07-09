//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated spatial transform source layer
//==============================================================================

img = imread(fullpath(getIPCVpath() + "/images/baboon.png"));

scaled = imresize(img, 0.5, "nearest");
assert_checkequal(typeof(scaled), "uint8");
assert_checkequal(size(scaled), [256 256 3]);

sized = imresize(img, [100 200], "bilinear");
assert_checkequal(typeof(sized), "uint8");
assert_checkequal(size(sized), [100 200 3]);

reduced = impyramid(img, "reduce");
assert_checkequal(typeof(reduced), "uint8");
assert_checkequal(size(reduced), [256 256 3]);

expanded = impyramid(reduced, "expand");
assert_checkequal(typeof(expanded), "uint8");
assert_checkequal(size(expanded), [512 512 3]);

small = uint8([1 2 3; 4 5 6]);

affineIdentity = [1 0 0; 0 1 0];
affineOut = int_affinetransform(small, affineIdentity, 3, 2);
assert_checkequal(typeof(affineOut), "uint8");
assert_checkequal(size(affineOut), [2 3]);
assert_checkequal(affineOut, small);

affineSrc = [1 1; 3 1; 1 2];
affineTgt = affineSrc;
affineMat = imgettransform(affineSrc, affineTgt, "affine");
affinePublic = imtransform(small, affineMat, "affine", 3, 2);
assert_checkequal(typeof(affinePublic), "uint8");
assert_checkequal(size(affinePublic), [2 3]);
assert_checkequal(affinePublic, small);
affineWarp = imwarpAffine(small, affineMat, 3, 2);
assert_checkequal(affineWarp, small);

perspectiveIdentity = [1 0 0; 0 1 0; 0 0 1];
perspectiveOut = int_perspectivetransform(small, perspectiveIdentity, 3, 2);
assert_checkequal(typeof(perspectiveOut), "uint8");
assert_checkequal(size(perspectiveOut), [2 3]);
assert_checkequal(perspectiveOut, small);

perspectiveSrc = [1 1; 3 1; 1 2; 3 2];
perspectiveTgt = perspectiveSrc;
perspectiveMat = imgettransform(perspectiveSrc, perspectiveTgt, "perspective");
perspectivePublic = imtransform(small, perspectiveMat, "perspective", 3, 2);
assert_checkequal(typeof(perspectivePublic), "uint8");
assert_checkequal(size(perspectivePublic), [2 3]);
assert_checkequal(perspectivePublic, small);
perspectiveWarp = imwarpPerspective(small, perspectiveMat, 3, 2);
assert_checkequal(perspectiveWarp, small);

rotatedCropped = imrotate(small, 0, 1);
assert_checkequal(typeof(rotatedCropped), "uint8");
assert_checkequal(size(rotatedCropped), [2 3]);
assert_checkequal(rotatedCropped, small);

rotatedExpanded = imrotate(small, 90, 0);
assert_checkequal(typeof(rotatedExpanded), "uint8");
assert_checktrue(size(rotatedExpanded, 1) >= 3);
assert_checktrue(size(rotatedExpanded, 2) >= 2);

remapped = imremap(small, [1 2 3; 1 2 3], [1 1 1; 2 2 2]);
assert_checkequal(typeof(remapped), "uint8");
assert_checkequal(remapped, small);

//==============================================================================
