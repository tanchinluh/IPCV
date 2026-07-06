//==============================================================================
// IPCV OpenCV 5 migration
//==============================================================================
// unit test migrated feature detection source layer
//==============================================================================

S = imcreatechecker(8, 8, [1 0.5]);

fast = imdetect_FAST(S);
assert_checkequal(fast.type, "FAST");
assert_checktrue(fast.n >= 0);
assert_checkequal(size(fast.x, 2), fast.n);

brisk = imdetect_BRISK(S);
assert_checkequal(brisk.type, "BRISK");
assert_checkequal(brisk.n, 255);
assert_checkequal(size(brisk.x, 2), brisk.n);
briskDescriptors = imextract_DescriptorBRISK(S, brisk);
assert_checkequal(size(briskDescriptors), [255 64]);

gftt = imdetect_GFTT(S);
assert_checkequal(gftt.type, "HARRIS");
assert_checktrue(gftt.n >= 0);
assert_checkequal(size(gftt.x, 2), gftt.n);

mser = imdetect_MSER(S);
assert_checkequal(mser.type, "MSER");
assert_checkequal(mser.n, 32);
assert_checkequal(size(mser.x, 2), mser.n);

Srgb = imread(fullpath(getIPCVpath() + "/images/balloons.png"));
mserRgb = imdetect_MSER(Srgb);
assert_checkequal(mserRgb.type, "MSER");
assert_checktrue(mserRgb.n >= 0);
assert_checkequal(size(mserRgb.x, 2), mserRgb.n);

orb = imdetect_ORB(S);
assert_checkequal(orb.type, "ORB");
assert_checktrue(orb.n >= 0);
assert_checkequal(size(orb.x, 2), orb.n);
orbDescriptors = imextract_DescriptorORB(S, orb);
assert_checkequal(size(orbDescriptors), [orb.n 32]);

siftDescriptors = imextract_DescriptorSIFT(S, orb);
assert_checkequal(size(siftDescriptors), [orb.n 128]);

S2 = imrotate(S, 45);
orb2 = imdetect_ORB(S2);
orbDescriptors2 = imextract_DescriptorORB(S2, orb2);
matches = immatch_BruteForce(orbDescriptors, orbDescriptors2, 4);
assert_checkequal(size(matches, 1), 4);
assert_checkequal(size(matches, 2), orb.n);

flannMatches = immatch_Flann(orbDescriptors, orbDescriptors2);
assert_checkequal(size(flannMatches, 1), 4);
assert_checkequal(size(flannMatches, 2), orb.n);

[fout1, fout2, mout] = imbestmatches(orb, orb2, matches, 10);
drawn = imdrawmatches(S, S2, fout1, fout2, mout);
assert_checkequal(size(drawn, 3), 3);
assert_checktrue(size(drawn, 1) > 0);
assert_checktrue(size(drawn, 2) > 0);

flannMatches = immatch_Flann(orbDescriptors, orbDescriptors2);
assert_checkequal(size(flannMatches, 1), 4);
assert_checkequal(size(flannMatches, 2), orb.n);

[fout1, fout2, mout] = imbestmatches(orb, orb2, matches, 10);
drawn = imdrawmatches(S, S2, fout1, fout2, mout);
assert_checkequal(size(drawn, 3), 3);
assert_checktrue(size(drawn, 1) > 0);
assert_checktrue(size(drawn, 2) > 0);

S2 = imrotate(S, 45);
orb2 = imdetect_ORB(S2);
orbDescriptors2 = imextract_DescriptorORB(S2, orb2);
matches = immatch_BruteForce(orbDescriptors, orbDescriptors2, 4);
assert_checkequal(size(matches, 1), 4);
assert_checkequal(size(matches, 2), orb.n);

star = imdetect_STAR(S);
assert_checkequal(star.type, "STAR");
assert_checkequal(star.n, 196);
assert_checkequal(size(star.x, 2), star.n);

surf = imdetect_SURF(S);
assert_checkequal(surf.type, "SURF");
assert_checktrue(surf.n >= 0);
assert_checkequal(size(surf.x, 2), surf.n);
if surf.n > 0 then
    surfDescriptors = imextract_DescriptorSURF(S, surf);
    assert_checkequal(size(surfDescriptors), [surf.n 64]);
end

//==============================================================================
