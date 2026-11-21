//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2018  Tan Chin Luh
//=============================================================================
function dnn_showfeature(feature_map,out_num,c)
    // Visualize the DNN feature map 
    //
    // Syntax
    //    dnn_showfeature(feature_map,out_num,c);
    //
    // Parameters
    //    feature_map : Feature maps to be visualized
    //    out_num : Number of outputs to be shown
    //    c : Colormap for visualization
    //
    // Description
    //    This function is used to visualize the DNN feature maps 
    // 
    // Examples
    //    image = rgb2gray(imread(fullpath(getIPCVpath() + "/images/opencv_fruits.jpg")));
    //    image = imresize(image, [120 160]);
    //    feature_map = cat(3, double(image), double(imgaussianblur(image, [7 7], 1.5)), imgradientmagnitude(image));
    //    scf();
    //    dnn_showfeature(feature_map);
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
    feature_min = min(feature_map);
    feature_max = max(feature_map);
    if feature_max == feature_min then
        feature_map_n = feature_map * 0 + ceil(csize / 2);
    else
        feature_map_n = round((feature_map - feature_min) ./ (feature_max - feature_min) .* (csize - 1)) + 1;
    end
    //feature_map_n = (feature_map - min(feature_map))./(max(feature_map)-min(feature_map));
    feature_map_n = squeeze(feature_map_n);
    f = gcf();
    f.visible = "off";
    f.color_map = c;

    if  feature_max > 10 then
        colorbar(feature_min,feature_max,fmt="%.0f");
    else
        colorbar(feature_min,feature_max,fmt="%.2f");
    end
    
    num = min(out_num,size(feature_map_n,3));

    for cnt = 1:num
        subplot(ceil(sqrt(num)),ceil(num/ceil(sqrt(num))),cnt)
//        subplot(1,num,cnt)
        feature_map_cnt = feature_map_n(:,:,cnt);//(aa(1,cnt,:,:) - min(aa))./(max(aa) - min(aa));
        feature_map_cnt2 = squeeze(feature_map_cnt);
        imshow(feature_map_cnt2', c);
        a = gca();
        a.axes_bounds = a.axes_bounds.*[0.8 1 0.8 1];
        title(string(cnt));
    end

    f.visible = "on";



endfunction
