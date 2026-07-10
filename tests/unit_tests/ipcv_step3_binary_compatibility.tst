//==============================================================================
// IPCV OpenCV 5.0.0 development Step 3 binary and ROI compatibility batch
// <-- NO CHECK REF -->
//==============================================================================

mask = zeros(7, 7) == 1;
mask(2:4, 2:4) = %t;
mask(6, 6) = %t;

perimeter = imbwperim(mask, 8);
assert_checkequal(typeof(perimeter), "boolean");
assert_checktrue(perimeter(2, 2));
assert_checktrue(~perimeter(3, 3));

[labels4, count4] = imlabel([%t %f; %f %t]);
assert_checkequal(count4, 2);
[labels, count, stats, centroids] = imconnectedcomponents(mask, 8);
assert_checkequal(count, 2);
assert_checkequal(size(stats), [2 5]);
assert_checkequal(size(centroids), [2 2]);

selected = imbwselect(mask, [2 6], [2 6]);
assert_checkequal(sum(selected), 10);

se = imcreatese("cross", 3, 3);
hitmiss = imbwhitmiss(mask, se);
thin = imbwthin(mask);
filled = imfillholes(mask);
assert_checkequal(typeof(hitmiss), "boolean");
assert_checkequal(typeof(thin), "boolean");
assert_checkequal(typeof(filled), "boolean");

morphOpen = imbwmorph(mask, "open");
morphThin = imbwmorph(mask, "thin");
assert_checkequal(typeof(morphOpen), "boolean");
assert_checkequal(typeof(morphThin), "boolean");

colored = imlabel2rgb(labels);
assert_checkequal(typeof(colored), "uint8");
assert_checkequal(size(colored), [7 7 3]);

polygon = impoly2mask([2 5 5 2], [2 2 5 5], 7, 7);
assert_checktrue(polygon(3, 3));
assert_checktrue(~polygon(1, 1));

boundaries = imbwboundaries(mask);
assert_checktrue(size(boundaries) > 0);
filledExplicit = imfillholes(mask);
assert_checkequal(filledExplicit, filled);

assert_checktrue(execstr("imbwselect(mask, 99, 99);", "errcatch") <> 0);
assert_checktrue(execstr("imbwmorph(mask, ""unsupported"");", "errcatch") <> 0);

//==============================================================================
