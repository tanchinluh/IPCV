function [volume, info] = dicomread(filename, applyRescale)
    // Read uncompressed grayscale DICOM pixel data and metadata.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then
        error("dicomread: expected filename and optional applyRescale.");
    end
    if type(filename) <> 10 | size(filename, "*") <> 1 then
        error("dicomread: filename must be a scalar string.");
    end
    if rhs < 2 then applyRescale = %t; end
    if type(applyRescale) <> 4 | size(applyRescale, "*") <> 1 then
        error("dicomread: applyRescale must be a scalar boolean.");
    end

    [volume, numericInfo, textInfo] = int_dicomread(fullpath(filename), bool2s(applyRescale));
    representation = "unsigned";
    if numericInfo(8) <> 0 then representation = "signed"; end
    info = struct( ..
        "Filename", fullpath(filename), ..
        "Rows", numericInfo(1), ..
        "Columns", numericInfo(2), ..
        "Frames", numericInfo(3), ..
        "SamplesPerPixel", numericInfo(4), ..
        "BitsAllocated", numericInfo(5), ..
        "BitsStored", numericInfo(6), ..
        "HighBit", numericInfo(7), ..
        "PixelRepresentationCode", numericInfo(8), ..
        "PixelRepresentation", representation, ..
        "PlanarConfiguration", numericInfo(9), ..
        "RescaleSlope", numericInfo(10), ..
        "RescaleIntercept", numericInfo(11), ..
        "WindowCenter", numericInfo(12), ..
        "WindowWidth", numericInfo(13), ..
        "PixelSpacing", numericInfo(14:15)', ..
        "SliceThickness", numericInfo(16), ..
        "SpacingBetweenSlices", numericInfo(17), ..
        "RawRange", numericInfo(18:19)', ..
        "RescaleApplied", numericInfo(20) <> 0, ..
        "TransferSyntaxUID", textInfo(1), ..
        "SOPClassUID", textInfo(2), ..
        "Modality", textInfo(3), ..
        "PhotometricInterpretation", textInfo(4), ..
        "PatientName", textInfo(5), ..
        "PatientID", textInfo(6), ..
        "StudyDate", textInfo(7), ..
        "StudyDescription", textInfo(8), ..
        "SeriesDescription", textInfo(9), ..
        "Manufacturer", textInfo(10), ..
        "StudyInstanceUID", textInfo(11), ..
        "SeriesInstanceUID", textInfo(12));
endfunction
