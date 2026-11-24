function ipcv_run_stability_from_console(testRoot)
    previousSuite = getenv("IPCV_TEST_SUITE", "");
    setenv("IPCV_TEST_SUITE", "stability");
    ierr = execstr("exec(fullfile(testRoot, ""run_tests.sce""), -1)", "errcatch");
    if ierr <> 0 then message = lasterror(); end
    setenv("IPCV_TEST_SUITE", previousSuite);
    if ierr <> 0 then error(message); end
endfunction
ipcv_run_stability_from_console(get_absolute_file_path("run_stability_tests.sce"));
clear ipcv_run_stability_from_console;
