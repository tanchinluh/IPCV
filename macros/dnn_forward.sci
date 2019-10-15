//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2018  Tan Chin Luh
//=============================================================================
function out = dnn_forward(net,img,input_size,layer_name,scalefactor,rgb_mean,swapRB,crop)
    // Runs forward pass to compute output of layer with name layer_name
    //
    // Syntax
    //    out = dnn_forward(net,img,scalefactor,image_size,rgb_mean,swapRB,layer_name);
    //
    // Parameters
    //    net : DNN object loaded in Scilab
    //    img : Image in Scilab format 
    //    input_size : DNN input size
    //    layer_name : Name for layer which output is needed to get
    //    scalefactor : Spatial size for input image
    //    rgb_mean : Scalar with mean values which are subtracted from channels. Values are intended to be in (mean-R, mean-G, mean-B) order if image has BGR ordering and swapRB is true. 
    //    swapRB : Flag which indicates that swap first and last channels in 3-channel image is necessary.
    //    crop : flag which indicates whether image will be cropped after resize or not
    //    out : Output matrix of the results depending on the type of DNN loaded.
    //
    // Description
    //    This function is used to run forward pass to compute output of layer with name layer_name
    //
    // Examples
    //    dnn_path = fullpath(getIPCVpath() + '/images/dnn/');
    //    net = dnn_readmodel(dnn_path + 'lenet5.pb','','tensorflow');
    //    S = imread(dnn_path + '3.jpg');
    //    imshow(S);
    //    out = dnn_forward(net,~S,[28,28]);
    //    [maxV,maxI]=max(out);
    //    xnumb(10,10,maxI-1);
    //    e = gce();
    //    e.font_size = 10;
    //    e.font_color = 5;
    //
    // See also
    //     dnn_readmodel
    //     dnn_list
    //     dnn_unloadmodel
    //     dnn_unloadallmodels
    //     dnn_forward 
    //     dnn_getparam
    //
    // Authors
    //    CL Tan - Trity Technologies.
    //

    
    rhs=argn(2);
    // Error Checking 
    if rhs < 3; error("At least 3 arguments expected, DNN model, input image, and the dnn input size"); end    
    if rhs < 4; layer_name = net.layername($); end
    if rhs < 5; scalefactor = 1; end
    if rhs < 6; rgb_mean = [0, 0, 0]; end
    if rhs < 7; swapRB = 1; end
    if rhs < 8; crop = 0; end

    // Check for empty optional inputs
    if isempty(layer_name); layer_name = net.layername($); end
    if isempty(scalefactor); scalefactor = 1; end
    if isempty(rgb_mean); rgb_mean = [0, 0, 0]; end
    if isempty(swapRB); swapRB = 1; end
    if isempty(crop); crop = 0; end
    
    
     
    // Check for empty optional inputs
    if type(scalefactor) ~= 1 | ~isscalar(scalefactor)
        error("Input scalefactor must be a double scalar"); 
    end   
    if type(rgb_mean) ~= 1 | length(rgb_mean)<3
        error("Input rgb_mean must be vector of [R,G,B]"); 
    end   
    checkrange(7,swapRB,0,1);
    checkrange(8,crop,0,1);
    
    if type(layer_name) ~= 10 
        error("Input layer_name must be a string"); 
    end
    
    if sum(net.layername==layer_name)~=1 then
        error("Layer name not found in the DNN structure."); 
    end
    
    out = int_dnn_forward(net.ptr,img,input_size,layer_name,scalefactor,rgb_mean,swapRB,crop);
    
    
endfunction
