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
    props.convert_rgb = 16;
    props.white_balance_blue_u = 17;
    props.rectification = 18;
    props.monochrome = 19;
    props.sharpness = 20;
    props.auto_exposure = 21;
    props.gamma = 22;
    props.temperature = 23;
    props.trigger = 24;
    props.trigger_delay = 25;
    props.white_balance_red_v = 26;
    props.zoom = 27;
    props.focus = 28;
    props.guid = 29;
    props.iso_speed = 30;
    props.backlight = 32;
    props.pan = 33;
    props.tilt = 34;
    props.roll = 35;
    props.iris = 36;
    props.settings = 37;
    props.buffersize = 38;
    props.auto_focus = 39;
    props.sar_num = 40;
    props.sar_den = 41;
    props.backend = 42;
    props.channel = 43;
    props.auto_wb = 44;
    props.wb_temperature = 45;
    props.codec_pixel_format = 46;
    props.bitrate = 47;
    props.orientation_meta = 48;
    props.orientation_auto = 49;
    props.hw_acceleration = 50;
    props.hw_device = 51;
    props.hw_acceleration_use_opencl = 52;
    props.open_timeout_msec = 53;
    props.read_timeout_msec = 54;
    props.stream_open_time_usec = 55;
    props.video_total_channels = 56;
    props.video_stream = 57;
    props.audio_stream = 58;
    props.audio_pos = 59;
    props.audio_shift_nsec = 60;
    props.audio_data_depth = 61;
    props.audio_samples_per_second = 62;
    props.audio_base_index = 63;
    props.audio_total_channels = 64;
    props.audio_total_streams = 65;
    props.audio_synchronize = 66;
    props.lrf_has_key_frame = 67;
    props.codec_extradata_index = 68;
    props.frame_type = 69;
    props.n_threads = 70;
endfunction
