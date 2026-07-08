function json = ipcv_opencv_zoo_gui_fetch_models_json()
    api_url = "https://api.github.com/repos/opencv/opencv_zoo/git/trees/main?recursive=1";
    raw_url = "https://github.com/opencv/opencv_zoo/raw/main/";
    data = http_get(api_url, follow=%t, timeout=120);
    items = emptystr(0, 1);

    for i = 1:length(data.tree)
        entry = data.tree(i);
        if entry.type <> "blob" then
            continue;
        end

        path = entry.path;
        lower_path = convstr(path, "l");
        if ~ipcv_opencv_zoo_gui_starts_with(lower_path, "models/") then
            continue;
        end
        if ~ipcv_opencv_zoo_gui_ends_with(lower_path, ".onnx") then
            continue;
        end

        parts = strsplit(path, "/");
        if size(parts, "*") < 3 then
            continue;
        end

        group_name = parts(2);
        model_name = parts($);
        group_prefix = "models/" + group_name + "/";
        size_value = 0;
        lfs_pointer = %f;
        if sum(fieldnames(entry) == "size") > 0 then
            size_value = entry.size;
            if size_value <= 512 then
                lfs_pointer = %t;
            end
        end
        lfs_pointer_json = "false";
        if lfs_pointer then
            lfs_pointer_json = "true";
        end

        asset_items = emptystr(0, 1);
        for j = 1:length(data.tree)
            asset_entry = data.tree(j);
            if asset_entry.type <> "blob" then
                continue;
            end

            asset_path = asset_entry.path;
            asset_lower_path = convstr(asset_path, "l");
            if ~ipcv_opencv_zoo_gui_starts_with(asset_lower_path, convstr(group_prefix, "l")) then
                continue;
            end
            if asset_path == path then
                continue;
            end

            asset_parts = strsplit(asset_path, "/");
            asset_name = asset_parts($);
            asset_lower_name = convstr(asset_name, "l");

            if ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".onnx") then
                continue;
            end
            if ipcv_opencv_zoo_gui_starts_with(asset_lower_name, "readme") then
                continue;
            end
            if ipcv_opencv_zoo_gui_starts_with(asset_lower_name, "license") then
                continue;
            end

            likely_companion = ..
                ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".txt") | ..
                ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".json") | ..
                ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".yaml") | ..
                ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".yml") | ..
                ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".cfg") | ..
                ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".pbtxt") | ..
                ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".prototxt") | ..
                ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".names") | ..
                ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".labels") | ..
                ipcv_opencv_zoo_gui_ends_with(asset_lower_name, ".csv");

            if ~likely_companion then
                continue;
            end

            asset_size = 0;
            if sum(fieldnames(asset_entry) == "size") > 0 then
                asset_size = asset_entry.size;
            end

            asset_items($ + 1) = "{" + ..
                """name"":""" + ipcv_opencv_zoo_gui_json_escape(asset_name) + """," + ..
                """path"":""" + ipcv_opencv_zoo_gui_json_escape(asset_path) + """," + ..
                """url"":""" + ipcv_opencv_zoo_gui_json_escape(raw_url + asset_path) + """," + ..
                """size"":" + string(asset_size) + ..
                "}";
        end

        if size(asset_items, "*") == 0 then
            assets_json = "[]";
        else
            assets_json = "[" + strcat(asset_items, ",") + "]";
        end

        items($ + 1) = "{" + ..
            """name"":""" + ipcv_opencv_zoo_gui_json_escape(model_name) + """," + ..
            """group"":""" + ipcv_opencv_zoo_gui_json_escape(group_name) + """," + ..
            """path"":""" + ipcv_opencv_zoo_gui_json_escape(path) + """," + ..
            """url"":""" + ipcv_opencv_zoo_gui_json_escape(raw_url + path) + """," + ..
            """blobUrl"":""" + ipcv_opencv_zoo_gui_json_escape(entry.url) + """," + ..
            """size"":" + string(size_value) + "," + ..
            """lfsPointer"":" + lfs_pointer_json + "," + ..
            """assets"":" + assets_json + ..
            "}";
    end

    if size(items, "*") == 0 then
        models_json = "[]";
    else
        models_json = "[" + strcat(items, ",") + "]";
    end

    json = "{" + ..
        """status"":""ok""," + ..
        """source"":""https://github.com/opencv/opencv_zoo""," + ..
        """count"":" + string(size(items, "*")) + "," + ..
        """models"":" + models_json + ..
        "}";
endfunction
