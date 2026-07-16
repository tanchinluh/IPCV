function ipcv_imtool_video_release()
    global IPCV_IMTOOL_VIDEO_HANDLE;
    global IPCV_IMTOOL_VIDEO_FRAME_FILE;

    ipcv_imtool_record_release();

    if isempty(IPCV_IMTOOL_VIDEO_HANDLE) then
        IPCV_IMTOOL_VIDEO_HANDLE = -1;
    end
    if isempty(IPCV_IMTOOL_VIDEO_FRAME_FILE) then
        IPCV_IMTOOL_VIDEO_FRAME_FILE = "";
    end

    if IPCV_IMTOOL_VIDEO_HANDLE > 0 then
        try
            aviclose(IPCV_IMTOOL_VIDEO_HANDLE);
        catch
        end
    end
    IPCV_IMTOOL_VIDEO_HANDLE = -1;

    if IPCV_IMTOOL_VIDEO_FRAME_FILE <> "" then
        if isfile(IPCV_IMTOOL_VIDEO_FRAME_FILE) then
            mdelete(IPCV_IMTOOL_VIDEO_FRAME_FILE);
        end
    end
    IPCV_IMTOOL_VIDEO_FRAME_FILE = "";
endfunction
