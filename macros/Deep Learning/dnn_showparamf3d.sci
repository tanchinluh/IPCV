function [] = dnn_showparamf3d(para_map,out_num,c)
    // Visualize the DNN parameters (filter) in frequency domain (3D)
    //
    // Syntax
    //    dnn_showparamf3d(para_map,out_num,c)
    //
    // Parameters
    //    para_map : Parameters to be visualized
    //    out_num : Number of filters to be shown
    //    c : Colormap for visualization
    //
    // Description
    //    This function is used to visualize the DNN  parameters (filter) in 3D frequency domain
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
    //    scf();dnn_showparamf3d(para1);
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


    rhs = argn(2);

    if rhs<1 then
        error("At least 1 argument expected, activation output map.");
    end;
    if rhs<2 then
        out_num = %inf;
    end;
    if rhs<3 then
        c = jet(256);
    end;

    // Check for empty optional inputs
    if isempty(out_num) then
        out_num = %inf;
    end;
    if isempty(c) then
        c = jet(256);
    end;

    drawlater;
    para_map_n = para_map;//(para_map - min(para_map))./(max(para_map)-min(para_map)).*255;
    para_map_n = squeeze(para_map_n);
    f = gcf();
    f.visible = "off";
    f.color_map = c;

    num = min(out_num,size(para_map_n,3));

    for cnt = 1:num
        subplot(ceil(sqrt(num)),ceil(num/ceil(sqrt(num))),cnt)
        para_map_cnt = para_map_n(:,:,cnt);  //(aa(1,cnt,:,:) - min(aa))./(max(aa) - min(aa));
        para_map_cnt2 = squeeze(para_map_cnt);
        F = fftshift(fft2pad(para_map_cnt2,256,256));
        
        imsurf(abs(F'),50);

        title(string(cnt));
        //        e = gce();
        //        e.image_type = 'index';
    end;
    drawnow;
    f.visible = "on";
endfunction

