function params = imwriteparams()
    // Return common image write option values used by imwrite.
    //
    // Syntax
    //    params = imwriteparams()
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 0 then
        error("imwriteparams: Wrong number of input arguments.");
    end

    params.jpeg_quality_default = 95;
    params.jpeg_quality_min = 0;
    params.jpeg_quality_max = 100;
    params.png_compression_default = 1;
    params.png_compression_min = 0;
    params.png_compression_max = 9;
endfunction
