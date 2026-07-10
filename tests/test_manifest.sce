function [suites, requirements] = ipcv_manifest_mark(names, suites, requirements, selectedNames, suiteName, requirement)
    for i = 1:size(selectedNames, "*")
        index = find(names == selectedNames(i));
        if isempty(index) then
            error(msprintf("Test manifest references missing test: %s", selectedNames(i)));
        end
        suites(index) = suiteName;
        requirements(index) = requirement;
    end
endfunction

function stability = ipcv_manifest_mark_stability(names, stability, selectedNames)
    for i = 1:size(selectedNames, "*")
        index = find(names == selectedNames(i));
        if isempty(index) then
            error(msprintf("Stability manifest references missing test: %s", selectedNames(i)));
        end
        stability(index) = %t;
    end
endfunction

function manifest = ipcv_test_manifest(testRoot)
    unitRoot = fullfile(testRoot, "unit_tests");
    files = findfiles(unitRoot, "*.tst");
    names = gsort(strsubst(files, ".tst", ""), "g", "i");

    suites = emptystr(names);
    suites(:) = "core";
    requirements = emptystr(names);
    requirements(:) = "none";
    platforms = emptystr(names);
    platforms(:) = "Windows,Linux,Darwin";
    families = emptystr(names);
    families(:) = "function-regression";
    stability = repmat(%f, size(names, 1), size(names, 2));

    for i = 1:size(names, "*")
        if strindex(names(i), "ipcv_") == 1 then
            families(i) = "category-regression";
        end
    end

    guiTests = [ ..
        "edge"; ..
        "imdecorrstretch"; ..
        "imdeconvl2"; ..
        "imdeconvsobolev"; ..
        "imdeconvwiener"; ..
        "imdct"; ..
        "imfilter"; ..
        "imhist"; ..
        "imhistequal"; ..
        "iminpaint"; ..
        "immedian"; ..
        "immesh"; ..
        "imnoise"; ..
        "imroifilt"; ..
        "imshow"; ..
        "imsmoothsurf"; ..
        "imsurf"; ..
        "imtransform"; ..
        "imwiener2"; ..
        "ipcv_imshow"; ..
        "mkfftfilter" ..
    ];
    [suites, requirements] = ipcv_manifest_mark(names, suites, requirements, guiTests, "gui", "graphics-session");

    integrationTests = [ ..
        "imstitch"; ..
        "imsuperres"; ..
        "ipcv_codec_matrix"; ..
        "ipcv_detection_tracking"; ..
        "ipcv_dnn"; ..
        "ipcv_handle_lifecycle"; ..
        "ipcv_hough_stitching"; ..
        "ipcv_image_io"; ..
        "ipcv_superres"; ..
        "ipcv_video_camera" ..
    ];
    [suites, requirements] = ipcv_manifest_mark(names, suites, requirements, integrationTests, "integration", "bundled-assets,native-lifecycle");

    networkTests = ["ipcv_dnn_network"];
    [suites, requirements] = ipcv_manifest_mark(names, suites, requirements, networkTests, "network", "network,external-model");

    hardwareTests = ["ipcv_camera_hardware"];
    [suites, requirements] = ipcv_manifest_mark(names, suites, requirements, hardwareTests, "hardware", "camera-hardware");

    stabilityTests = [ ..
        "ipcv_version"; ..
        "imfuse"; ..
        "ipcv_gateway_image_exchange"; ..
        "ipcv_input_contracts"; ..
        "ipcv_image_io"; ..
        "ipcv_codec_matrix"; ..
        "ipcv_arithmetic"; ..
        "ipcv_spatial_transform"; ..
        "ipcv_filtering"; ..
        "ipcv_morphology"; ..
        "ipcv_color"; ..
        "ipcv_edge_filter"; ..
        "ipcv_binary_analysis"; ..
        "ipcv_enhancement"; ..
        "ipcv_image_transform"; ..
        "ipcv_structural_analysis"; ..
        "ipcv_feature_detection"; ..
        "ipcv_hough_stitching"; ..
        "ipcv_dnn"; ..
        "ipcv_handle_lifecycle"; ..
        "ipcv_repository_contracts" ..
    ];
    stability = ipcv_manifest_mark_stability(names, stability, stabilityTests);

    manifest = struct( ..
        "name", names, ..
        "suite", suites, ..
        "requirements", requirements, ..
        "platforms", platforms, ..
        "family", families, ..
        "stability", stability ..
    );
endfunction
