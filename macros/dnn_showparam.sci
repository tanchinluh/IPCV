//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2018  Tan Chin Luh
//=============================================================================
function dnn_showparam(para_map,out_num,c)
    // Visualize the DNN parameters (filter) in spatial domain
    //
    // Syntax
    //    dnn_showfeature(para_map,out_num,c);
    //
    // Parameters
    //    para_map : Parameter maps to be visualized
    //    out_num : Number of outputs to be shown
    //    c : Colormap for visualization
    //
    // Description
    //    This function is used to visualize the DNN parameters (filter) in spatial domain
    // 
    // Examples
    //    // Initialize
    //    dnn_unloadallmodels
    //    dnn_path = fullpath(getIPCVpath() + '/images/dnn/');
    //    net = dnn_readmodel(dnn_path + 'lenet5.pb','','tensorflow');
    //     
    //     
    //    // Read Image
    //    S = imread(dnn_path + '3.jpg');
    //    
    //    // Forward Pass
    //    para1 = dnn_getparam(net,"conv2d/Conv2D");
    //    scf();dnn_showparam(para1);
    //     
    //    // Clean Up 
    //    dnn_unloadallmodels();
    //
    // See also
    //     dnn_showfeature
    //     dnn_showparam
    //     dnn_showparamf2d
    //     dnn_showparamf3d
    //
    // Authors
    //    CL Tan - Trity Technologies.
    //


    rhs=argn(2);

    if rhs < 1; error("At least 1 argument expected, activation output map."); end  
    if rhs < 2; out_num = %inf; end 
    if rhs < 3; c = jet(256); end 
    
    // Check for empty optional inputs
    if isempty(out_num); out_num = %inf; end
    if isempty(c); c = jet(256); end
    
    csize = size(c, 1);
    para_min = min(para_map);
    para_max = max(para_map);
    if para_max == para_min then
        para_map_n = para_map * 0 + ceil(csize / 2);
    else
        para_map_n = round((para_map - para_min) ./ (para_max - para_min) .* (csize - 1)) + 1;
    end
    para_map_n = squeeze(para_map_n);
    f = gcf();
    f.visible = "off";
    f.color_map = c;
    
    if  para_max > 10 then
        colorbar(para_min,para_max,fmt="%.0f");
    else
        colorbar(para_min,para_max,fmt="%.2f");
    end
    
    num = min(out_num,size(para_map_n,3));
    
    for cnt = 1:num
        subplot(ceil(sqrt(num)),ceil(num/ceil(sqrt(num))),cnt)
        para_map_cnt = para_map_n(:,:,cnt);//(aa(1,cnt,:,:) - min(aa))./(max(aa) - min(aa));
        para_map_cnt2 = squeeze(para_map_cnt);
        imshow(para_map_cnt2', c);
        a = gca();
        a.axes_bounds = a.axes_bounds.*[0.8 1 0.8 1];
        title(string(cnt));
    end

    f.visible = "on";

//    scf();colorbar(min(para_map_n),max(para_map_n));
//    f2 = gcf();
//    f2.color_map = c;


endfunction
