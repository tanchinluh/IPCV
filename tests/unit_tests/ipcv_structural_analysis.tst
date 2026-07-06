//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated structural analysis source layer
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/star.png"));
Sbw = im2bw(S, 0.5);

contours = imfindContours(Sbw);
firstContour = contours(1);
assert_checkequal(size(firstContour, 2), 2);
assert_checktrue(size(firstContour, 1) >= 3);

hulls = imconvexHull(contours);
firstHull = hulls(1);
assert_checkequal(size(firstHull, 2), 2);
assert_checktrue(size(firstHull, 1) >= 3);

hullIndices = imconvexHull(contours, 0, 1);
firstHullIndices = hullIndices(1);
assert_checkequal(size(firstHullIndices, 2), 1);
assert_checktrue(size(firstHullIndices, 1) >= 3);

defects = imconvexityDefects(contours, hullIndices);
firstDefects = defects(1);
assert_checkequal(size(firstDefects, 2), 4);

//==============================================================================
