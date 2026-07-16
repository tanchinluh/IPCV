//==============================================================================
// IPCV OpenCV 5.0.0 development Step 2 native handle lifecycle stress
// <-- NO CHECK REF -->
//==============================================================================

dnn_unloadallmodels();
imtrack_unloadall();
avicloseall();
camcloseall();

modelPath = fullpath(getIPCVpath() + "/images/dnn/lenet5.pb");
for i = 1:8
    net = dnn_readmodel(modelPath, "", "tensorflow");
    assert_checktrue(net.ptr > 0);
    assert_checktrue(or(dnn_list() == net.ptr));
    dnn_unloadmodel(net);
    assert_checkequal(dnn_list(), []);
end

trackingImage = imread(fullpath(getIPCVpath() + "/images/three_objects.png"));
for i = 1:8
    tracker = imtrack_init(trackingImage, [10 10 40 40]', "KCF");
    updated = imtrack_update(tracker, trackingImage);
    assert_checkequal(size(updated), [4 1]);
    imtrack_unloadall();
end

videoPath = fullpath(getIPCVpath() + "/images/video.avi");
for i = 1:8
    handle = aviopen(videoPath);
    assert_checktrue(or(avilistopened() == handle));
    frame = avireadframe(handle, 1);
    assert_checkequal(size(frame, 3), 3);
    aviclose(handle);
    assert_checkfalse(or(avilistopened() == handle));
end

dnn_unloadallmodels();
imtrack_unloadall();
avicloseall();
camcloseall();

//==============================================================================
