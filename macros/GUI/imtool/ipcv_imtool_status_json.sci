function json = ipcv_imtool_status_json(status, message)
    json = "{" + ..
        """status"":""" + ipcv_imtool_json_escape(status) + """," + ..
        """message"":""" + ipcv_imtool_json_escape(message) + """" + ..
        "}";
endfunction
