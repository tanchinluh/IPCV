function builder_cpp()
    src_cpp_path = get_absolute_file_path("builder_cpp.sce");

    if getos() == "Windows" then
        ARCH = getenv("PROCESSOR_ARCHITECTURE");
        if ARCH == "" then
            ARCH = "AMD64";
        end
    else
        [_, ARCH] = host("uname -m");
    end

    thirdparty_path = fullpath(fullfile(src_cpp_path, "..", "..", "thirdparty"));
    if getos() == "Windows" then
        opencv_include = fullfile(thirdparty_path, "Windows", ARCH, "include");
        opencv_lib = fullfile("..", "..", "thirdparty", "Windows", ARCH, "lib", "opencv_world500");
    else
        opencv_include = fullfile(thirdparty_path, getos(), ARCH, "include", "opencv5");
        opencv_lib = fullfile("..", "..", "thirdparty", getos(), ARCH, "lib", "libopencv_world");
    end

    cflags = ilib_include_flag([src_cpp_path, opencv_include]);
    if getos() == "Windows" then
        cflags = cflags + " /std:c++17";
    else
        cflags = cflags + " -std=c++17";
    end

    tbx_build_src(["ipcv_core"], ..
        ["ipcv_image_io.cpp"; "ipcv_arithmetic.cpp"; "ipcv_spatial_transform.cpp"; "ipcv_filtering.cpp"; "ipcv_morphology.cpp"; "ipcv_color.cpp"; "ipcv_edge_filter.cpp"; "ipcv_binary_analysis.cpp"; "ipcv_enhancement.cpp"; "ipcv_image_transform.cpp"; "ipcv_segmentation.cpp"; "ipcv_structural_analysis.cpp"; "ipcv_feature_detection.cpp"; "ipcv_hough.cpp"; "ipcv_stitching.cpp"; "ipcv_superres.cpp"; "ipcv_detection_tracking.cpp"; "ipcv_video_camera.cpp"; "ipcv_display_utils.cpp"; "ipcv_dnn.cpp"], ..
        "cpp", ..
        src_cpp_path, ..
        [opencv_lib], ..
        "", ..
        cflags);
endfunction

builder_cpp();
clear builder_cpp;
