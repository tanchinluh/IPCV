function props = imvideoprops()
    // Return common OpenCV video capture property IDs.
    //
    // Syntax
    //    props = imvideoprops()
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 0 then
        error("imvideoprops: Wrong number of input arguments.");
    end

    props.pos_msec = 0;
    props.pos_frames = 1;
    props.pos_avi_ratio = 2;
    props.frame_width = 3;
    props.frame_height = 4;
    props.fps = 5;
    props.fourcc = 6;
    props.frame_count = 7;
    props.format = 8;
    props.mode = 9;
    props.brightness = 10;
    props.contrast = 11;
    props.saturation = 12;
    props.hue = 13;
    props.gain = 14;
    props.exposure = 15;
endfunction
