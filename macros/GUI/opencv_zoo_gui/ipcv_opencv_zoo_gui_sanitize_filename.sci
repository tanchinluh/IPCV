function safe_name = ipcv_opencv_zoo_gui_sanitize_filename(name)
    safe_name = string(name);
    invalid_chars = ["\", "/", ":", "*", "?", "<", ">", "|", " "];

    for i = 1:size(invalid_chars, "*")
        safe_name = strsubst(safe_name, invalid_chars(i), "_");
    end

    safe_name = strsubst(safe_name, ascii(34), "_");
endfunction
