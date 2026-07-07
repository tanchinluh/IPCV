//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated gateway image exchange adapter
//==============================================================================

u8 = uint8([1 2; 3 4]);
assert_checkequal(imadd(u8, uint8(1)), uint8([2 3; 4 5]));

u16 = uint16([10 20; 30 40]);
assert_checkequal(imadd(u16, uint16(2)), uint16([12 22; 32 42]));

i32 = int32([10 20; 30 40]);
assert_checkequal(imsubtract(i32, int32(2)), int32([8 18; 28 38]));

dbl = [1.5 2.5; 3.5 4.5];
assert_checkequal(imadd(dbl, 1), dbl + 1);

img = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
patch = img(1:4, 1:5, :);
resized = imresize(patch, [8 10], "nearest");
assert_checkequal(typeof(resized), "uint8");
assert_checkequal(size(resized), [8 10 3]);

//==============================================================================
