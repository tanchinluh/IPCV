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

net = dnn_readmodel(dnn_path + "image_classification_mobilenetv2_2022apr.onnx", "", "onnx");
assert_checktrue(net.ptr > 0);
assert_checkequal(net.type, "onnx");
assert_checktrue(size(net.outputname, "*") > 0);
Sclass = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
out = dnn_forward(net, Sclass, [224, 224], [], 1 / 127.5, [127.5 127.5 127.5], 1, 0);
assert_checkequal(size(out), [1000 1]);
assert_checktrue(max(out) > min(out));
dnn_unloadmodel(net);
assert_checkequal(dnn_list(), []);

net = dnn_readmodel(dnn_path + "clip_rn50_openai_visual_fp16.onnx", "", "onnx");
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

//==============================================================================
