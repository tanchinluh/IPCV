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

        items($ + 1) = "{" + ..
            """name"":""" + ipcv_opencv_zoo_gui_json_escape(model_name) + """," + ..
            """group"":""" + ipcv_opencv_zoo_gui_json_escape(group_name) + """," + ..
            """path"":""" + ipcv_opencv_zoo_gui_json_escape(path) + """," + ..
            """url"":""" + ipcv_opencv_zoo_gui_json_escape(raw_url + path) + """," + ..
            """blobUrl"":""" + ipcv_opencv_zoo_gui_json_escape(entry.url) + """," + ..
            """size"":" + string(size_value) + "," + ..
            """lfsPointer"":" + lfs_pointer_json + ..
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
