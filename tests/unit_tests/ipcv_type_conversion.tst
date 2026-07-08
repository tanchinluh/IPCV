//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test image type conversion edge cases
//==============================================================================

u32 = uint32([0 4294967295]);

d = im2double(u32);
assert_checkequal(typeof(d), "constant");
assert_checktrue(abs(d(1) - 0) < %eps);
assert_checktrue(abs(d(2) - 1) < %eps);

u16 = im2uint16(u32);
assert_checkequal(typeof(u16), "uint16");
assert_checkequal(u16, uint16([0 65535]));

i8 = im2int8(u32);
assert_checkequal(typeof(i8), "int8");
assert_checkequal(i8, int8([-128 127]));

i16 = im2int16(u32);
assert_checkequal(typeof(i16), "int16");
assert_checkequal(i16, int16([-32768 32767]));

i32 = im2int32(u32);
assert_checkequal(typeof(i32), "int32");
assert_checkequal(double(i32), [-2147483648 2147483647]);

//==============================================================================
