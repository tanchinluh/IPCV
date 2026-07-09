function id = imvideopropid(prop)
    // Convert a video/camera property name to an OpenCV CAP_PROP id.
    //
    // Syntax
    //    id = imvideopropid(prop)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("imvideopropid: Wrong number of input arguments.");
    end

    if type(prop) == 1 then
        id = prop;
        return;
    end
    if type(prop) <> 10 | size(prop, "*") <> 1 then
        error("imvideopropid: prop must be a scalar string or numeric property id.");
    end

    key = convstr(stripblanks(prop), "l");
    key = strsubst(key, "cap_prop_", "");
    key = strsubst(key, " ", "_");
    key = strsubst(key, "-", "_");

    select key
    case "pos_msec" then id = 0;
    case "msec" then id = 0;
    case "time" then id = 0;
    case "pos_frames" then id = 1;
    case "frame" then id = 1;
    case "frame_index" then id = 1;
    case "pos_avi_ratio" then id = 2;
    case "ratio" then id = 2;
    case "frame_width" then id = 3;
    case "width" then id = 3;
    case "frame_height" then id = 4;
    case "height" then id = 4;
    case "fps" then id = 5;
    case "fourcc" then id = 6;
    case "frame_count" then id = 7;
    case "count" then id = 7;
    case "format" then id = 8;
    case "mode" then id = 9;
    case "brightness" then id = 10;
    case "contrast" then id = 11;
    case "saturation" then id = 12;
    case "hue" then id = 13;
    case "gain" then id = 14;
    case "exposure" then id = 15;
    case "convert_rgb" then id = 16;
    case "white_balance_blue_u" then id = 17;
    case "rectification" then id = 18;
    case "monochrome" then id = 19;
    case "sharpness" then id = 20;
    case "auto_exposure" then id = 21;
    case "gamma" then id = 22;
    case "temperature" then id = 23;
    case "trigger" then id = 24;
    case "trigger_delay" then id = 25;
    case "white_balance_red_v" then id = 26;
    case "zoom" then id = 27;
    case "focus" then id = 28;
    case "guid" then id = 29;
    case "iso_speed" then id = 30;
    case "backlight" then id = 32;
    case "pan" then id = 33;
    case "tilt" then id = 34;
    case "roll" then id = 35;
    case "iris" then id = 36;
    case "settings" then id = 37;
    case "buffersize" then id = 38;
    case "auto_focus" then id = 39;
    case "sar_num" then id = 40;
    case "sar_den" then id = 41;
    case "backend" then id = 42;
    case "channel" then id = 43;
    case "auto_wb" then id = 44;
    case "wb_temperature" then id = 45;
    case "codec_pixel_format" then id = 46;
    case "bitrate" then id = 47;
    case "orientation_meta" then id = 48;
    case "orientation_auto" then id = 49;
    case "hw_acceleration" then id = 50;
    case "hw_device" then id = 51;
    case "hw_acceleration_use_opencl" then id = 52;
    case "open_timeout_msec" then id = 53;
    case "read_timeout_msec" then id = 54;
    case "stream_open_time_usec" then id = 55;
    case "video_total_channels" then id = 56;
    case "video_stream" then id = 57;
    case "audio_stream" then id = 58;
    case "audio_pos" then id = 59;
    case "audio_shift_nsec" then id = 60;
    case "audio_data_depth" then id = 61;
    case "audio_samples_per_second" then id = 62;
    case "audio_base_index" then id = 63;
    case "audio_total_channels" then id = 64;
    case "audio_total_streams" then id = 65;
    case "audio_synchronize" then id = 66;
    case "lrf_has_key_frame" then id = 67;
    case "codec_extradata_index" then id = 68;
    case "frame_type" then id = 69;
    case "n_threads" then id = 70;
    else
        error("imvideopropid: Unsupported video/camera property name.");
    end
endfunction
