////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
////////////////////////////////////////////////////////////
function demo_dnn()

    dnn_unloadallmodels();

    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
    net = dnn_readmodel(dnn_path + "lenet5.pb", "", "tensorflow");
    net = dnn_setpreferable(net, "opencv", "cpu");

    info = dnn_info(net, [28, 28], 1);
    mprintf("\nDNN model: %s\n", info.name);
    mprintf("Model type: %s\n", info.type);
    mprintf("Backend/target: %s/%s\n", info.backend, info.target);
    mprintf("Layer count: %d\n", info.layercount);
    mprintf("Output layer: %s\n", info.outputname($));
    mprintf("FLOPS for [28, 28, 1]: %.0f\n\n", info.flops);

    S = imread(dnn_path + "3.jpg");
    out = dnn_forward(net, ~S, [28, 28]);
    [score, index] = max(out);
    prediction = index - 1;

    mprintf("Prediction for 3.jpg: %d, score: %f\n", prediction, score);
    mprintf("First 10 output values:\n");
    disp(out(1:min(10, size(out, "*"))));

    scf();
    imshow(S);
    title("DNN prediction: " + string(prediction));

    conv_output = dnn_forward(net, ~S, [28, 28], "conv2d/Conv2D");
    conv_param = dnn_getparam(net, "conv2d/Conv2D");
    mprintf("conv2d/Conv2D output size: %s\n", strcat(string(size(conv_output)), " x "));
    mprintf("conv2d/Conv2D parameter size: %s\n", strcat(string(size(conv_param)), " x "));

    dnn_unloadmodel(net);
endfunction
// ====================================================================
demo_dnn();
clear demo_dnn;
// ====================================================================
