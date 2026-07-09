//==============================================================================
// IPCV OpenCV 5 DNN
//==============================================================================
// unit test DNN model lifecycle and forward pass
//==============================================================================

dnn_unloadallmodels();
dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
net = dnn_readmodel(dnn_path + "lenet5.pb", "", "tensorflow");
assert_checktrue(net.ptr > 0);
assert_checktrue(size(net.layername, "*") > 0);
assert_checktrue(size(net.outputname, "*") > 0);
assert_checktrue(size(net.layertype, "*") > 0);
assert_checkequal(dnn_getoutputs(net), net.outputname);
assert_checkequal(dnn_getlayertypes(net), net.layertype);
net = dnn_setpreferable(net, "opencv", "cpu");
assert_checkequal(net.backend, "opencv");
assert_checkequal(net.target, "cpu");
flops = dnn_getflops(net, [28, 28], 1);
assert_checktrue(flops > 0);
info = dnn_info(net, [28, 28], 1);
assert_checkequal(info.ptr, net.ptr);
assert_checktrue(info.layercount > 0);
assert_checktrue(info.flops > 0);
presets = dnn_presets();
assert_checkequal(presets.imagenet.size, [224 224]);
assert_checkequal(presets.clip.size, [224 224]);
zooClass = dnn_zoo_modelinfo("image_classification_mobilenetv2_2022apr.onnx", "image_classification_mobilenet");
assert_checkequal(zooClass.task, "classification");
assert_checkequal(zooClass.inputSize, [224 224]);
assert_checkequal(zooClass.decoder, "classification");
zooYolo = dnn_zoo_modelinfo("object_detection_yolox_2022nov.onnx", "object_detection_yolox");
assert_checkequal(zooYolo.task, "object_detection");
assert_checkequal(zooYolo.inputSize, [640 640]);
assert_checkequal(zooYolo.decoder, "yolo");
zooSsd = dnn_zoo_modelinfo("object_detection_ssd_mobilenetv1.onnx", "object_detection_ssd");
assert_checkequal(zooSsd.decoder, "ssd");
zooYunet = dnn_zoo_modelinfo("face_detection_yunet_2023mar.onnx", "face_detection_yunet");
assert_checkequal(zooYunet.decoder, "yunet");
zooSeg = dnn_zoo_modelinfo("image_segmentation_efficientvit.onnx", "image_segmentation_efficientvit");
assert_checkequal(zooSeg.task, "segmentation");
assert_checkequal(zooSeg.decoder, "segmentation");

probs = dnn_softmax([1; 2; 3]);
assert_checktrue(abs(sum(probs) - 1) < 0.000001);
assert_checkequal(find(probs == max(probs)), 3);
[topScores, topIndices, topLabels] = dnn_topk([0.1; 0.8; 0.2], 2, ["a"; "b"; "c"]);
assert_checkequal(topIndices, [2; 3]);
assert_checkequal(topLabels, ["b"; "c"]);
decoded = dnn_decode_classification([0.1; 0.8; 0.2], ["a"; "b"; "c"], 2, %f);
assert_checkequal(decoded.indices, [2; 3]);
assert_checkequal(decoded.labels, ["b"; "c"]);
keep = dnn_nms([0 0 10 10; 1 1 10 10; 50 50 10 10], [0.9; 0.8; 0.7], 0.1, 0.4);
assert_checktrue(or(keep == 1));
assert_checktrue(or(keep == 3));
yolo = dnn_decode_yolo([0.5 0.5 0.2 0.2 0.9 0.1 0.8], [640 480], 0.25, 0.45);
assert_checkequal(size(yolo.boxes), [1 4]);
assert_checkequal(yolo.classIds, 2);
ssd = dnn_decode_ssd([0 3 0.9 0.1 0.1 0.4 0.5], [640 480], 0.25, 0.45);
assert_checkequal(size(ssd.boxes), [1 4]);
assert_checkequal(ssd.classIds, 3);
yunet = dnn_decode_yunet([10 20 80 80 20 30 60 30 40 50 25 70 55 70 0.95], [640 480], 0.25, 0.45);
assert_checkequal(size(yunet.boxes), [1 4]);
assert_checkequal(size(yunet.landmarks), [1 10]);
segScores = cat(3, [0.9 0.1; 0.1 0.2], [0.1 0.9; 0.8 0.7]);
segMask = dnn_decode_segmentation(segScores);
assert_checkequal(segMask, [1 2; 2 2]);

S = imread(dnn_path + "3.jpg");
out = dnn_forward(net, ~S, [28, 28]);
assert_checktrue(size(out, "*") > 0);

out1 = dnn_forward(net, ~S, [28, 28], "conv2d/Conv2D");
assert_checkequal(size(out1), [28 28 6]);

para1 = dnn_getparam(net, "conv2d/Conv2D");
assert_checkequal(size(para1), [5 5 6]);

lst = dnn_list();
assert_checkequal(lst, net.ptr);
dnn_unloadmodel(net);
assert_checkequal(dnn_list(), []);

mobilenet_model = dnn_path + "image_classification_mobilenetv2_2022apr.onnx";
if ~isfile(mobilenet_model) then
    mobilenet_url = "https://github.com/opencv/opencv_zoo/raw/main/models/image_classification_mobilenet/image_classification_mobilenetv2_2022apr.onnx";
    http_get(mobilenet_url, mobilenet_model, follow=%t, timeout=300);
end
model_info = fileinfo(mobilenet_model);
assert_checktrue(model_info <> []);
assert_checktrue(model_info(1) > 1000000);

net = dnn_readmodel(mobilenet_model, "", "onnx");
assert_checktrue(net.ptr > 0);
assert_checkequal(net.type, "onnx");
assert_checktrue(size(net.outputname, "*") > 0);
Sclass = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
out = dnn_forward(net, Sclass, [224, 224], [], 1 / 127.5, [127.5 127.5 127.5], 1, 0);
assert_checkequal(size(out), [1000 1]);
assert_checktrue(max(out) > min(out));
dnn_unloadmodel(net);
assert_checkequal(dnn_list(), []);

clip_model = dnn_path + "clip_rn50_openai_visual_fp16.onnx";
if isfile(clip_model) then
    net = dnn_readmodel(clip_model, "", "onnx");
    assert_checktrue(net.ptr > 0);
    assert_checkequal(net.type, "onnx");
    assert_checktrue(size(net.outputname, "*") > 0);
    text_embeddings = csvRead(dnn_path + "clip_rn50_openai_text_embeddings.csv");
    prompts = mgetl(dnn_path + "clip_rn50_openai_prompts.txt");
    Sclip = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    Sclip = im2double(imresize(Sclip, [224 224]));
    clip_mean = [0.48145466 0.4578275 0.40821073];
    clip_std = [0.26862954 0.26130258 0.27577711];
    for c = 1:3
        Sclip(:,:,c) = (Sclip(:,:,c) - clip_mean(c)) ./ clip_std(c);
    end
    embedding = dnn_forward(net, Sclip, [224, 224], [], 1, [0 0 0], 0, 0);
    assert_checkequal(size(embedding), [1024 1]);
    embedding = embedding(:)';
    embedding = embedding ./ sqrt(sum(embedding .* embedding));
    scores = text_embeddings * embedding';
    [score, index] = max(scores);
    label = strsplit(prompts(index), "|");
    assert_checkequal(label(1), "baboon");
    assert_checktrue(score > 0.2);
    dnn_unloadmodel(net);
    assert_checkequal(dnn_list(), []);
end

//==============================================================================
