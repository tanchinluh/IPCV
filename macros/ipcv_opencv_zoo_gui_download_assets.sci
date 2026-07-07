function asset_files = ipcv_opencv_zoo_gui_download_assets(assets, target_dir)
    asset_files = emptystr(0, 1);

    if argn(2) < 1 then
        return;
    end

    if typeof(assets) <> "st" then
        return;
    end

    for i = 1:length(assets)
        asset = assets(i);
        if ~isfield(asset, "name") | ~isfield(asset, "url") then
            continue;
        end

        target_file = fullfile(target_dir, asset.name);
        if ~isfile(target_file) then
            http_get(asset.url, target_file, follow=%t, timeout=120);
        end

        info = fileinfo(target_file);
        if info <> [] & info(1) > 0 then
            asset_files($ + 1) = target_file;
        end
    end
endfunction
