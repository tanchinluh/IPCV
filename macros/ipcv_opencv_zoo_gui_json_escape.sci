function out = ipcv_opencv_zoo_gui_json_escape(txt)
    out = string(txt);
    out = strsubst(out, "\", "\\");
    out = strsubst(out, """", "\""");
    out = strsubst(out, ascii(13), "\r");
    out = strsubst(out, ascii(10), "\n");
endfunction
