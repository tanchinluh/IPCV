//==============================================================================
// IPCV OpenCV 5.1.0 development
//==============================================================================
// unit test runtime version reporting
// <-- NO CHECK REF -->
//==============================================================================

info = ipcv_version();
assert_checkequal(typeof(info), "st");
assert_checkequal(info.ipcv, "5.1.0");
assert_checkequal(info.opencv, "5.1.0");
assert_checktrue(length(info.scilab) > 0);
assert_checktrue(length(info.platform) > 0);
assert_checktrue(length(info.architecture) > 0);

//==============================================================================
