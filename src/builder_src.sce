function builder_src()
    languages_src = ["cpp"];
    path_src = get_absolute_file_path();
    tbx_builder_src_lang(languages_src, path_src);
    tbx_build_src_clean(languages_src, path_src);
endfunction

builder_src();
clear builder_src;
