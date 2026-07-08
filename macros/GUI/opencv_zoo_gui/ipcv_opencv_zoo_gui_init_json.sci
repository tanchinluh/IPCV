function json = ipcv_opencv_zoo_gui_init_json()
    default_dir = fullpath(getIPCVpath() + "/images/dnn/");
    json = "{" + ..
        """status"":""ok""," + ..
        """defaultDir"":""" + ipcv_opencv_zoo_gui_json_escape(default_dir) + """," + ..
        """opencvZooUrl"":""https://github.com/opencv/opencv_zoo""," + ..
        """opencvHuggingFaceUrl"":""https://huggingface.co/opencv""" + ..
        "}";
endfunction
