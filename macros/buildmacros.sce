function ipcv_build_macro_tree(path)
    sci_files = findfiles(path, "*.sci");
    if ~isempty(sci_files) then
        tbx_build_macros(TOOLBOX_NAME, path);
    end

    entries = ls(path + filesep() + "*");
    for i = 1:size(entries, "*")
        // Keep archived compatibility sources out of the generated macro libraries.
        if isdir(entries(i)) & convstr(basename(entries(i)), "l") <> "old" then
            ipcv_build_macro_tree(pathconvert(entries(i), %F));
        end
    end
endfunction

ipcv_build_macro_tree(get_absolute_file_path("buildmacros.sce"));
clear ipcv_build_macro_tree;
