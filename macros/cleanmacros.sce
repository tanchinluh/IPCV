// =============================================================================
// Copyright (C) DIGITEO - 2010 - Allan CORNET
// =============================================================================
libpath = get_absolute_file_path('cleanmacros.sce');
// =============================================================================
function ipcv_clean_macro_tree(path)
    binfiles = ls(path + filesep() + "*.bin");
    for i = 1:size(binfiles, "*")
        mdelete(binfiles(i));
    end

    names_file = path + filesep() + "names";
    lib_file = path + filesep() + "lib";
    if isfile(names_file) then
        mdelete(names_file);
    end
    if isfile(lib_file) then
        mdelete(lib_file);
    end

    entries = ls(path + filesep() + "*");
    for i = 1:size(entries, "*")
        if isdir(entries(i)) then
            ipcv_clean_macro_tree(pathconvert(entries(i), %F));
        end
    end
endfunction

ipcv_clean_macro_tree(libpath);
clear ipcv_clean_macro_tree;
// =============================================================================
