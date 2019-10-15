//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2019  Tan Chin Luh
//=============================================================================
function ptr_track = imtrack_init(im, rect, algo)
    // Initialize Tracker
    //
    // Syntax
    //    ptr_track = imtrack_init(im, rect);
    //
    // Parameters
    //    im : Input image or frame
    //    rect : Rectangle of the object to be tracked
    //    algo : Tracking algorithms. Currently support BOOSTING, CSRT, GOTURN, KCF, MEDIANFLOW, MOSSE
    //    ptr_track : Tracker object pointer
    //
    // Description
    //    This function is used to initialize the object tracker
    // 
    // Examples
    //    n = aviopen(fullpath(getIPCVpath() + "/images/video.avi"));
    //    
    //    S1 = avireadframe(n,1);
    //    S2 = avireadframe(n,5);
    //    S3 = avireadframe(n,10);
    //    S4 = avireadframe(n,15);
    //    
    //    rec = [136 49 38 24]';
    //    subplot(221);imshow(S1);imrects(rec,[0 255 0]);title('Frame 1');
    //    
    //    tracker = imtrack_init(S1,rec,"CSRT");
    //    
    //    rec2 = imtrack_update(tracker,S2);
    //    subplot(222);imshow(S2);imrects(rec2,[0 255 0]);title('Frame 5');
    //    
    //    rec3 = imtrack_update(tracker,S3);
    //    subplot(223);imshow(S3);imrects(rec3,[0 255 0]);title('Frame 10');
    //    
    //    rec4 = imtrack_update(tracker,S4);
    //    subplot(224);imshow(S4);imrects(rec4,[0 255 0]);title('Frame 15');
    //    
    //    imtrack_unloadall();
    //
    // See also
    //     imtrack_update
    //     imtrack_unloadall
    //
    // Authors
    //    CL Tan - Bytecode (formally Trity Technologies)
    //

    rhs=argn(2);
    // Error Checking 
    if rhs < 2; error("At least 2 arguments expected, image/frame and the bounding box for the object to be tracked."); end    
    if rhs < 3; algo = 1; end
    if isempty(algo); algo = 1; end
    
    supported_algo = ["CSRT","KCF","BOOSTING","MIL","TLD","MEDIANFLOW","MOSSE"];
    // Check modeltype
    if type(algo) == 1 then
        checkrange(3,algo,1,size(supported_algo,2)); 
        algoselect = algo;
    elseif type(algo) == 10 then
        algoselect = grep(supported_algo,convstr(algo,"u"));
        if algoselect == [];
            error("Only tracker algo: " + strcat(supported_algo,', ') + " allowed"); 
        end
        checkrange(3,algoselect,1,size(supported_algo,2));
    else
        error("Only tracker algo: " + strcat(supported_algo,', ') + " allowed"); 
    end
    
    ptr_track = int_tracker_init(im,rect,algoselect);
    
//    scf();colorbar(min(para_map_n),max(para_map_n));
//    f2 = gcf();
//    f2.color_map = c;


endfunction
