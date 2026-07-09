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

areas = imcontourarea(contours);
assert_checkequal(size(areas, 2), 1);
assert_checktrue(size(areas, 1) >= 1);
assert_checktrue(max(areas) > 0);

perimeters = imarclength(contours);
assert_checkequal(size(perimeters, 2), 1);
assert_checktrue(size(perimeters, 1) >= 1);
assert_checktrue(max(perimeters) > 0);

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

bounds = int_imboundingRect(Sbw);
assert_checkequal(size(bounds), [4 1]);
assert_checktrue(bounds(3) > 0);
assert_checktrue(bounds(4) > 0);

//==============================================================================
