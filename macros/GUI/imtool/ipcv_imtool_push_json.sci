function ipcv_imtool_push_json(json)
    browser = findobj("tag", "ipcv_imtool_browser");
    if browser <> [] then
        set(browser, "data", json);
    end
endfunction
