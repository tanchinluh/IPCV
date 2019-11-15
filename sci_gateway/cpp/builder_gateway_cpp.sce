// -------------------------------------------------------------------------
// SIVP - Scilab Image Processing toolbox
// Copyright (C) 2005-2010  Shiqi Yu
// Copyright (C) 2012 - DIGITEO - Allan CORNET
// Copyright (C) 2017 - Trity - Tan Chin Luh
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

    // This line added for integrating with custom C/C++ code
    //includes_src_cpp = get_absolute_file_path("builder_gateway_cpp.sce") + "../../src/cpp";
    includes_src_cpp = '';
    //

    gw_cpp_files = findfiles(gw_cpp_path, '*.cpp');
    scifunctions_name = gw_cpp_files(grep(gw_cpp_files, 'sci_'));
    scifunctions_name = strsubst(scifunctions_name, 'sci_', '');
    scifunctions_name = strsubst(scifunctions_name, 'percent', '%');
    scifunctions_name = strsubst(scifunctions_name, '.cpp', '');

    cppfunctions_name = gw_cpp_files(grep(gw_cpp_files,'sci_'));
    cppfunctions_name = strsubst(cppfunctions_name, '.cpp', '');

    gw_tables = [scifunctions_name, cppfunctions_name];

    opencv_libs = [];


    /////////////////////////////////////////////////////////////////////////
    //  if getos() <> 'Windows' then  //linux, Darwin
    //
    //    gw_cpp_files = [gw_cpp_files; "common.h"];
    //    gw_cpp_files(gw_cpp_files == 'dllipcv.cpp') = [];
    //
    //    if getos() == 'Darwin' then
    //      if ~isdir("/usr/local/include/opencv") then
    //        error("Can not find OpenCV 2.4.3. Compiling IPCV needs OpenCV > 2.4.3");
    //      end
    ////      inter_cflags = "-DOPENCV_V2 -I/usr/local/include/opencv ";
    //    inter_cflags = "";
    //      // inter_ldflags = "-lopencv_core -lopencv_imgproc -lopencv_calib3d -lopencv_video -lopencv_features2d -lopencv_ml -lopencv_highgui -lopencv_objdetect -lopencv_contrib -lopencv_legacy";
    //      inter_ldflags = "";
    //
    //    else // Linux
    //      opencv_version = unix_g('pkg-config --modversion opencv');
    //      if( length(opencv_version) == 0 | ( strtod( strsubst(opencv_version, '.', '')) <= 99.9 ) )
    //        disp(gettext("OpenCV (version >= 2.4.3) is needed for compiling IPCV."));
    //      end;
    //
    //      if ( strtod( strsubst(opencv_version, '.', '')) < 111 ) then //if opencv version <1.1.1
    //        inter_cflags = "-DOPENCV_V1 ";
    //      else
    //        inter_cflags = "-DOPENCV_V2 ";
    //      end;
    //      
    //       inter_cflags = inter_cflags + unix_g('pkg-config --cflags opencv');
    //     
    //       OPENCV_INCLUDE_ROOT_PATH = fullpath(gw_cpp_path + "../../thirdparty/opencv/Linux/include");
    //       OPENCV_INCLUDE = fullpath(OPENCV_INCLUDE_ROOT_PATH + "/opencv");
    //       OPENCV2_INCLUDE = fullpath(OPENCV_INCLUDE_ROOT_PATH + "/opencv2");
    //       // pause
    //       if isempty(inter_cflags)
    //       inter_cflags =  ' -I'+OPENCV_INCLUDE_ROOT_PATH + ' -I'+OPENCV_INCLUDE + ' -I'+OPENCV2_INCLUDE;
    //   else
    //       inter_cflags =  inter_cflags + ' -I'+OPENCV_INCLUDE_ROOT_PATH + ' -I'+OPENCV_INCLUDE + ' -I'+OPENCV2_INCLUDE;
    //       end
    //      // inter_ldflags = unix_g('pkg-config --libs opencv');
    //      //
    //      if (length(inter_cflags)==0) then
    //        disp("Can not find OpenCV. Compiling IPCV needs OpenCV");
    //      end
    //      inter_ldflags = "";
    //    end
    /////////////////////////////////////////////////////////////////////////////////

    if getos() == 'Darwin' then  // Darwin

        gw_cpp_files = [gw_cpp_files; "common.h"];
        gw_cpp_files(gw_cpp_files == 'dllipcv.cpp') = [];

        //if ~isdir("/usr/local/include/opencv") then
        //    error("Can not find OpenCV 2.4.3. Compiling IPCV needs OpenCV > 2.4.3");
        //end
        //      inter_cflags = "-DOPENCV_V2 -I/usr/local/include/opencv ";
        //inter_cflags = "";
        // inter_ldflags = "-lopencv_core -lopencv_imgproc -lopencv_calib3d -lopencv_video -lopencv_features2d -lopencv_ml -lopencv_highgui -lopencv_objdetect -lopencv_contrib -lopencv_legacy";
        //inter_ldflags = "";

        THIRDPARTY_ROOT_PATH = fullpath(gw_cpp_path + "../../thirdparty");
        OPENCV_INCLUDE = fullpath(THIRDPARTY_ROOT_PATH + "/opencv/MacOS/include");
        TORCH_INCLUDE = '';
        //TORCH_INCLUDE = fullpath(gw_cpp_path + "/../../thirdparty/libtorch/Linux/include");
        //TORCH2_INCLUDE = fullpath(gw_cpp_path + "/../../thirdparty/libtorch/Linux/include/torch/csrc/api/include");

        //inter_cflags = ilib_include_flag([OPENCV_INCLUDE,TORCH_INCLUDE, includes_src_cpp]);
        inter_cflags = ' -std=c++11 -stdlib=libc++ -I'+OPENCV_INCLUDE;
        inter_cflags =  inter_cflags + ' -D_GLIBCXX_USE_CXX11_ABI=0';   // This is for LIBTorch
        inter_ldflags = [];
        opencv_libs = [];

        //all_libs = [opencv_libs, "../../src/cpp/libscidlib"];
        all_libs = [];
        
    elseif getos() == "Linux" then  // Linux

        gw_cpp_files = [gw_cpp_files; "common.h"];
        gw_cpp_files(gw_cpp_files == 'dllipcv.cpp') = [];

        //        opencv_version = unix_g('pkg-config --modversion opencv');
        //        if( length(opencv_version) == 0 | ( strtod( strsubst(opencv_version, '.', '')) <= 99.9 ) )
        //            disp(gettext("OpenCV (version >= 2.4.3) is needed for compiling IPCV."));
        //        end;
        //
        //        if ( strtod( strsubst(opencv_version, '.', '')) < 111 ) then //if opencv version <1.1.1
        //            inter_cflags = "-DOPENCV_V1 ";
        //        else
        //            inter_cflags = "-DOPENCV_V2 ";
        //        end;
        //
        //        inter_cflags = inter_cflags + unix_g('pkg-config --cflags opencv');
        //
        //        OPENCV_INCLUDE_ROOT_PATH = fullpath(gw_cpp_path + "../../thirdparty/opencv/Linux/include");
        //        OPENCV_INCLUDE = fullpath(OPENCV_INCLUDE_ROOT_PATH + "/opencv");
        //        OPENCV2_INCLUDE = fullpath(OPENCV_INCLUDE_ROOT_PATH + "/opencv2");
        //        
        //        if isempty(inter_cflags)
        //            inter_cflags =  ' -I'+OPENCV_INCLUDE_ROOT_PATH + ' -I'+OPENCV_INCLUDE + ' -I'+OPENCV2_INCLUDE;
        //        else
        //            inter_cflags =  inter_cflags + ' -I'+OPENCV_INCLUDE_ROOT_PATH + ' -I'+OPENCV_INCLUDE + ' -I'+OPENCV2_INCLUDE;
        //        end
        //        // inter_ldflags = unix_g('pkg-config --libs opencv');
        //        //
        //        if (length(inter_cflags)==0) then
        //            disp("Can not find OpenCV. Compiling IPCV needs OpenCV");
        //        end
        THIRDPARTY_ROOT_PATH = fullpath(gw_cpp_path + "../../thirdparty");
        OPENCV_INCLUDE = fullpath(THIRDPARTY_ROOT_PATH + "/opencv/Linux/include");
        TORCH_INCLUDE = '';
        //TORCH_INCLUDE = fullpath(gw_cpp_path + "/../../thirdparty/libtorch/Linux/include");
        //TORCH2_INCLUDE = fullpath(gw_cpp_path + "/../../thirdparty/libtorch/Linux/include/torch/csrc/api/include");

        //inter_cflags = ilib_include_flag([OPENCV_INCLUDE,TORCH_INCLUDE, includes_src_cpp]);
        inter_cflags = ' -I'+OPENCV_INCLUDE;
        //inter_cflags =  inter_cflags + ' -D_GLIBCXX_USE_CXX11_ABI=0';   // This is for LIBTorch 1.1 
        inter_ldflags = " -std=c++11";
        opencv_libs = [];

        //all_libs = [opencv_libs, "../../src/cpp/libscidlib"];
        all_libs = [];

    else // Windows
        THIRDPARTY_ROOT_PATH = fullpath(gw_cpp_path + "../../thirdparty");
        OPENCV_INCLUDE = fullpath(THIRDPARTY_ROOT_PATH + "/opencv/windows/include");
        TORCH_INCLUDE = '';
        //        TORCH_INCLUDE = fullpath(gw_cpp_path + "../../thirdparty/libtorch/windows/include");
        //        TORCH2_INCLUDE = fullpath(gw_cpp_path + "../../thirdparty/libtorch/windows/include/torch/csrc/api/include");

        inter_cflags = ilib_include_flag([OPENCV_INCLUDE,TORCH_INCLUDE, includes_src_cpp]); 
        
        inter_cflags = inter_cflags + " -std=c++11";
        inter_ldflags = "";

        opencv_libs = [];        
        all_libs = []; // Shall add src lib if exist


    end

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


















































