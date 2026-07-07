function json = ipcv_opencv_zoo_gui_download_json(model_name, model_url)
    default_dir = fullpath(getIPCVpath() + "/images/dnn/");
    target_dir = uigetdir(default_dir, "Select folder for OpenCV Zoo model");

    if target_dir == " " | target_dir == "" then
        json = ipcv_opencv_zoo_gui_status_json("cancelled", "Download cancelled.");
        return;
    end

    target_file = fullfile(target_dir, model_name);
    http_get(model_url, target_file, follow=%t, timeout=300);

    info = fileinfo(target_file);
    if info == [] | info(1) < 100 then
        json = ipcv_opencv_zoo_gui_status_json("error", "Downloaded file is missing or incomplete.");
        return;
    end

    json = "{" + ..
        """status"":""ok""," + ..
        """message"":""Downloaded " + ipcv_opencv_zoo_gui_json_escape(model_name) + """," + ..
        """file"":""" + ipcv_opencv_zoo_gui_json_escape(target_file) + """," + ..
        """bytes"":" + string(info(1)) + ..
        "}";
endfunction
