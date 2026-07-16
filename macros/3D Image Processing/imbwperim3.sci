function out = imbwperim3(volume, connectivity)
    // Extract the exposed surface of a 3D binary volume.
    if argn(2) < 2 then connectivity = 6; end
    if size(size(volume), "*") <> 3 | (connectivity <> 6 & connectivity <> 26) then error("imbwperim3: invalid volume or connectivity."); end
    if typeof(volume) == "boolean" then mask = volume; else mask = volume <> 0; end
    rows=size(mask,1); cols=size(mask,2); slices=size(mask,3); out=zeros(rows,cols,slices)==1;
    for z=1:slices, for y=1:rows, for x=1:cols
        if ~mask(y,x,z) then continue; end
        exposed=%f; for dz=-1:1, for dy=-1:1, for dx=-1:1
            if dx==0 & dy==0 & dz==0 then continue; end
            if connectivity==6 & abs(dx)+abs(dy)+abs(dz)<>1 then continue; end
            yy=y+dy; xx=x+dx; zz=z+dz; if yy<1 | yy>rows | xx<1 | xx>cols | zz<1 | zz>slices | ~mask(yy,xx,zz) then exposed=%t; end
        end, end, end
        out(y,x,z)=exposed;
    end, end, end
endfunction
