//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated arithmetic source layer
//==============================================================================

a = uint8([1 2 3; 4 5 6]);
b = uint8([1 1 1; 2 2 2]);

added = imadd(a, b);
assert_checkequal(typeof(added), "uint8");
assert_checkequal(double(added), [2 3 4; 6 7 8]);

subtracted = imsubtract(a, b);
assert_checkequal(typeof(subtracted), "uint8");
assert_checkequal(double(subtracted), [0 1 2; 2 3 4]);

multiplied = immultiply(a, uint8(2));
assert_checkequal(typeof(multiplied), "uint8");
assert_checkequal(double(multiplied), [2 4 6; 8 10 12]);

divided = imdivide(uint8([4 8; 12 16]), uint8(2));
assert_checkequal(typeof(divided), "uint8");
assert_checkequal(double(divided), [2 4; 6 8]);

diffed = imabsdiff(a, b);
assert_checkequal(typeof(diffed), "uint8");
assert_checkequal(double(diffed), abs(double(a) - double(b)));

//==============================================================================
