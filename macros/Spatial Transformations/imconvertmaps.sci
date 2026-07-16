function [map1, map2] = imconvertmaps(mapx, mapy, scale)
    // Quantize remapping maps to a fixed-point pair for repeatable remap workflows.
    rhs=argn(2); if rhs < 2 | rhs > 3 then error("imconvertmaps: mapx and mapy are required."); end
    if or(size(mapx)<>size(mapy)) then error("imconvertmaps: map sizes must match."); end
    if rhs < 3 then scale=32; end
    if scale <= 0 then error("imconvertmaps: scale must be positive."); end
    map1=int32(round(double(mapx)*scale)); map2=int32(round(double(mapy)*scale));
endfunction
