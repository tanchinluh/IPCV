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

//==============================================================================
