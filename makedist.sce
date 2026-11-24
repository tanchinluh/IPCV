// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023-2025 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v3.0,
// For more information, see the COPYING file which you should have received

path_makedist = get_absolute_file_path();
cd(path_makedist);

modulename = "IPCV"
version = mgetl("VERSION")
[result,status] = http_get(msprintf("%s/%s/%s/DESCRIPTION","https://atoms.scilab.org/toolboxes",modulename,version));
if status == 200
    mputl(result,"DESCRIPTION")
end

[sci,v]=getversion()
if getos() <> "Windows" then
    filename = modulename+"_"+mgetl("VERSION")+".bin."+v(2)+"."+getos()+".tar.gz"
else
    filename =  modulename+"_"+mgetl("VERSION")+".bin."+v(2)+"."+getos()+".zip"
end

// Package only toolbox files, not the entire development checkout.
entries = ["builder.sce"; "CAPABILITIES.md"; "ChangeLog.txt"; "cleaner.sce";
           "demos"; "DESCRIPTION"; "etc"; "help"; "inline"; "jar";
           "LICENSE"; "license.txt"; "loader.sce"; "macros"; "makedist.sce";
           "README.MD"; "ROADMAP.md"; "tcl"; "tests"; "unloader.sce"; "VERSION"];
entries = entries(isfile(entries) | isdir(entries));

function files = ipcvDistFiles(folder, patterns)
    files = [];
    for pattern = patterns
        names = findfiles(folder, pattern);
        if ~isempty(names) then
            paths = folder + "/" + names(:);
            files = [files; paths(isfile(paths))];
        end
    end
endfunction

// Keep native sources, loaders and shared libraries, not Release/*.obj or SDK link files.
for folder = ["src", "sci_gateway"]
    entries = [entries; ipcvDistFiles(folder, "*.sce"); ..
        ipcvDistFiles(folder + "/cpp", ["*.sce", "*.cpp", "*.c", "*.h", "*.hxx", "*" + getdynlibext()])];
end

// DNN demo downloads share a folder with the small, distributed test fixtures.
imageNames = findfiles("images", "*");
entries = [entries; "images/" + imageNames(imageNames <> "dnn"); ..
    ipcvDistFiles("images/dnn", ["?.jpg", "hw_lr.jpg", "*.txt", "*.csv", "labelsimagenet1k.h", "lenet5.onnx"])];

if getos() == "Windows" then
    runtime = "thirdparty/Windows/" + getenv("PROCESSOR_ARCHITECTURE", "AMD64");
    required = runtime + "/lib/" + ["opencv_world510.dll"; "opencv_img_hash510.dll"; "opencv_videoio_ffmpeg510_64.dll"];
else
    [rc, arch] = host("uname -m");
    if rc <> 0 then error("Cannot determine the OpenCV runtime architecture."); end
    runtime = "thirdparty/" + getos() + "/" + stripblanks(arch);
    required = runtime + "/lib/" + ["libopencv_world"; "libopencv_img_hash"] + getdynlibext();
end
missing = required(~isfile(required));
if ~isempty(missing) then
    error("Missing OpenCV runtime: " + strcat(missing, ", "));
end
if getos() == "Windows" then
    entries = [entries; required];
else
    // Include FFmpeg dependencies and both the linker names and their versioned targets.
    entries = [entries; ipcvDistFiles(runtime + "/lib", ["*.so", "*.so.*", "*.dylib"])];
end
data = runtime + "/" + ["LICENSE"; "etc/licenses"; "etc/haarcascades"; "etc/lbpcascades"; ..
    "share/licenses"; "share/opencv5/haarcascades"; "share/opencv5/lbpcascades"];
entries = [entries; data(isfile(data) | isdir(data))];
clear ipcvDistFiles;
distdir = fullfile(pwd(), "dist");
if ~isdir(distdir) then
    [ok, msg] = mkdir(distdir);
    if ok <> 1 then error(msg); end
end
archivePath = fullfile(distdir, filename);
moduledir = fileparts(pwd(), "fname");
cd("..")
try
    compress(archivePath, moduledir + "/" + entries);
catch
    message = lasterror();
    cd(path_makedist);
    error(message);
end
cd(path_makedist);
mprintf("Created %s\n", archivePath);
