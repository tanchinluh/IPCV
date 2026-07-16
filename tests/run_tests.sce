function value = ipcv_test_env(name, defaultValue)
    value = getenv(name, defaultValue);
    if isempty(value) then
        value = defaultValue;
    end
endfunction

function text = ipcv_test_report_text(value)
    text = strsubst(value, ascii(13), " ");
    text = strsubst(text, ascii(10), " ");
    text = strsubst(text, ";", ",");
endfunction

function [errorCode, message] = ipcv_execute_test(testFile)
    message = "";
    errorCode = execstr("exec(testFile, -1);", "errcatch");
    if errorCode <> 0 then
        message = lasterror();
    end
endfunction

function ipcv_test_cleanup()
    cleanupCalls = [ ..
        "dnn_unloadallmodels();"; ..
        "imtrack_unloadall();"; ..
        "avicloseall();"; ..
        "camcloseall();"; ..
        "imdestroyall();"; ..
        "xdel(winsid());" ..
    ];
    for i = 1:size(cleanupCalls, "*")
        execstr(cleanupCalls(i), "errcatch");
    end
endfunction

testRoot = get_absolute_file_path("run_tests.sce");
toolboxRoot = fullpath(fullfile(testRoot, ".."));
statusFile = ipcv_test_env("IPCV_TEST_STATUS_FILE", fullfile(TMPDIR, "ipcv_test_status.txt"));
reportFile = ipcv_test_env("IPCV_TEST_REPORT_FILE", fullfile(TMPDIR, "ipcv_test_report.csv"));
progressFile = ipcv_test_env("IPCV_TEST_PROGRESS_FILE", fullfile(TMPDIR, "ipcv_test_progress.txt"));
requestedSuite = convstr(stripblanks(ipcv_test_env("IPCV_TEST_SUITE", "core")), "l");
requestedNames = stripblanks(ipcv_test_env("IPCV_TEST_NAMES", ""));

validSuites = ["core"; "integration"; "gui"; "network"; "hardware"; "stability"; "release"; "all"];
if ~or(validSuites == requestedSuite) then
    mputl(["FAIL"; "reason=Unknown test suite: " + requestedSuite], statusFile);
    mprintf("Unknown IPCV test suite: %s\n", requestedSuite);
    exit(2);
end

exec(fullfile(testRoot, "test_manifest.sce"), -1);
manifest = ipcv_test_manifest(testRoot);
selected = repmat(%f, size(manifest.name, 1), size(manifest.name, 2));

if requestedSuite == "stability" then
    selected = manifest.stability;
elseif requestedSuite == "release" then
    selected = manifest.suite == "core" | manifest.suite == "integration";
elseif requestedSuite == "all" then
    selected(:) = %t;
else
    selected = manifest.suite == requestedSuite;
end

if ~isempty(requestedNames) then
    selected(:) = %f;
    nameList = stripblanks(strsplit(requestedNames, ","));
    for i = 1:size(nameList, "*")
        index = find(manifest.name == nameList(i));
        if isempty(index) then
            mputl(["FAIL"; "reason=Unknown test name: " + nameList(i)], statusFile);
            mprintf("Unknown IPCV test name: %s\n", nameList(i));
            exit(2);
        end
        selected(index) = %t;
    end
end

report = ["name;suite;family;platforms;requirements;status;duration_seconds;message"];
passed = 0;
failed = 0;
skipped = 0;
harnessFailed = %f;

mputl("RUN;<loader>", progressFile);
loadError = execstr("exec(fullfile(toolboxRoot, ""loader.sce""), -1);", "errcatch");
if loadError <> 0 then
    message = ipcv_test_report_text(lasterror());
    report($ + 1) = "<loader>;harness;harness;Windows,Linux,Darwin;built-toolbox;FAIL;0;" + message;
    mprintf("HARNESS FAIL: %s\n", message);
    failed = failed + 1;
    harnessFailed = %t;
end

if ~harnessFailed then
    for i = 1:size(manifest.name, "*")
        testName = manifest.name(i);
        if ~selected(i) then
            skipped = skipped + 1;
            reason = "not selected by suite " + requestedSuite;
            report($ + 1) = strcat([testName; manifest.suite(i); manifest.family(i); manifest.platforms(i); manifest.requirements(i); "SKIP"; "0"; reason], ";");
            continue;
        end

        testFile = fullfile(testRoot, "unit_tests", testName + ".tst");
        mputl("RUN;" + testName, progressFile);
        started = getdate("s");
        [errorCode, message] = ipcv_execute_test(testFile);
        duration = getdate("s") - started;
        ipcv_test_cleanup();

        if errorCode == 0 then
            status = "PASS";
            passed = passed + 1;
            mprintf("PASS [%s]: %s (%.3f s)\n", manifest.suite(i), testName, duration);
        else
            status = "FAIL";
            failed = failed + 1;
            message = ipcv_test_report_text(message);
            mprintf("FAIL [%s]: %s: %s\n", manifest.suite(i), testName, message);
        end
        mputl(status + ";" + testName, progressFile);
        report($ + 1) = strcat([testName; manifest.suite(i); manifest.family(i); manifest.platforms(i); manifest.requirements(i); status; string(duration); message], ";");
    end
end

mputl(report, reportFile);
if failed == 0 then
    result = "PASS";
else
    result = "FAIL";
end
mputl([result; "suite=" + requestedSuite; "passed=" + string(passed); "failed=" + string(failed); "skipped=" + string(skipped); "report=" + reportFile], statusFile);
mputl(result + ";<complete>", progressFile);
mprintf("SUMMARY: suite=%s passed=%d failed=%d skipped=%d\n", requestedSuite, passed, failed, skipped);
mprintf("REPORT: %s\n", reportFile);

if failed == 0 then
    exit(0);
else
    exit(1);
end
