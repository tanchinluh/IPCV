//==============================================================================
// IPCV 5.0.0.2 gateway input contracts
// <-- NO CHECK REF -->
//==============================================================================

u8 = uint8([1 2; 3 4]);
u16 = uint16([1 2; 3 4]);
i16 = int16([-4 -2; 2 4]);
i32 = int32([-4 -2; 2 4]);
dbl = [0.1 0.2; 0.3 0.4];
binary = [%f %t; %t %f];

assert_checkequal(typeof(imadd(u8, uint8(1))), "uint8");
assert_checkequal(typeof(imadd(u16, uint16(1))), "uint16");
assert_checkequal(typeof(imadd(i16, int16(1))), "int16");
assert_checkequal(typeof(imadd(i32, int32(1))), "int32");
assert_checkequal(typeof(imadd(dbl, 1)), "constant");

rgb = cat(3, u8, u8 + 1, u8 + 2);
assert_checkequal(size(imresize(u8, [4 4], "nearest")), [4 4]);
assert_checkequal(size(imresize(rgb, [4 4], "nearest")), [4 4 3]);

se = imcreatese("rect", 3, 3);
binaryOut = imdilate(binary, se);
assert_checkequal(typeof(binaryOut), "uint8");
assert_checkequal(size(binaryOut), [2 2]);

assert_checktrue(execstr("imadd([], uint8(1));", "errcatch") <> 0);
assert_checktrue(execstr("imadd(uint8(ones(2, 2)), uint8(ones(3, 3)));", "errcatch") <> 0);
assert_checktrue(execstr("imresize(u8, [0 4]);", "errcatch") <> 0);
assert_checktrue(execstr("imdilate(u8, se, 1, [0 0 0]);", "errcatch") <> 0);

twoChannel = zeros(2, 2, 2);
twoChannelOut = imfilter(twoChannel, ones(3, 3));
assert_checkequal(typeof(twoChannelOut), "constant");
assert_checkequal(size(twoChannelOut), [2 2 2]);

//==============================================================================
