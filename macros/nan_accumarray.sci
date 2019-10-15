//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function A = nan_accumarray (subs, val, sz)
    // Create an array by accumulating the elements of a vector into the positions defined by their subscripts.
    //
    // Syntax
    //    A = accumarray (subs, vals, sz)
    //
    // Parameters
    //    subs : 
    //    val : 
    //    sz : 
    //    A : 
    //
    // Description
    //     Create an array by accumulating the elements of a vector into the
    //     positions defined by their subscripts.  The subscripts are defined by
    //     the rows of the matrix subs and the values by vals.  Each row
    //     of @var{subs} corresponds to one of the values in vals.
    //     The size of the matrix will be determined by the subscripts themselves.
    //     However, if sz is defined it determines the matrix size.  The length
    //     of sz must correspond to the number of columns in subs.
    //
    // Examples
    //
    // See also
    //
    //
    // Bibliography
    //    1. Atoms nan toolbox



    [nargout,nargin]=argn(0);
    if (nargin < 2 )
        error("at least two parameters necassery!");
    end
    if nargin<3
        sz=[];
    end

    ncol = size (subs,2);


    // Linearize subscripts.
    if (ncol > 1)
        if (isempty (sz))

            sz = mtlb_max (subs, [], 1);

        elseif (ncol ~= max(size (sz)))
            error ("accumarray: dimensions mismatch")
        end

        // Convert multidimensional subscripts.

        subs = sub2ind (sz, subs); // creates index cache
    elseif (~ isempty (sz) & max(size (sz)) < 2)
        error("accumarray: needs at least 2 dimensions");
    end


    // Some built-in reductions handled efficiently.


    // The general case. Reduce values. 
    n = size (subs,1);
    if  sum(size(val))==2
        val = val(ones (1, n), 1);
    else
        val = val(:);
    end

    // Sort indices.
    [subs, idx] = mtlb_sort (subs);
    // Identify runs.
    jdx = find (subs(1:n-1) ~= subs(2:n));
    jdx = [jdx(:); n];
    val_ind=diff ([0; jdx]);val_tmp=val(idx);val=zeros(length(val_ind),1);
    for k=1:length(val_ind)
        val(k)=sum(val_tmp(sum(val_ind(1:k-1))+1:sum(val_ind(1:k))));
    end

    subs = subs(jdx);

    // Construct matrix of fillvals.


    A = mtlb_zeros (sz);


    // Set the reduced values.
    for k=1:length(val)
        A(subs(k)) = val(k);
    end



endfunction

