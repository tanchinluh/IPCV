////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
////////////////////////////////////////////////////////////
function [G] = mat2gray(M, mm)
    //    Convert matrix to grayscale image
    //    
    //    Syntax
    //      G = mat2gray(M)
    //      G = mat2gray(M, [mmin, mmax])
    //    
    //    Parameters
    //       M : An matrix/image.
    //      [mmin, mmax] : [mmin, mmax] is the values in M that correspond to 0.0 and 1.0 in G . The elements in M which is lower than mmin will be converted to 0.0 , and greater than mmax will be converted to 1.0 .
    //      G : A double precision matrix/image which data value in the range [0,1].
    //    
    //    Description
    //      mat2gray(M,[mmin, mmax]) converts the matrix M to the double precision image. The output matrix contains values in the range [0.0, 1.0]. mmin and mmax are the values in M that correspond to 0.0 and 1.0 in the output image.
    //    
    //      When [mmin, mmax] is not specified, minimum and maximum of M are the values in M that correspond to 0.0 and 1.0 in the output image.
    //    
    //    Examples
    //      M = [0:10;0:10];
    //      I = mat2gray(M);
    //     
    //    See also
    //      rgb2gray
    //      im2bw
    //      im2uint8
    //      im2int8
    //      im2uint16
    //      im2int16
    //      im2int32
    //      im2double 
    //    
    //    Authors
    //      Shiqi Yu 
    //      Tan Chin Luh

    //check input
    if(size(size(M),2)>2)
        error("The input matrix M should be 2D matrix.");
    end

    //get rhs
    rhs=argn(2);
    //convert to double
    M = double(M);
    if (rhs==1)  then
        mmin = min(M);
        mmax = max(M);
    elseif (rhs==2)
        if(length(mm)<>2)
            error("The second argument should be a 2-element vector.");
        end
        mmin = mm(1);
        mmax = mm(2);
    end

    if (mmax < mmin)
        error("Parameter mmax should be greater than mmin");
    end 

    //map M from [mmin, mmax] to [0,1]
    if (mmax == mmin)
        G=zeros(size(M,1), size(M,2));
    else	       
        G = (M-mmin)/(mmax-mmin);
        G(G>1) = 1;
        G(G<0) = 0;
    end
endfunction
