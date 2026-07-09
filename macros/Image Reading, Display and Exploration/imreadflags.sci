function flags = imreadflags()
    // Return common OpenCV image read flag values.
    //
    // Syntax
    //    flags = imreadflags()
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 0 then
        error("imreadflags: Wrong number of input arguments.");
    end

    flags.unchanged = -1;
    flags.grayscale = 0;
    flags.color = 1;
    flags.anydepth = 2;
    flags.anycolor = 4;
    flags.load_gdal = 8;
    flags.reduced_grayscale_2 = 16;
    flags.reduced_color_2 = 17;
    flags.reduced_grayscale_4 = 32;
    flags.reduced_color_4 = 33;
    flags.reduced_grayscale_8 = 64;
    flags.reduced_color_8 = 65;
    flags.ignore_orientation = 128;
endfunction
