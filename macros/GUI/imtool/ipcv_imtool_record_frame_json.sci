function json = ipcv_imtool_record_frame_json(data_uri)
    global IPCV_IMTOOL_RECORD_ACTIVE;
    global IPCV_IMTOOL_RECORD_FRAMES;

    if isempty(IPCV_IMTOOL_RECORD_ACTIVE) then
        json = ipcv_imtool_status_json("error", "No imtool recording is active.");
        return;
    end
    if IPCV_IMTOOL_RECORD_ACTIVE <> %t then
        json = ipcv_imtool_status_json("error", "No imtool recording is active.");
        return;
    end
    try
        IPCV_IMTOOL_RECORD_FRAMES = int_imtoolrecord("frame", data_uri);
    catch
        ipcv_imtool_record_release();
        json = ipcv_imtool_status_json("error", "Could not write the rendered frame: " + lasterror());
        return;
    end
    json = "{" + ..
        """status"":""ok""," + ..
        """frames"":" + msprintf("%d", IPCV_IMTOOL_RECORD_FRAMES) + ..
        "}";
endfunction
