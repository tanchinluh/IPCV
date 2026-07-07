function size_value = ipcv_opencv_zoo_gui_lfs_size(blob_url, fallback_size)
    size_value = fallback_size;
    if blob_url == "" then
        return;
    end

    try
        pointer = http_get(blob_url, headers=["Accept: application/vnd.github.raw"], timeout=60);
        pointer_text = strcat(pointer, ascii(10));
        lines = strsplit(pointer_text, ascii(10));

        for i = 1:size(lines, "*")
            line = stripblanks(lines(i));
            if length(line) < 6 then
                continue;
            end

            if part(line, 1:5) == "size " then
                size_text = stripblanks(part(line, 6:length(line)));
                parsed_size = evstr(size_text);
                if type(parsed_size) == 1 & parsed_size > 0 then
                    size_value = parsed_size;
                    return;
                end
            end
        end
    catch
        size_value = fallback_size;
    end
endfunction
