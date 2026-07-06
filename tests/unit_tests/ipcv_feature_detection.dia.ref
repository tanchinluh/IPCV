//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated feature detection source layer
//==============================================================================

S = imcreatechecker(8, 8, [1 0.5]);

fast = imdetect_FAST(S);
assert_checkequal(fast.type, "FAST");
assert_checktrue(fast.n >= 0);
assert_checkequal(size(fast.x, 2), fast.n);

gftt = imdetect_GFTT(S);
assert_checkequal(gftt.type, "HARRIS");
assert_checktrue(gftt.n >= 0);
assert_checkequal(size(gftt.x, 2), gftt.n);

mser = imdetect_MSER(S);
assert_checkequal(mser.type, "MSER");
assert_checktrue(mser.n >= 0);
assert_checkequal(size(mser.x, 2), mser.n);

orb = imdetect_ORB(S);
assert_checkequal(orb.type, "ORB");
assert_checktrue(orb.n >= 0);
assert_checkequal(size(orb.x, 2), orb.n);

//==============================================================================
