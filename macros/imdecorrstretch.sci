//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imdecorrstretch(x,useCorr,tol)
// Apply decorrelation stretch to multichannel image
//
// Syntax
//     S = imdecorrstretch(I, tol, useCorr)
//
// Parameters
//     I : Input image
//     tol :  The fraction of the image to saturate at low and high intensities. If tol is an scalar, high intensity is 1 - tol.
//     useCorr : 1 to use correlation method, 0 to use covariance method.
//     S : Stretched output image 
//
// Description
//    The primary purpose of decorrelation stretch is visual enhancement. Decorrelation stretching is a way to enhance the color differences in an image.
//    
// Examples
//     S = imread(fullpath(getIPCVpath() + "/images/" + 'baboon.png'));
//     S2 = imdecorrstretch(S);
//     subplot(121);imshow(S);
//     subplot(122);imshow(S2);
// 
// See also
//     imadjust
//
// Authors
//     Tan Chin Luh

    [lhs ,rhs]=argn();
    if rhs <1 then error('At least 1 argument required'); end
    if rhs <2 then tol = 0.01; end
    if rhs <3 then useCorr = 1; end
        
    if sum(length(tol))==1 then
        tol(2) = 1-tol(1);
    elseif sum(length(tol))>2
        error('wrong data of tol');
    end
    
    // convert to double
    ori_type = typeof(x(1));
    if type(x(1))~=1 then
        x = im2double(x);
    end

    // Methods and Parameters, for this version, targetmeam, targetsigma rowsubs and colsubs are not implemented
    //mode = 'correlation';
    //tol = [];     // For imadjust
    targetMean = [];
    targetSigma = [];
    rowsubs = [];
    colsubs = [];
    

    // decorr function
    [r c nbands] = size(x);
    npixels = r * c;  
    x = matrix(x,[npixels nbands]);  

    // rowsubs/colsubs parameters
    if isempty(rowsubs)
        B = x;
    else
        ind = sub2ind([r c], rowsubs, colsubs);
        B = x(ind,:);
    end   

    meanB = mean(B,1);
    n = size(B,1); 

    if n == 1
        cov = zeros(nbands,nbands);
    else
        cov = (B' * B - (n * meanB') * meanB)/(n - 1);  // Sample covariance matrix
    end

    [T, offset]  = fitdecorrtrans(meanB, cov, useCorr, targetMean, targetSigma);
    
    off2 = repmat(offset,size(x,1),1);  // to be improved
    
    y = x*T + off2;
    y = matrix(y, [r c nbands]);
    
    if ~isempty(tol)
        low_high = imstretchlim(y,tol);
        y = imadjust2(y,low_high);
        y(y < 0) = 0;
        y(y > 1) = 1;
    end

    // Convert back to original datatype
    if ori_type ==  'int8' | ori_type ==  'int16' | ori_type ==  'int32' | ori_type ==  'uint8' | ori_type ==  'uint16' then
        str = 'im2' + ori_type + '(y)';
        y = evstr(str);    
    end
endfunction

function [T, offset] = fitdecorrtrans(means, Cov, useCorr, targetMean, targetSigma)

// Square-root variances in a diagonal matrix.
S = diag(sqrt(diag(Cov)));  

if isempty(targetSigma)
    // Restore original sample variances.
    targetSigma = S;
end

if useCorr
    Corr = pinv(S) * Cov * pinv(S);
    Corr((eye(size(Corr,1)))) = 1;
    [V D] = spec(Corr);
    V = real(V);
    D = real(D);
    T = pinv(S) * V * decorrWeight(D) * V' * targetSigma;
else
    [V D] = spec(Cov);
    V = real(V);
    D = real(D);
    T = V * decorrWeight(D) * V' * targetSigma;
end

// Get the output variances right even for correlated bands, except
// for zero-variance bands---which can't be stretched at all.
T = T * pinv(diag(sqrt(diag(T' * Cov * T)))) * targetSigma;

if isempty(targetMean)
    // Restore original sample means.
    targetMean = means;
end

offset = targetMean - means * T;
endfunction
//--------------------------------------------------------------------------
function W = decorrWeight(D)

// Given the diagonal eigenvalue matrix D, compute the decorrelating
// weights W.  In the full rank, well-conditioned case, decorrWeight(D)
// returns the same result as sqrt(inv(D)).  In addition, it provides
// a graceful way to handle rank-deficient or near-rank-deficient
// (ill-conditioned) cases resulting from situations of perfect or
// near-perfect band-to-band correlation and/or bands with zero variance.

D(D < 0) = 0;
W = sqrt(pinv(D));
endfunction
//--------------------------------------------------------------------------
function S = pinv(D)

// Pseudoinverse of a diagonal matrix, with a larger-than-standard
// tolerance to help in handling edge cases.  We've provided our
// own in order to: (1) Avoid replacing all calls to PINV with calls to
// PINV(...,TOL) and (2) Take advantage of the fact that our input is
// always diagonal so we don't need to call SVD.

d = diag(D);
tol =length(d) * max(d) * sqrt(%eps);
keep = d > tol;
s = ones(d);
s(keep) = s(keep) ./ d(keep);
s(~keep) = 0;
S = diag(s);
endfunction


function lowhigh = imstretchlim(img, tol)


if type(img(1)) == 8
    nbins = 256;
else
    nbins = 65536;
end

tol_low = tol(1);
tol_high = tol(2);
 
p = size(img,3);

if tol_low < tol_high
    ilowhigh = zeros(2,p);
    for i = 1:p                          // Find limits, one plane at a time
        N = imhist(img(:,:,i),nbins);
        cdf = cumsum(N)/sum(N); //cumulative distribution function
//        ilow = find(cdf > tol_low, 1, 'first');
        ilow_all = find(cdf > tol_low, 1);
        ilow = ilow_all(1);
//        ihigh = find(cdf >= tol_high, 1, 'first');
        ihigh_all = find(cdf >= tol_high, 1);
        ihigh = ihigh_all(1);
        if ilow == ihigh   // this could happen if img is flat
            ilowhigh(:,i) = [1;nbins];
        else
            ilowhigh(:,i) = [ilow;ihigh];
        end
    end
    lowhigh = (ilowhigh - 1)/(nbins-1);  // convert to range [0 1]

else
    //   tol_low >= tol_high, this tolerance does not make sense. For example, if
    //   the tolerance is .5 then no pixels would be left after saturating
    //   low and high pixel values. In all of these cases, STRETCHLIM
    //   returns [0; 1]. See gecks 278249 and 235648.
    lowhigh = repmat([0;1],1,p);
end
endfunction

//-----------------------------------------------------------------------------
function out = imadjust2(img,low_high)
// A short, specialized version of IMADJUST that works with
// an arbitrary number of image planes.

low  = low_high(1,:);
high = low_high(2,:);
out = zeros(img);

// Loop over image planes and perform transformation.
for p = 1:size(img,3)
    // Make sure img is in the range [low,high].
    img(:,:,p) =  max(low(p),min(high(p),img(:,:,p)));

    // Transform.
    out(:,:,p) = (img(:,:,p)-low(p))./(high(p)-low(p));
end
endfunction
