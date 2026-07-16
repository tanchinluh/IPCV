//==============================================================================
// IPCV OpenCV 5.0.0 repository metadata contracts
// <-- NO CHECK REF -->
//==============================================================================

root = getIPCVpath();
versionText = stripblanks(mgetl(fullfile(root, "VERSION")));
assert_checkequal(size(versionText, "*"), 1);
assert_checkequal(versionText, "5.0.0");

description = mgetl(fullfile(root, "DESCRIPTION"));
versionRows = grep(description, "Version: 5.0.0");
assert_checkequal(size(versionRows, "*"), 1);

changeLog = mgetl(fullfile(root, "ChangeLog.txt"));
assert_checktrue(size(grep(changeLog, "OpenCV 5.0.0 Development - Step 2"), "*") >= 1);

runtime = ipcv_version();
assert_checkequal(runtime.ipcv, versionText);
assert_checkequal(runtime.opencv, "5.0.0");

testRoot = fullpath(fullfile(root, "tests"));
manifest = ipcv_test_manifest(testRoot);
assert_checkequal(size(unique(manifest.name), "*"), size(manifest.name, "*"));
assert_checkequal(size(manifest.name, "*"), size(findfiles(fullfile(testRoot, "unit_tests"), "*.tst"), "*"));
assert_checktrue(and(manifest.platforms == "Windows,Linux,Darwin"));

//==============================================================================
