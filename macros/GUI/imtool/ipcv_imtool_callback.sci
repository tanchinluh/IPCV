function ipcv_imtool_callback(msg, cb)
    if msg == "loaded" then
        return;
    end

    try
        select msg.type
        case "init" then
            cb(ipcv_imtool_init_json());
        case "videoChoose" then
            response = fromJSON(ipcv_imtool_video_open_json("", 1));
            response.request = "videoOpen";
            ipcv_imtool_push_json(toJSON(response));
        case "videoOpen" then
            frame_index = 1;
            request = "videoOpen";
            if isfield(msg, "index") then
                frame_index = evstr(msg.index);
                request = "videoFrame";
            end
            response = fromJSON(ipcv_imtool_video_open_json(msg.path, frame_index));
            response.request = request;
            ipcv_imtool_push_json(toJSON(response));
        case "videoFrame" then
            response = fromJSON(ipcv_imtool_video_frame_json(evstr(msg.index)));
            response.request = "videoFrame";
            ipcv_imtool_push_json(toJSON(response));
        case "videoClose" then
            ipcv_imtool_video_close_json();
        case "recordStart" then
            response = fromJSON(ipcv_imtool_record_start_json(evstr(msg.fps), evstr(msg.speed)));
            response.request = "recordStart";
            ipcv_imtool_push_json(toJSON(response));
        case "recordFrame" then
            response = fromJSON(ipcv_imtool_record_frame_json(msg.data));
            response.request = "recordFrame";
            ipcv_imtool_push_json(toJSON(response));
        case "recordStop" then
            response = fromJSON(ipcv_imtool_record_stop_json());
            response.request = "recordStop";
            ipcv_imtool_push_json(toJSON(response));
        else
            cb(ipcv_imtool_status_json("error", "Unknown imtool command."));
        end
    catch
        if isfield(msg, "type") & or(msg.type == ["recordStart" "recordFrame" "recordStop"]) then
            response = fromJSON(ipcv_imtool_status_json("error", "imtool command failed: " + lasterror()));
            response.request = msg.type;
            ipcv_imtool_push_json(toJSON(response));
        else
            cb(ipcv_imtool_status_json("error", "imtool command failed."));
        end
    end
endfunction
