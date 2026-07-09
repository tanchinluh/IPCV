//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated video and camera source layer
// <-- NO CHECK REF -->
//==============================================================================

videoPath = fullpath(getIPCVpath() + "/images/video.avi");
[frames, width, height, fps] = aviinfo(videoPath);
assert_checktrue(frames > 0);
assert_checktrue(width > 0);
assert_checktrue(height > 0);
props = imvideoprops();
assert_checkequal(props.frame_width, 3);
assert_checkequal(props.frame_height, 4);
assert_checkequal(props.fps, 5);
assert_checkequal(imvideopropid("fps"), props.fps);
assert_checkequal(imvideopropid("width"), props.frame_width);
aviProps = aviprops();
camProps = camprops();
assert_checkequal(aviProps.frame_count, props.frame_count);
assert_checkequal(camProps.exposure, props.exposure);
capabilities = imvideocapabilities();
assert_checktrue(capabilities.readFrame);
assert_checktrue(capabilities.writeVideo);
assert_checkequal(capabilities.propertyGetSet, %t);
assert_checkequal(capabilities.seekVideo, %t);

n = aviopen(videoPath);
opened = avilistopened();
assert_checktrue(or(opened == n));
assert_checktrue(abs(aviget(n, "frame_width") - width) < 0.001);
assert_checktrue(abs(aviget(n, "frame_height") - height) < 0.001);
assert_checktrue(aviget(n, "frame_count") >= frames);
[posFrame, posMsec, posRatio] = avipos(n);
assert_checktrue(posFrame >= 1);
assert_checktrue(aviseek(n, 1));

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
