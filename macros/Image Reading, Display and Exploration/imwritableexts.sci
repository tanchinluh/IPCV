function extensions = imwritableexts()
    // List image file extensions writable by the bundled OpenCV build.
    //
    // Syntax
    //    extensions = imwritableexts()
    //
    // Parameters
    //    extensions : Column vector of supported file extensions.
    //
    // Description
    //    imwritableexts checks common image writer extensions using imwritable.
    //
    // Examples
    //    extensions = imwritableexts();
    //
    // See also
    //    imwritable
    //    imwrite
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 0 then
        error("imwritableexts: Wrong number of input arguments.");
    end

    candidates = [".bmp"; ".dib"; ".jpeg"; ".jpg"; ".jpe"; ".jp2"; ".png"; ".webp"; ".pbm"; ".pgm"; ".ppm"; ".pxm"; ".pnm"; ".sr"; ".ras"; ".tiff"; ".tif"; ".exr"; ".hdr"; ".pic"];
    extensions = emptystr(0, 1);
    for i = 1:size(candidates, "*")
        if imwritable(candidates(i)) then
            extensions($ + 1, 1) = candidates(i);
        end
    end
endfunction
