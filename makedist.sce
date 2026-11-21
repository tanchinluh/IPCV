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
           "demos"; "DESCRIPTION"; "etc"; "help"; "images"; "inline"; "jar";
           "LICENSE"; "license.txt"; "loader.sce"; "macros"; "makedist.sce";
           "README.MD"; "ROADMAP.md"; "sci_gateway"; "src"; "tcl"; "tests";
           "unloader.sce"; "VERSION"; "thirdparty/" + getos()];
entries = entries(isfile(entries) | isdir(entries));
moduledir = fileparts(pwd(), "fname");
cd("..")
try
    compress(filename, moduledir + "/" + entries);
catch
    message = lasterror();
    cd(path_makedist);
    error(message);
end
cd(path_makedist);
