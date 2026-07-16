//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 morphology completeness
// <-- NO CHECK REF -->
//==============================================================================

mask = zeros(7, 8) == 1;
mask(2, 2) = %t;
mask(4:5, 5:6) = %t;
clean = imbwareaopen(mask, 2);
assert_checkequal(typeof(clean), "boolean");
assert_checkequal(sum(clean), 4);
assert_checktrue(~clean(2, 2));
assert_checktrue(clean(4, 5));

borderMask = zeros(7, 8) == 1;
borderMask(1, 3) = %t;
borderMask(3:5, 4:6) = %t;
cleared = imclearborder(borderMask);
assert_checkequal(sum(cleared), 9);
assert_checktrue(~cleared(1, 3));
assert_checktrue(cleared(4, 5));

diagonal = [%t %f %f; %f %t %f; %f %f %t];
assert_checkequal(sum(imbwareaopen(diagonal, 2, 4)), 0);
assert_checkequal(sum(imbwareaopen(diagonal, 2, 8)), 3);
assert_checktrue(execstr("imbwareaopen(diagonal, 0);", "errcatch") <> 0);
assert_checktrue(execstr("imclearborder(diagonal, 6);", "errcatch") <> 0);

//==============================================================================
