//===========================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//===========================================================
// ToDo : Improve and document
function [image] = skeleton(I,display);

//This function is to obtain the skeleton of the fingerprint

// I1 = bwmorph(I,'clean');
se = [0 0 0;0 1 0;0 0 0];
I1 = imerode(I,se);

I2 = imbwmorph(I1,'spur');

I3 = imbwmorph(I2,'hbreak');

I4 = imbwmorph(I3,'thin',inf);

I5 = imbwmorph(I4,'skel',inf);

image = I5;

if (display == 1)
    scf;imshow(I5);title('skeleton of the fingerprint');
end

endfunction
