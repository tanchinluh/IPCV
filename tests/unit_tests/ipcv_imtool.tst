//==============================================================================
// IPCV browser imtool bridge
// <-- NO CHECK REF -->
//==============================================================================

assert_checkequal(exists("imtool"), 1);

global IPCV_IMTOOL_INITIAL_FILE;
global IPCV_IMTOOL_INITIAL_VIDEO;
IPCV_IMTOOL_INITIAL_FILE = "";
IPCV_IMTOOL_INITIAL_VIDEO = "";
emptyInit = ipcv_imtool_init_json();
assert_checktrue(strindex(emptyInit, """status"":""ok""") <> []);
assert_checktrue(strindex(emptyInit, """initialFile"":""""") <> []);

IPCV_IMTOOL_INITIAL_FILE = fullpath(getIPCVpath() + "/images/opencv_fruits.jpg");
fileInit = ipcv_imtool_init_json();
assert_checktrue(strindex(fileInit, """initialFile"":""file:///") <> []);
assert_checktrue(strindex(fileInit, "opencv_fruits.jpg") <> []);

IPCV_IMTOOL_INITIAL_FILE = "";
IPCV_IMTOOL_INITIAL_VIDEO = fullpath(getIPCVpath() + "/images/video.mpg");
videoInit = ipcv_imtool_init_json();
assert_checktrue(strindex(videoInit, "video.mpg") <> []);
assert_checktrue(strindex(videoInit, """initialVideo"":""") <> []);

videoOpen = ipcv_imtool_video_open_json(IPCV_IMTOOL_INITIAL_VIDEO);
assert_checktrue(strindex(videoOpen, """status"":""ok""") <> []);
assert_checktrue(strindex(videoOpen, """frameCount"":") <> []);
assert_checktrue(strindex(videoOpen, """frame"":1") <> []);
assert_checktrue(strindex(videoOpen, """uri"":""data:image/png;base64,") <> []);
videoFrame = ipcv_imtool_video_frame_json(1);
assert_checktrue(strindex(videoFrame, """status"":""ok""") <> []);
assert_checktrue(strindex(videoFrame, """frame"":1") <> []);
assert_checktrue(strindex(videoFrame, """uri"":""data:image/png;base64,") <> []);
assert_checktrue(strindex(videoFrame, "?frame=") == []);
global IPCV_IMTOOL_VIDEO_FRAME_FILE;
assert_checkequal(IPCV_IMTOOL_VIDEO_FRAME_FILE, "");
videoFrame = ipcv_imtool_video_frame_json(2);
assert_checktrue(strindex(videoFrame, """status"":""ok""") <> []);
assert_checktrue(strindex(videoFrame, """frame"":2") <> []);
assert_checktrue(strindex(videoFrame, """uri"":""data:image/png;base64,") <> []);
assert_checktrue(strindex(videoFrame, "?frame=") == []);
assert_checkequal(IPCV_IMTOOL_VIDEO_FRAME_FILE, "");

recordFrame = fromJSON(videoFrame);
recordFile = tempname("ipc") + ".avi";
assert_checkequal(int_imtoolrecord("start", recordFile, 10), 0);
assert_checkequal(int_imtoolrecord("frame", recordFrame.uri), 1);
assert_checkequal(int_imtoolrecord("frame", recordFrame.uri), 2);
assert_checkequal(int_imtoolrecord("stop"), 2);
assert_checktrue(isfile(recordFile));
[recordCount, recordWidth, recordHeight, recordFps] = aviinfo(recordFile);
assert_checktrue(recordCount >= 2);
assert_checktrue(recordWidth > 0 & recordHeight > 0);
assert_checkequal(recordFps, 10);
mdelete(recordFile);

videoClose = ipcv_imtool_video_close_json();
assert_checktrue(strindex(videoClose, """status"":""ok""") <> []);

htmlFile = fullpath(getIPCVpath() + "/macros/GUI/imtool/imtool.html");
assert_checktrue(isfile(htmlFile));
html = strcat(mgetl(htmlFile), ascii(10));
assert_checktrue(strindex(html, "id=""openVideoButton""") <> []);
assert_checktrue(strindex(html, "id=""playPauseButton""") <> []);
assert_checktrue(strindex(html, "id=""temporalMode""") <> []);
assert_checktrue(strindex(html, "id=""recordButton""") <> []);
assert_checktrue(strindex(html, "id=""recordRate""") <> []);
assert_checktrue(strindex(html, "renderedRecordingFrame") <> []);
assert_checktrue(strindex(html, "type: ""recordFrame""") <> []);
assert_checktrue(strindex(html, "response.request === ""recordStop""") <> []);
assert_checktrue(strindex(html, "Frame difference") <> []);
assert_checktrue(strindex(html, "Motion heatmap") <> []);
assert_checktrue(strindex(html, "Temporal average") <> []);
assert_checktrue(strindex(html, "Optical flow vectors") <> []);
assert_checktrue(strindex(html, "type: ""videoOpen""") <> []);
assert_checktrue(strindex(html, "type: ""videoFrame""") <> []);
assert_checktrue(strindex(html, "function sendScilab(command)") <> []);
assert_checktrue(strindex(html, "response.request === ""videoFrame""") <> []);
imtoolSource = strcat(mgetl(fullpath(getIPCVpath() + "/macros/GUI/imtool/imtool.sci")), ascii(10));
assert_checktrue(strindex(imtoolSource, "runtime_html = tempname") <> []);
assert_checktrue(strindex(imtoolSource, "copyfile(html_file, runtime_html)") <> []);
assert_checktrue(strindex(html, "native OpenCV video") <> []);
assert_checktrue(strindex(html, "callback(response)") <> []);
assert_checktrue(strindex(html, "frame decoding did not return within 10 seconds") <> []);
assert_checktrue(isfile(fullpath(getIPCVpath() + "/macros/GUI/imtool/ipcv_imtool_record_start_json.sci")));
assert_checktrue(isfile(fullpath(getIPCVpath() + "/macros/GUI/imtool/ipcv_imtool_record_frame_json.sci")));
assert_checktrue(isfile(fullpath(getIPCVpath() + "/macros/GUI/imtool/ipcv_imtool_record_stop_json.sci")));

escaped = ipcv_imtool_json_escape("a" + ascii(10) + """b");
assert_checktrue(strindex(escaped, "\") <> []);
assert_checktrue(strindex(escaped, "\n") <> []);
assert_checktrue(strindex(escaped, """") <> []);
