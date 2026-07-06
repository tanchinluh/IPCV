//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated object detection and tracking source layer
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/people2.jpg"));
cfn = fullpath(getIPCVpath() + "/demos/haarcascade_frontalface_alt.xml");
objects = imdetectobjects(S, cfn);
assert_checkequal(size(objects, 1), 4);
assert_checktrue(size(objects, 2) >= 0);

T = imread(fullpath(getIPCVpath() + "/images/three_objects.png"));
rect = [10 10 40 40]';
tracker = imtrack_init(T, rect, "KCF");
updated = imtrack_update(tracker, T);
assert_checkequal(size(updated), [4 1]);
assert_checktrue(updated(3) >= 0);
assert_checktrue(updated(4) >= 0);
imtrack_unloadall();

//==============================================================================
