function tf = ipcv_opencv_zoo_gui_ends_with(txt, suffix)
    if length(txt) < length(suffix) then
        tf = %f;
    else
        first = length(txt) - length(suffix) + 1;
        tf = part(txt, first:length(txt)) == suffix;
    end
endfunction
