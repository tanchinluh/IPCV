//==============================================================================
// IPCV OpenCV 5.0.0 development Step 2 network/model integration
// <-- NO CHECK REF -->
//==============================================================================

dnn_unloadallmodels();
dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
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
        Sclip(:, :, c) = (Sclip(:, :, c) - clip_mean(c)) ./ clip_std(c);
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
