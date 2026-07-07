function json = ipcv_opencv_zoo_gui_model_size_json(blob_url, fallback_size)
    size_value = ipcv_opencv_zoo_gui_lfs_size(blob_url, fallback_size);

    json = "{" + ..
        """status"":""ok""," + ..
        """size"":" + string(size_value) + ..
        "}";
endfunction
