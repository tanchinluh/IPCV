function out = imbwareaopen3(volume, minSize, connectivity)
    // Remove small connected components from a 3D binary volume.
    rhs = argn(2); if rhs < 2 | rhs > 3 then error("imbwareaopen3: volume and minSize are required."); end
    if rhs < 3 then connectivity = 6; end
    if minSize < 1 | (connectivity <> 6 & connectivity <> 26) then error("imbwareaopen3: invalid minSize or connectivity."); end
    if typeof(volume) == "boolean" then mask = volume; else mask = volume <> 0; end
    rows = size(mask, 1); cols = size(mask, 2); slices = size(mask, 3); visited = zeros(rows, cols, slices) == 1; out = zeros(rows, cols, slices) == 1;
    if connectivity == 6 then directions = [-1 0 0; 1 0 0; 0 -1 0; 0 1 0; 0 0 -1; 0 0 1]; else directions = []; for dz=-1:1, for dy=-1:1, for dx=-1:1, if dx<>0 | dy<>0 | dz<>0 then directions($+1,:)=[dx dy dz]; end, end, end, end; end
    for z=1:slices, for y=1:rows, for x=1:cols
        if ~mask(y,x,z) | visited(y,x,z) then continue; end
        queue = zeros(rows*cols*slices, 3); head=1; tail=1; queue(1,:)=[x y z]; visited(y,x,z)=%t; component=[];
        while head <= tail
            point=queue(head,:); head=head+1; component($+1,:)=point;
            for d=1:size(directions,1), xx=point(1)+directions(d,1); yy=point(2)+directions(d,2); zz=point(3)+directions(d,3);
                if xx>=1 & xx<=cols & yy>=1 & yy<=rows & zz>=1 & zz<=slices & mask(yy,xx,zz) & ~visited(yy,xx,zz) then tail=tail+1; queue(tail,:)=[xx yy zz]; visited(yy,xx,zz)=%t; end
            end
        end
        if size(component,1) >= minSize then for q=1:size(component,1), out(component(q,2),component(q,1),component(q,3))=%t; end, end
    end, end, end
endfunction
