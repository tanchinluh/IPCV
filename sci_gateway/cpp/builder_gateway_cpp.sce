// -------------------------------------------------------------------------
// SIVP - Scilab Image Processing toolbox
// Copyright (C) 2005-2010  Shiqi Yu
// Copyright (C) 2012 - DIGITEO - Allan CORNET
// Copyright (C) 2017 - Trity - Tan Chin Luh
// Copyright (C) 2023-2025 - UTC - Stéphane Mottelet
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
// -------------------------------------------------------------------------
//
function builder_gateway_cpp()

    gw_cpp_path = get_absolute_file_path('builder_gateway_cpp.sce');
    gw_cpp_files = findfiles(gw_cpp_path, '*.cpp');
    scifunctions_name = gw_cpp_files(grep(gw_cpp_files, 'sci_'));
    scifunctions_name = strsubst(scifunctions_name, 'sci_', '');
    scifunctions_name = strsubst(scifunctions_name, 'percent', '%');
    scifunctions_name = strsubst(scifunctions_name, '.cpp', '');
    cppfunctions_name = gw_cpp_files(grep(gw_cpp_files,'sci_'));
    cppfunctions_name = strsubst(cppfunctions_name, '.cpp', '');
    gw_tables = [scifunctions_name, cppfunctions_name];

    if  getos() == "Windows"
        ARCH = getenv("PROCESSOR_ARCHITECTURE");        
    else
        ARCH = unix_g("uname -m");
    end

    THIRDPARTY=fullpath(fullfile(gw_cpp_path,"..","..","thirdparty"));

    all_libs = [];
    if getos() == "Windows"
        OPENCV_INCLUDE = fullfile(THIRDPARTY,"Windows",ARCH,"include");
        libs = ["opencv_world450";"opencv_img_hash450"]
        all_libs = fullfile("..","..","thirdparty","Windows",ARCH,"lib",libs); 
    else  // Darwin, Linux
        OPENCV_INCLUDE = fullfile(THIRDPARTY,getos(),ARCH,"include","opencv4");
        gw_cpp_files = [gw_cpp_files; "common.h"];
    end

    inter_cflags = ilib_include_flag([OPENCV_INCLUDE,gw_cpp_path]); 
    inter_ldflags = "";

    tbx_build_gateway('gw_ipcv', ..
    gw_tables, ..
    gw_cpp_files, ..
    gw_cpp_path, ..
    all_libs, ..
    inter_ldflags, ..
    inter_cflags);

endfunction
// ====================================================================
builder_gateway_cpp();
clear builder_gateway_cpp;
// ====================================================================

























































