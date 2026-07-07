function json = ipcv_opencv_zoo_gui_status_json(status, message)
    json = "{" + ..
        """status"":""" + ipcv_opencv_zoo_gui_json_escape(status) + """," + ..
        """message"":""" + ipcv_opencv_zoo_gui_json_escape(message) + """" + ..
        "}";
endfunction
