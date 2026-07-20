//==============================================================================
// IPCV GPU volume viewer staging and browser contract
// <-- NO CHECK REF -->
//==============================================================================

assert_checkequal(exists("volshow"), 1);

volume = uint16(zeros(8, 10, 6));
for sliceIndex = 1:6
    volume(:, :, sliceIndex) = uint16(sliceIndex * 100 + grand(8, 10, "uin", 0, 50));
end

[uri, dimensions, intensityRange] = int_volshowencode( ..
    volume, 64, [%nan %nan], 0);
assert_checktrue(strindex(uri, "data:application/octet-stream;base64,") == 1);
assert_checkequal(dimensions, [8 10 6]);
assert_checkequal(size(intensityRange), [1 4]);
assert_checktrue(intensityRange(2) > intensityRange(1));
assert_checkequal(intensityRange(1:2), intensityRange(3:4));

[invertedUri, invertedDimensions, invertedRange] = int_volshowencode( ..
    volume, 64, [100 650], 1);
assert_checktrue(invertedUri <> uri);
assert_checkequal(invertedDimensions, dimensions);
assert_checkequal(invertedRange(3:4), [100 650]);

largeVolume = uint8(zeros(40, 80, 20));
[reducedUri, reducedDimensions] = int_volshowencode( ..
    largeVolume, 32, [%nan %nan], 0);
assert_checkequal(max(reducedDimensions), 32);
assert_checkequal(reducedDimensions, [16 32 8]);

htmlFile = fullpath(getIPCVpath() + "/macros/GUI/volshow/volshow.html");
sourceFile = fullpath(getIPCVpath() + "/macros/GUI/volshow/volshow.sci");
assert_checktrue(isfile(htmlFile));
assert_checktrue(isfile(sourceFile));
html = strcat(mgetl(htmlFile), ascii(10));
source = strcat(mgetl(sourceFile), ascii(10));
assert_checktrue(strindex(html, "getContext(""webgl2""") <> []);
assert_checktrue(strindex(html, "sampler3D") <> []);
assert_checktrue(strindex(html, "Volume rendering") <> []);
assert_checktrue(strindex(html, "Maximum intensity projection") <> []);
assert_checktrue(strindex(html, "Isosurface") <> []);
assert_checktrue(strindex(html, "Orthogonal slice planes") <> []);
assert_checktrue(strindex(html, "2-D layer viewer") <> []);
assert_checktrue(strindex(html, "Mouse wheel changes layer") <> []);
assert_checktrue(strindex(html, "id=""exportLayer""") <> []);
assert_checktrue(strindex(html, "type: ""exportLayer""") <> []);
assert_checktrue(strindex(html, "Z display scale") <> []);
assert_checktrue(strindex(html, "3-D processing") <> []);
assert_checktrue(strindex(html, "type: ""process""") <> []);
assert_checktrue(strindex(html, "type: ""exportVolume""") <> []);
assert_checktrue(strindex(html, "window.fromScilab") <> []);
assert_checktrue(strindex(html, "Save PNG") <> []);
assert_checktrue(strindex(source, "int_volshowencode") <> []);
assert_checktrue(strindex(source, "ipcv_volshow_browser") <> []);
assert_checktrue(strindex(source, "ipcv_volshow_callback") <> []);
assert_checktrue(strindex(source, "spacingSource") <> []);
assert_checktrue(isfile(fullpath(getIPCVpath() + ..
    "/macros/GUI/volshow/ipcv_volshow_process.sci")));
assert_checktrue(isfile(fullpath(getIPCVpath() + ..
    "/macros/GUI/volshow/ipcv_volshow_refresh.sci")));

operations = ["adjust" "box" "gaussian" "median" "gradient" ..
    "threshold" "regionalmax" "erode" "dilate" "open" "close" ..
    "fill" "areaopen" "perimeter" "kmeans"];
parameters = [1 3 1 3 1 1 1 1 1 1 1 1 4 1 3];
for operationIndex = 1:size(operations, "*")
    [processed, processDescription] = ipcv_volshow_process( ..
        volume, operations(operationIndex), parameters(operationIndex), 0.5, 26);
    assert_checkequal(size(processed), size(volume));
    assert_checktrue(processDescription <> "");
end
clear operations parameters operationIndex processed processDescription;

nativeRangeVolume = matrix(linspace(100, 4100, 8 * 10 * 6), 8, 10, 6);
[nativeMedianProcess, nativeMedianDescription] = ipcv_volshow_process( ..
    nativeRangeVolume, "median", 3, 0.5, 26);
assert_checktrue(max(nativeMedianProcess) > 1000);
assert_checktrue(max(nativeMedianProcess) > min(nativeMedianProcess));
[nativeProcessUri, nativeProcessDimensions, nativeProcessRange] = ..
    int_volshowencode(nativeMedianProcess, 64, [%nan %nan], 0);
assert_checkequal(nativeProcessDimensions, [8 10 6]);
assert_checktrue(nativeProcessRange(2) - nativeProcessRange(1) > 1000);
clear nativeRangeVolume nativeMedianProcess nativeMedianDescription nativeProcessUri;
clear nativeProcessDimensions nativeProcessRange;

axial = ipcv_volshow_extract_layer(volume, "axial", 3);
coronal = ipcv_volshow_extract_layer(volume, "coronal", 4);
sagittal = ipcv_volshow_extract_layer(volume, "sagittal", 5);
assert_checkequal(size(axial), [8 10]);
assert_checkequal(axial, volume(:, :, 3));
assert_checkequal(size(coronal), [10 6]);
assert_checkequal(coronal, matrix(volume(4, :, :), 10, 6));
assert_checkequal(size(sagittal), [8 6]);
assert_checkequal(sagittal, matrix(volume(:, 5, :), 8, 6));
callbackSource = strcat(mgetl(fullpath(getIPCVpath() + ..
    "/macros/GUI/volshow/ipcv_volshow_callback.sci")), ascii(10));
assert_checktrue(strindex(callbackSource, "resume(layer)") <> []);
assert_checktrue(strindex(callbackSource, "validvar(variableName)") <> []);

function ipcv_volshow_resume_probe(layer, variableName)
    execstr(variableName + " = resume(layer);");
endfunction
expectedWorkspaceLayer = volume(:, :, 4);
ipcv_volshow_resume_probe(expectedWorkspaceLayer, "volshow_workspace_layer");
assert_checktrue(isdef("volshow_workspace_layer"));
assert_checkequal(volshow_workspace_layer, expectedWorkspaceLayer);
clear ipcv_volshow_resume_probe volshow_workspace_layer expectedWorkspaceLayer;

options = struct( ..
    "RenderingStyle", "2d", ..
    "Colormap", "bone", ..
    "Quality", 64, ..
    "VoxelSpacing", [0.8 0.9 1.5]);
viewer = volshow(volume, options);
assert_checkequal(viewer.SourceDimensions, [8 10 6]);
assert_checkequal(viewer.TextureDimensions, [8 10 6]);
assert_checkequal(viewer.VoxelSpacing, [0.8 0.9 1.5]);
assert_checkequal(viewer.RenderingStyle, "2d");
global IPCV_VOLSHOW_SOURCE_VOLUME;
global IPCV_VOLSHOW_ORIGINAL_VOLUME;
assert_checkequal(IPCV_VOLSHOW_SOURCE_VOLUME, volume);
assert_checkequal(IPCV_VOLSHOW_ORIGINAL_VOLUME, volume);
assert_checktrue(isfile(fullfile(viewer.RuntimeDirectory, "volshow.html")));
assert_checktrue(isfile(fullfile(viewer.RuntimeDirectory, "volshow_payload.js")));
assert_checktrue(findobj("tag", "ipcv_volshow_browser") <> []);
payloadSource = strcat(mgetl(fullfile(viewer.RuntimeDirectory, "volshow_payload.js")), ascii(10));
assert_checktrue(strindex(payloadSource, "VoxelSpacing option") <> []);

function ipcv_volshow_test_callback(response)
    global IPCV_VOLSHOW_TEST_RESPONSE;
    IPCV_VOLSHOW_TEST_RESPONSE = response;
endfunction
global IPCV_VOLSHOW_TEST_RESPONSE;
IPCV_VOLSHOW_TEST_RESPONSE = "";
callbackOriginal = IPCV_VOLSHOW_SOURCE_VOLUME;
ipcv_volshow_callback(struct("type", "process", "operation", "gaussian", ..
    "parameter", 1, "threshold", 0.5, "connectivity", 26), ..
    ipcv_volshow_test_callback);
assert_checktrue(IPCV_VOLSHOW_TEST_RESPONSE <> "");
assert_checkequal(size(IPCV_VOLSHOW_SOURCE_VOLUME), size(callbackOriginal));
assert_checktrue(or(IPCV_VOLSHOW_SOURCE_VOLUME <> callbackOriginal));
ipcv_volshow_callback(struct("type", "undoProcessing"), ipcv_volshow_test_callback);
assert_checkequal(IPCV_VOLSHOW_SOURCE_VOLUME, callbackOriginal);
ipcv_volshow_callback(struct("type", "resetProcessing"), ipcv_volshow_test_callback);
assert_checkequal(IPCV_VOLSHOW_SOURCE_VOLUME, callbackOriginal);
clear ipcv_volshow_test_callback IPCV_VOLSHOW_TEST_RESPONSE callbackOriginal payloadSource;
delete(viewer.Figure);
