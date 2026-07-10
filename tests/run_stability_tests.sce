testRoot = get_absolute_file_path("run_stability_tests.sce");
toolboxRoot = fullpath(fullfile(testRoot, ".."));
statusFile = getenv("IPCV_TEST_STATUS_FILE");
if isempty(statusFile) then
    statusFile = fullfile(TMPDIR, "ipcv_test_status.txt");
end

tests = [ ..
    "ipcv_version"; ..
    "imfuse"; ..
    "ipcv_gateway_image_exchange"; ..
    "ipcv_image_io"; ..
    "ipcv_arithmetic"; ..
    "ipcv_spatial_transform"; ..
    "ipcv_filtering"; ..
    "ipcv_morphology"; ..
    "ipcv_color"; ..
    "ipcv_edge_filter"; ..
    "ipcv_binary_analysis"; ..
    "ipcv_enhancement"; ..
    "ipcv_image_transform"; ..
    "ipcv_structural_analysis"; ..
    "ipcv_feature_detection"; ..
    "ipcv_hough_stitching"; ..
    "ipcv_dnn" ..
];

passed = 0;
failed = 0;

try
    exec(fullfile(toolboxRoot, "loader.sce"), -1);
    for i = 1:size(tests, "*")
        testFile = fullfile(testRoot, "unit_tests", tests(i) + ".tst");
        ierr = execstr("exec(testFile, -1);", "errcatch");
        if ierr == 0 then
            mprintf("PASS: %s\n", tests(i));
            passed = passed + 1;
        else
            mprintf("FAIL: %s: %s\n", tests(i), lasterror());
            failed = failed + 1;
        end
    end
catch
    mprintf("HARNESS FAIL: %s\n", lasterror());
    failed = failed + 1;
end

if failed == 0 then
    mputl("PASS", statusFile);
else
    mputl("FAIL", statusFile);
end
mprintf("SUMMARY: passed=%d failed=%d\n", passed, failed);
exit;
