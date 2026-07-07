function json = ipcv_opencv_zoo_gui_download_script_json(model_name, model_url, group_name, model_path)
    default_dir = fullpath(getIPCVpath() + "/images/dnn/");
    target_dir = uigetdir(default_dir, "Select folder for OpenCV Zoo model and sample script");

    if target_dir == " " | target_dir == "" then
        json = ipcv_opencv_zoo_gui_status_json("cancelled", "Download and script generation cancelled.");
        return;
    end

    target_file = fullfile(target_dir, model_name);
    if ~isfile(target_file) then
        http_get(model_url, target_file, follow=%t, timeout=300);
    end

    info = fileinfo(target_file);
    if info == [] | info(1) < 100 then
        json = ipcv_opencv_zoo_gui_status_json("error", "Downloaded file is missing or incomplete.");
        return;
    end

    script_file = ipcv_opencv_zoo_gui_generate_sample_script(target_file, model_name, group_name, model_path, model_url, target_dir);

    editor_opened = %t;
    try
        editor(script_file);
    catch
        editor_opened = %f;
    end

    message = "Downloaded " + model_name + " and generated sample script.";
    if editor_opened then
        message = message + " Opened script in Scilab editor.";
        editor_opened_json = "true";
    else
        message = message + " Could not open Scilab editor.";
        editor_opened_json = "false";
    end

    json = "{" + ..
        """status"":""ok""," + ..
        """message"":""" + ipcv_opencv_zoo_gui_json_escape(message) + """," + ..
        """file"":""" + ipcv_opencv_zoo_gui_json_escape(target_file) + """," + ..
        """script"":""" + ipcv_opencv_zoo_gui_json_escape(script_file) + """," + ..
        """bytes"":" + string(info(1)) + "," + ..
        """editorOpened"":" + editor_opened_json + ..
        "}";
endfunction
