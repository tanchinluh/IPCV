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
    if getscilabmode() <> "NWNI" then
        // host(..., %t) echoes to the OS terminal, not necessarily the Scilab GUI.
        // Read the worker's merged stdout/stderr and print it in the caller.
        worker = fullfile(testRoot, "run_tests_batch.sce");
        args = [executable, "-nb", "-noatomsautoload", "-f", worker, "-args", "ipcv-test-worker"];
        builder = jnewInstance("java.lang.ProcessBuilder", args);
        builder.redirectErrorStream(%t);
        env = builder.environment();
        statusFile = tempname();
        env.put("IPCV_TEST_STATUS_FILE", statusFile);
        env.put("IPCV_TEST_REPORT_FILE", report);
        env.put("IPCV_TEST_SUITE", getenv("IPCV_TEST_SUITE", "core"));
        env.put("IPCV_TEST_NAMES", getenv("IPCV_TEST_NAMES", ""));
        // A file (not a pipe) lets the reader poll without blocking indefinitely.
        logFile = tempname();
        builder.redirectOutput(jnewInstance("java.io.File", logFile));
        child = builder.start();
        try
            reader = jnewInstance("java.io.BufferedReader", jnewInstance("java.io.FileReader", logFile));
            started = getdate("s");
            while %t
                alive = child.isAlive();
                while reader.ready()
                    mprintf("%s\n", reader.readLine());
                end
                if ~alive then break; end
                if getdate("s") - started > 600 then error("IPCV test worker timed out."); end
                sleep(75);
            end
            status = child.exitValue();
            result = mgetl(statusFile);
        catch
            message = lasterror();
            if isdef("reader", "l") then reader.close(); end
            if child.isAlive() then child.destroyForcibly(); end
            error([message(:); "Worker log: " + logFile]);
        end
        reader.close();
        mdelete(statusFile);
        mdelete(logFile);
        if status <> 0 | isempty(result) then error("IPCV tests failed. See the output above."); end
        if result(1) <> "PASS" then error("IPCV tests failed. See the output above."); end
        return;
    end
    [status, output] = host(command, %t);
    if status <> 0 then
        error(["IPCV tests failed in the separate Scilab process."; output(:)]);
    end
    mprintf("IPCV test report: %s\n", report);
endfunction

ipcv_run_from_console(get_absolute_file_path("run_tests.sce"));
clear ipcv_run_from_console;
