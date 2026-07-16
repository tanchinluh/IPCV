function json = ipcv_imtool_record_stop_json()
    global IPCV_IMTOOL_RECORD_ACTIVE;
    global IPCV_IMTOOL_RECORD_FILE;
    global IPCV_IMTOOL_RECORD_FRAMES;

    filename = IPCV_IMTOOL_RECORD_FILE;
    frames = IPCV_IMTOOL_RECORD_FRAMES;
    if isempty(filename) then
        filename = "";
    end
    if isempty(frames) then
        frames = 0;
    end
    active = %f;
    if ~isempty(IPCV_IMTOOL_RECORD_ACTIVE) then
        active = IPCV_IMTOOL_RECORD_ACTIVE;
    end
    if active == %t then
        try
            frames = int_imtoolrecord("stop");
        catch
            json = ipcv_imtool_status_json("error", "Could not finish recording: " + lasterror());
            ipcv_imtool_record_release();
            return;
        end
    end
    IPCV_IMTOOL_RECORD_ACTIVE = %f;
    IPCV_IMTOOL_RECORD_FILE = "";
    IPCV_IMTOOL_RECORD_FRAMES = 0;
    json = "{" + ..
        """status"":""ok""," + ..
        """path"":""" + ipcv_imtool_json_escape(strsubst(filename, "\", "/")) + """," + ..
        """frames"":" + msprintf("%d", frames) + ..
        "}";
endfunction
