//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [fout1,fout2,mout] = imbestmatches(fobj1,fobj2,m,n);
    // Find the best matched features from 2 features objects and the matching matrix
    //
    // Syntax
    //     [fout1,fout2,mout] = imbestmatches(fobj1,fobj2,m,n);
    //
    // Parameters
    //     fobj1 : First feature object
    //     fobj2 : Second feature object
    //     m : Matching matrix
    //     n : Number of best matches to returned
    //     fout1 : First best feature object
    //     fout2 : Second best feature object
    //     mout : New matching matrix corresponding to the best matches
    //          
    // Description
    //    This function find the best matches of 2 features objects with their mathching matrix.
    //
    // Examples
    //    // Read the image and rotate it by 45 degrees
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    S2 = imrotate(S,45);
    //    // Use the ORB to detect features
    //    f1 = imdetect_ORB(S)
    //    f2 = imdetect_ORB(S2)
    //    // Extract the descriptor
    //    d1 = imextract_DescriptorORB(S,f1);
    //    d2 = imextract_DescriptorORB(S2,f2);
    //    // Feature matching
    //    m = immatch_BruteForce(d1,d2,4)
    //    // Find the 10 best matches
    //    [fout1,fout2,mout] = imbestmatches(f1,f2,m,10);
    //    // Draw the matches
    //    SS = imdrawmatches(S,S2,fout1,fout2,mout);
    //    // Show the comparison
    //    imshow(SS);
    //
    // See also
    //     imdrawmatches
    //     immatch_Brute
    //
    // Authors
    //    Tan Chin Luh
    //
    
    
    rhs=argn(2);

    // Error Checking
    if rhs < 3; error("At least 3 argument expected, fobj1, fobj2, and m"); end    
    if rhs < 4; n = 5; end
    
    if isempty(n); n = 5; end
    checkrange(4,n,3,30); 

    mm = gsort(m($:-1:1,:),'lc','i');
    m2 = mm($:-1:1,:);
    
    //mmm = gsort(mm,'lc','i')
    m_new = m2(:,1:n);


    fm1 = [fobj1.x;fobj1.y;fobj1.size;fobj1.angle;fobj1.response;fobj1.octave;fobj1.class_id];
    fm2 = [fobj2.x;fobj2.y;fobj2.size;fobj2.angle;fobj2.response;fobj2.octave;fobj2.class_id];

/////////
    fout1.type = fobj1.type;
    fout1.n = n;
    fout1.x = fm1(1,m_new(1,:));
    fout1.y = fm1(2,m_new(1,:));
    fout1.size = fm1(3,m_new(1,:));
    fout1.angle = fm1(4,m_new(1,:));
    fout1.response = fm1(5,m_new(1,:));
    fout1.octave = fm1(6,m_new(1,:));
    fout1.class_id = fm1(7,m_new(1,:));

    fout2.type = fobj2.type;
    fout2.n = n;
    fout2.x = fm2(1,m_new(2,:));
    fout2.y = fm2(2,m_new(2,:));
    fout2.size = fm2(3,m_new(2,:));
    fout2.angle = fm2(4,m_new(2,:));
    fout2.response = fm2(5,m_new(2,:));
    fout2.octave = fm2(6,m_new(2,:));
    fout2.class_id = fm2(7,m_new(2,:));

mout = m_new;
mout(1,:) = 1:n;
mout(2,:) = 1:n;
///////    
    
      
endfunction










