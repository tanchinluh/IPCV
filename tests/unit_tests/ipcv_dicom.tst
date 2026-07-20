//==============================================================================
// IPCV native DICOM reader regression tests
// <-- NO CHECK REF -->
//==============================================================================

filename = fullpath(getIPCVpath() + "/images/dicom/emri_small.dcm");
[volume, info] = dicomread(filename);

assert_checkequal(size(volume), [64 64 10]);
assert_checkequal(typeof(volume), "constant");
assert_checkequal(min(volume), 0);
assert_checkequal(max(volume), 467);
assert_checkequal(sum(matrix(volume, -1, 1)), 4493276);

// These positions detect row/column transposition and frame-order regressions.
assert_checkequal([volume(1, 1, 1) volume(1, 2, 1) volume(2, 1, 1)], [31 8 32]);
assert_checkequal([volume(1, 1, 10) volume(32, 32, 5) volume(64, 64, 10)], [110 119 147]);

assert_checkequal(info.Rows, 64);
assert_checkequal(info.Columns, 64);
assert_checkequal(info.Frames, 10);
assert_checkequal(info.BitsAllocated, 16);
assert_checkequal(info.BitsStored, 12);
assert_checkequal(info.HighBit, 11);
assert_checkequal(info.PixelRepresentation, "unsigned");
assert_checkequal(info.Modality, "MR");
assert_checkequal(info.PhotometricInterpretation, "MONOCHROME2");
assert_checkequal(info.TransferSyntaxUID, "1.2.840.10008.1.2.1");
assert_checkequal(info.RawRange, [0 467]);
assert_checkalmostequal(info.SpacingBetweenSlices, 1.2, 1e-12);
assert_checktrue(info.RescaleApplied);
assert_checkequal(info.PatientName, "");
assert_checkequal(info.PatientID, "");

[rawVolume, rawInfo] = dicomread(filename, %f);
assert_checkequal(rawVolume, volume);
assert_checkfalse(rawInfo.RescaleApplied);
