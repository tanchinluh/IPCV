//==============================================================================
// IPCV 5.0.0.1
//==============================================================================
// unit test runtime version reporting
// <-- NO CHECK REF -->
//==============================================================================

info = ipcv_version();
assert_checkequal(typeof(info), "st");
assert_checkequal(info.ipcv, "5.0.0.1");
assert_checkequal(info.opencv, "5.0.0");
assert_checktrue(length(info.scilab) > 0);
assert_checktrue(length(info.platform) > 0);
assert_checktrue(length(info.architecture) > 0);

//==============================================================================
