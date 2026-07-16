//==============================================================================
// IPCV OpenCV 5.0.0 development Step 2 image codec matrix
// <-- NO CHECK REF -->
//==============================================================================

base = uint8(matrix(0:255, 16, 16));
image = cat(3, base, base(:, $:-1:1), uint8(255) - base);
losslessExtensions = [".png"; ".bmp"; ".tif"];
lossyExtensions = [".jpg"; ".webp"];

for i = 1:size(losslessExtensions, "*")
    extension = losslessExtensions(i);
    assert_checktrue(imwritable(extension));
    path = fullfile(TMPDIR, "ipcv_codec_lossless" + extension);
    if isfile(path) then
        mdelete(path);
    end
    assert_checkequal(imwrite(image, path), 1);
    decoded = imread(path);
    assert_checkequal(typeof(decoded), "uint8");
    assert_checkequal(size(decoded), size(image));
    assert_checkequal(decoded, image);
    mdelete(path);
end

for i = 1:size(lossyExtensions, "*")
    extension = lossyExtensions(i);
    assert_checktrue(imwritable(extension));
    path = fullfile(TMPDIR, "ipcv_codec_lossy" + extension);
    if isfile(path) then
        mdelete(path);
    end
    assert_checkequal(imwrite(image, path, 90), 1);
    decoded = imread(path);
    assert_checkequal(typeof(decoded), "uint8");
    assert_checkequal(size(decoded), size(image));
    mdelete(path);
end

multipagePath = fullpath(getIPCVpath() + "/images/img_multipage.tiff");
assert_checktrue(isfile(multipagePath));
multipageInfo = imfinfo(multipagePath);
assert_checktrue(multipageInfo(4) >= 10);
multipage = imreadmulti(multipagePath);
assert_checkequal(typeof(multipage), "uint8");
assert_checktrue(size(multipage, 4) >= 10);

//==============================================================================
