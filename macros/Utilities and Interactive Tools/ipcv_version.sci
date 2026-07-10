function info = ipcv_version()
    // Return IPCV and runtime dependency version information.
    //
    // Syntax
    //    info = ipcv_version()
    //
    // Authors
    //    Tan Chin Luh

    versionLines = mgetl(fullfile(getIPCVpath(), "VERSION"));
    ipcvVersion = stripblanks(versionLines(1));
    opencvVersion = int_ipcv_opencv_version();
    scilabVersion = getversion();
    platform = getos();

    if platform == "Windows" then
        architecture = getenv("PROCESSOR_ARCHITECTURE");
    else
        [status, architecture] = host("uname -m");
        if status <> 0 then
            architecture = "unknown";
        end
        architecture = stripblanks(architecture);
    end

    if isempty(architecture) then
        architecture = "unknown";
    end

    info = struct( ..
        "ipcv", ipcvVersion, ..
        "opencv", opencvVersion, ..
        "scilab", scilabVersion, ..
        "platform", platform, ..
        "architecture", architecture ..
    );
endfunction
