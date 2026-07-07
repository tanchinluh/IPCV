function json = ipcv_opencv_zoo_gui_download_script_json(model_name, model_url, group_name, model_path, assets)
    if argn(2) < 5 then
        assets = [];
    end

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

    asset_files = ipcv_opencv_zoo_gui_download_assets(assets, target_dir);
    script_file = ipcv_opencv_zoo_gui_generate_sample_script(target_file, model_name, group_name, model_path, model_url, target_dir, asset_files);

    editor_opened = %t;
    try
        editor(script_file);
    catch
        editor_opened = %f;
    end

    message = "Downloaded " + model_name;
    if size(asset_files, "*") > 0 then
        message = message + " plus " + string(size(asset_files, "*")) + " companion file(s)";
    end
    message = message + " and generated sample script.";
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
        """assets"":" + string(size(asset_files, "*")) + "," + ..
        """bytes"":" + string(info(1)) + "," + ..
        """editorOpened"":" + editor_opened_json + ..
        "}";
endfunction
