//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test imshow accepts displayable non-uint8 image classes
//==============================================================================

rgb = uint8(zeros(2, 2, 3));
rgb(:, :, 1) = uint8([255 0; 0 255]);
rgb(:, :, 2) = uint8([0 255; 0 255]);
rgb(:, :, 3) = uint8([0 0; 255 255]);

imshow(rgb);
imshow(im2double(rgb));
imshow(rgb2gray(im2double(rgb)));
imshow(im2bw(rgb2gray(rgb), 0.5));
imshow(im2int8(rgb));
imshow(im2int16(rgb));
imshow(im2int32(rgb));
imshow(uint32(rgb));

//==============================================================================
