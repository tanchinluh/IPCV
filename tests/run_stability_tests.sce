testRoot = get_absolute_file_path("run_stability_tests.sce");
setenv("IPCV_TEST_SUITE", "stability");
exec(fullfile(testRoot, "run_tests.sce"), -1);
