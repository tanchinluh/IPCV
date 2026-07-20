//==============================================================================
// IPCV DICOM slice viewer regression tests
// <-- NO CHECK REF -->
//==============================================================================

filename = fullpath(getIPCVpath() + "/images/dicom/emri_small.dcm");
view = dicomshow(filename, [1 5 10], "general");
assert_checkequal(view.Slices, [1 5 10]);
assert_checkequal(view.InfoMode, "general");
assert_checkequal(length(view.Images), 3);
assert_checkequal(view.Info.Modality, "MR");
close(view.Figure);

[volume, info] = dicomread(filename);
view = dicomshow(volume, 5, "slice", info);
assert_checkequal(view.Slices, 5);
assert_checkequal(view.InfoMode, "slice");
assert_checkequal(view.Info.Frames, 10);
close(view.Figure);

view = dicomshow(volume, [2 8], %f, info);
assert_checkequal(view.InfoMode, "none");
close(view.Figure);
