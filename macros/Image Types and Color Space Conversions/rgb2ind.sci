////////////////////////////////////////////////////////////
// SIP - Scilab Image Processing toolbox
// Copyright (C) 2002-2004  Ricardo Fabbri
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
//=============================================================================
// Copyright (C) Trity Technologies - 2012 -
// http://www.gnu.org/licenses/gpl-2.0.txt
//=============================================================================

function [imout,map] = rgb2ind(imin,n)
    // Convert RGB image to index image
    //
    // Syntax
    //    [imout,map] = rgb2ind(imin,n)
    //
    // Parameters
    //    inm : Source Image
    //    n :  n levels for each color channel intensity
    //    imout : Output indexed image
    //    map : Colormap
    //
    // Description
    //    On input Im is a n1 x n2 x 3 hypermat describing a 
    //    true color image  Im(i,j,:) giving the R-G-B of the 
    //    pixel (i,j).  
    //    On output A is a n1 x n2 matrix, A(i,j) given the 
    //    index on the "true" color map of the (i,j) pixel.
    //    There are n levels for each color channel intensity
    //    (each intensity being given by an integer I between 0 and n-1)
    //    To the "color" R,G,B (R,G,B in [0,n-1]) must correspond the
    //    index k= R n^2 + G n + B + 1 of the table cmap of size n^3 x 3
    //    and cmap(k,:) =  [R/(n-1) G/(n-1) B/(n-1)]
    //    As the max size of a cmap in scilab is 2^16-2, 
    //    n = 40 is the max possible (40^3 <= 2^16 - 2 < 41^3).   
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/puffin.png"));
    //    [X,map] = rgb2ind(S,8);
    //    imshow(X,map);
    //
    // See also
    //    ind2rgb
    //
    // Authors
    //    Ricardo Fabbri
    //    Tan Chin Luh
   
   function [A] = sip_index_true_cmap(Im,n)
        //
        // On input Im is a n1 x n2 x 3 hypermat describing a 
        // true color image  Im(i,j,:) giving the R-G-B of the 
        // pixel (i,j)
        //
        // On output A is a n1 x n2 matrix, A(i,j) given the 
        // index on the "true" color map of the (i,j) pixel. 
        // 
        // This new version doesn't use anymore hypermatrices
        // extraction for a gain in speed (as hypermatrix extraction 
        // is not currently too efficient in scilab); this result in
        // a less aesthetic code than before...  Also it uses
        // round in place of floor for a better color reduction
        // (from 0-255 levels to 0-39). 
        //
        // Author : Bruno Pincon
        //
        if argn(2)==1
            n = 40
        end
        dims = size(Im)

//        if type(Im(1))== 8 
//            v = (uint32(Im("entries"))*(n-1))./255;
//            //v = uint8(v);
//        else
//            v = round(Im("entries")*(n-1))       
//        end
//
        v = round(double(Im)./255*(n-1));
        m = dims(1)*dims(2);
        A = v(1:m)*n^2 + v(m+1:2*m)*n + v(2*m+1:$) + 1;
        A = matrix(A,dims(1),dims(2));
    endfunction


    function cmap = sip_approx_true_cmap(n)
        //
        // There are n levels for each color channel intensity
        // (each intensity being given by an integer I between 0 and n-1)
        // To the "color" R,G,B (R,G,B in [0,n-1]) must correspond the
        // index k= R n^2 + G n + B + 1 of the table cmap of size n^3 x 3
        // and cmap(k,:) =  [R/(n-1) G/(n-1) B/(n-1)]
        //
        // As the max size of a cmap in scilab is 2^16-2, 
        // n = 40 is the max possible (40^3 <= 2^16 - 2 < 41^3).
        // 
        // This function returns this colormap.
        //
        // ORIGINAL AUTHOR 
        //	   Bruno Pincon <bruno.pincon@free.fr>
        //

        if argn(2)==0
            n = 40
        end
        nb_col = n^3
        temp = (0:nb_col-1)'
        cmap = zeros(nb_col,3)
        q = int(temp/n^2)
        cmap(:,1) = q/(n-1)
        q = modulo(int(temp/n),n)
        cmap(:,2) = q/(n-1)
        cmap(:,3) = modulo(temp,n)/(n-1)
    endfunction




    imout = sip_index_true_cmap(imin,n);
    map = sip_approx_true_cmap(n)


 

endfunction
