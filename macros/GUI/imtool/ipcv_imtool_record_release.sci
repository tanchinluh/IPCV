function ipcv_imtool_record_release()
    global IPCV_IMTOOL_RECORD_ACTIVE;
    global IPCV_IMTOOL_RECORD_FILE;
    global IPCV_IMTOOL_RECORD_FRAMES;

    if isempty(IPCV_IMTOOL_RECORD_ACTIVE) then
        IPCV_IMTOOL_RECORD_ACTIVE = %f;
    end
    if IPCV_IMTOOL_RECORD_ACTIVE == %t then
        try
            int_imtoolrecord("stop");
        catch
        end
    end
    IPCV_IMTOOL_RECORD_ACTIVE = %f;
    IPCV_IMTOOL_RECORD_FILE = "";
    IPCV_IMTOOL_RECORD_FRAMES = 0;
endfunction
