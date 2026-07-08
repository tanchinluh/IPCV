////////////////////////////////////////////////////////////
// SIP - Scilab Image Processing toolbox
// Copyright (C) 2002-2004  Ricardo Fabbri
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function h = mkfftfilter(image,name,rc1,rc2)
    // Create frequency domain filter
    //
    // Syntax
    //    h = mkfftfilter(image,name,rc1,rc2)
    //
    // Parameters
    //    image : Source Image 
    //    name : Filter name, a string, the name can be 'binary', 'butterworth1', 'butterworth2', 'exp', 'gauss', or 'trapeze' 
    //    rc1 : 1st cut-off frequencies which set the filter characteristics, which is normalized to 0-1
    //    rc2 : 2nd cut-off frequencies which set the filter characteristics, which is normalized to 0-1
    //    h : A matrix with values between 0 and 1. These values can then be applied on the fft spectrum of an image. 
    //
    // Description
    //     This function gives some popular filters to be applied on the spectrum (fft) of an image. 
    //     The Fourier Transform gives informations about which frequencies are present in a signal (spectrum). 
    //     A great property of the spectrum is that the original image can be reconstructed from it. 
    //     Of course, modifications in the spectrum will result in a modified image, 
    //     but spectrum modifications can be easier and more intuitive. A combination of several filters is possible. 
    //     All these filters are cylindrical and act only on amplitude (not on phase). 
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/measure_gray.jpg"));
    //    h = mkfftfilter(S,'gauss',0.1);
    //    S2 = fft2(im2double(S));
    //    S3 = S2.*fftshift(h);
    //    S4 = real(ifft(S3));
    //    imshow(S4);
    //
    // See also
    //    imfilter
    //
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    //    1. "Optique: fondements et applications" J-P PEREZ 6e edition, Dunod
    //    2. chap34: introduction au traitement numerique des images et a la couleur


    if (argn(2)==0|argn(2)<3|argn(2)>4) then
        error("Wrong number of arguments: mkfftfilter(image,name,rc1[,rc2])")
    end;




    [r,c]=size(image);

    mindim = min(r,c);

    rc1 = round(rc1*mindim/2);


    x=((1:r)'*ones(1:c));
    y=((1:c)'*ones(1:r))';
    x0=r/2;y0=c/2;

    //Passing in cylindrical coordinates:
    //each element of the matrix has the value of the radius
    r=sqrt((x-x0).^2+(y-y0).^2);


    select name
    case 'binary' then
        h=zeros(r);
        h(find(r<=rc1))=1;h(find(r>rc1))=0;

    case 'butterworth1'
        n=1;
        d=1+(r/rc1).^(2*n);
        h=ones(r)./d;

    case 'butterworth2'
        n=2;
        d=1+(r/rc1).^(2*n);
        h=ones(r)./d;

    case 'butterworth3'
        n=3;
        d=1+(r/rc1).^(2*n);
        h=ones(r)./d;

    case 'exp'//exponential	
        n=1;
        h=exp(-(r/rc1).^n);

    case 'gauss'//gaussian curve
        n=2;
        h=exp(-(r/rc1).^n);

    case 'trapeze'//cutting frequencies: rc2>rc1	
        if ~exists('rc2','local') then
            error("Wrong number of arguments: mkfftfilter(image,''trapeze'',rc1,rc2)")
        else
            rc2 = round(rc2*mindim/2);        
            h=-(r-rc2)/(rc2-rc1);
            h(find(r<=rc1))=1;
            h(find(r>=rc2))=0;
        end

    else
        error("Invalid filter name: ''binary'', ''butterworth1,2,3'', ''exp'', ''gauss'' or ''trapeze''")
    end


endfunction

