function ipcv_opencv_zoo_gui_callback(msg, cb)
    if msg == "loaded" then
        return;
    end

    try
        select msg.type
        case "init" then
            cb(ipcv_opencv_zoo_gui_init_json());
        case "fetch" then
            cb(ipcv_opencv_zoo_gui_fetch_models_json());
        case "size" then
            cb(ipcv_opencv_zoo_gui_model_size_json(msg.blobUrl, msg.size));
        case "download" then
            assets = [];
            if isfield(msg, "assets") then
                assets = msg.assets;
            end
            cb(ipcv_opencv_zoo_gui_download_json(msg.name, msg.url, assets));
        case "downloadScript" then
            assets = [];
            if isfield(msg, "assets") then
                assets = msg.assets;
            end
            cb(ipcv_opencv_zoo_gui_download_script_json(msg.name, msg.url, msg.group, msg.path, assets));
        else
            cb(ipcv_opencv_zoo_gui_status_json("error", "Unknown GUI command."));
        end
    catch
        cb(ipcv_opencv_zoo_gui_status_json("error", "OpenCV Zoo GUI command failed."));
    end
endfunction
