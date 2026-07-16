function uri = ipcv_imtool_file_uri(filename)
    path = strsubst(fullpath(filename), "\", "/");
    if length(path) >= 2 & part(path, 2) == ":" then
        uri = "file:///" + path;
    else
        uri = "file://" + path;
    end
endfunction
