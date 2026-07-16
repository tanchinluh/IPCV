function json = ipcv_imtool_init_json()
    global IPCV_IMTOOL_INITIAL_FILE;
    global IPCV_IMTOOL_INITIAL_VIDEO;

    initial_file = "";
    if IPCV_IMTOOL_INITIAL_FILE <> "" then
        path = strsubst(fullpath(IPCV_IMTOOL_INITIAL_FILE), "\", "/");
        if length(path) >= 2 & part(path, 2) == ":" then
            initial_file = "file:///" + path;
        else
            initial_file = "file://" + path;
        end
    end

    initial_video = "";
    if IPCV_IMTOOL_INITIAL_VIDEO <> "" then
        initial_video = strsubst(fullpath(IPCV_IMTOOL_INITIAL_VIDEO), "\", "/");
    end

    json = "{" + ..
        """status"":""ok""," + ..
        """initialFile"":""" + ipcv_imtool_json_escape(initial_file) + """," + ..
        """initialVideo"":""" + ipcv_imtool_json_escape(initial_video) + """" + ..
        "}";
endfunction
