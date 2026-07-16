testRoot = get_absolute_file_path("run_build.sce");
toolboxRoot = fullpath(fullfile(testRoot, ".."));
statusFile = getenv("IPCV_BUILD_STATUS_FILE");
if isempty(statusFile) then
    statusFile = fullfile(TMPDIR, "ipcv_build_status.txt");
end

errorCode = execstr("exec(fullfile(toolboxRoot, ""builder.sce""), -1);", "errcatch");
if errorCode == 0 then
    mputl("PASS", statusFile);
    mprintf("IPCV BUILD PASS\n");
    exit(0);
else
    message = lasterror();
    mputl(["FAIL"; message], statusFile);
    mprintf("IPCV BUILD FAIL: %s\n", message);
    exit(1);
end
