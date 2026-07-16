function json = ipcv_imtool_video_close_json()
    ipcv_imtool_video_release();
    json = ipcv_imtool_status_json("ok", "Native video closed.");
endfunction
