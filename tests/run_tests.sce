// Interactive entry point: keep native tests and their cleanup out of the user's session.
function ipcv_run_from_console(testRoot)
    report = fullfile(TMPDIR, "ipcv_test_report.csv");
    if getos() == "Windows" then
        runner = fullfile(testRoot, "run_tests.ps1");
        executable = fullfile(SCI, "bin", "WScilex-cli.exe");
        q = ascii(34);
        command = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File " + ..
            q + runner + q + " -ScilabExecutable " + q + executable + q + ..
            " -ReportPath " + q + report + q;
    else
        executable = fullfile(SCI, "bin", "scilab-adv-cli");
        if ~isfile(executable) then
            executable = fullfile(SCI, "..", "..", "bin", "scilab-adv-cli");
        end
        // Single-quote paths for sh, including an embedded apostrophe.
        q = ascii(39);
        escaped = q + ascii(34) + q + ascii(34) + q;
        runner = fullfile(testRoot, "run_tests.sh");
        command = "IPCV_TEST_REPORT_FILE=" + q + strsubst(report, q, escaped) + q + ..
            " sh " + q + strsubst(runner, q, escaped) + q + " " + q + strsubst(executable, q, escaped) + q;
    end
    if ~isfile(executable) then error("Scilab test executable not found: " + executable); end
    [status, output] = host(command, %t);
    if status <> 0 then
        error(["IPCV tests failed in the separate Scilab process."; output(:)]);
    end
    mprintf("IPCV test report: %s\n", report);
endfunction

ipcv_run_from_console(get_absolute_file_path("run_tests.sce"));
clear ipcv_run_from_console;
