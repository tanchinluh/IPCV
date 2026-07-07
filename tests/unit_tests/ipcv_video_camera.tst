//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated video and camera source layer
//==============================================================================

videoPath = fullpath(getIPCVpath() + "/images/video.avi");
[frames, width, height, fps] = aviinfo(videoPath);
assert_checktrue(frames > 0);
assert_checktrue(width > 0);
assert_checktrue(height > 0);

n = aviopen(videoPath);
opened = avilistopened();
assert_checktrue(or(opened == n));

frame1 = avireadframe(n, 1);
assert_checkequal(size(frame1, 3), 3);
assert_checktrue(size(frame1, 1) > 0);
assert_checktrue(size(frame1, 2) > 0);
aviclose(n);

outfile = fullfile(TMPDIR, "ipcv_video_camera_test.avi");
if isfile(outfile) then
    mdelete(outfile);
end

w = avifile(outfile, [64; 64], 10, "MJPG");
aviaddframe(w, frame1);
addframe(w, frame1);
aviclose(w);

[outFrames, outWidth, outHeight, outFps] = aviinfo(outfile);
assert_checktrue(outFrames >= 1);
assert_checkequal(outWidth, 64);
assert_checkequal(outHeight, 64);

camcloseall();
cams = camlistopened();
assert_checktrue(size(cams, "*") >= 0);

if isfile(outfile) then
    mdelete(outfile);
end

//==============================================================================
