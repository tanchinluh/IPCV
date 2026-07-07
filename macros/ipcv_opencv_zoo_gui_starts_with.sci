function tf = ipcv_opencv_zoo_gui_starts_with(txt, prefix)
    if length(txt) < length(prefix) then
        tf = %f;
    else
        tf = part(txt, 1:length(prefix)) == prefix;
    end
endfunction
