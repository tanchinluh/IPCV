//==============================================================================
// IPCV 5.0.0.2 physical camera test
// <-- NO CHECK REF -->
//==============================================================================

cameraText = getenv("IPCV_CAMERA_INDEX");
if isempty(cameraText) then
    cameraIndex = 0;
else
    cameraIndex = evstr(cameraText);
end

camcloseall();
handle = camopen(cameraIndex);
assert_checktrue(handle >= 0);
sleep(200);
frame = camread(handle);
assert_checktrue(size(frame, "*") > 1);
assert_checktrue(size(frame, 1) > 0);
assert_checktrue(size(frame, 2) > 0);
camclose(handle);
assert_checkfalse(or(camlistopened() == handle));

//==============================================================================
