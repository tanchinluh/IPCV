function out = imbwperim3(volume, connectivity)
    // Extract exposed surface voxels from a 3D binary volume.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imbwperim3: invalid arguments."); end
    if size(size(volume), "*") <> 3 then error("imbwperim3: a 3D volume is required."); end
    if rhs < 2 then connectivity = 6; end
    if connectivity <> 6 & connectivity <> 18 & connectivity <> 26 then
        error("imbwperim3: connectivity must be 6, 18, or 26.");
    end
    if typeof(volume) == "boolean" then mask = volume; else mask = volume <> 0; end
    out = int_imbwperim3(mask, connectivity);
endfunction