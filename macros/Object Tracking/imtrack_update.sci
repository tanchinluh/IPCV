//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2019  Tan Chin Luh
//=============================================================================
function rect = imtrack_update(ptr_track, im)
    // Update Tracker
    //
    // Syntax
    //    rect = imtrack_update(ptr_track, im)
    //
    // Parameters
    //    ptr_track : Tracker object pointer
    //    im : Input image or frame
    //    rect : Updated rectangle of the object being tracked
    //
    // Description
    //    This function is used to update the location of the tracked object
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
    //     imtrack_init
    //     imtrack_unloadall
    //
    // Authors
    //    CL Tan - Bytecode (formally Trity Technologies)
    //

    rhs=argn(2);
    // Error Checking 
    if rhs < 2; error("2 arguments expected, tracker pointer and image/frame."); end    
    if rhs > 2; error("2 arguments expected, tracker pointer and image/frame."); end
    
    rect = int_tracker_update(ptr_track,im);

//    scf();colorbar(min(para_map_n),max(para_map_n));
//    f2 = gcf();
//    f2.color_map = c;


endfunction
