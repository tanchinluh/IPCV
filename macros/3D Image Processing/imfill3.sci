function out = imfill3(volume, connectivity)
    // Fill enclosed background cavities in a 3D binary volume.
    if argn(2) < 2 then connectivity = 6; end
    if size(size(volume), "*") <> 3 | (connectivity <> 6 & connectivity <> 26) then error("imfill3: invalid volume or connectivity."); end
    if typeof(volume) == "boolean" then mask = volume; else mask = volume <> 0; end
    rows=size(mask,1); cols=size(mask,2); slices=size(mask,3); outside=zeros(rows,cols,slices)==1; queue=zeros(rows*cols*slices,3); head=1; tail=0;
    if connectivity==6 then directions=[-1 0 0;1 0 0;0 -1 0;0 1 0;0 0 -1;0 0 1]; else directions=[]; for dz=-1:1, for dy=-1:1, for dx=-1:1, if dx<>0 | dy<>0 | dz<>0 then directions($+1,:)=[dx dy dz]; end, end, end, end; end
    for z=1:slices, for y=1:rows, for x=1:cols
        if (x==1 | x==cols | y==1 | y==rows | z==1 | z==slices) & ~mask(y,x,z) & ~outside(y,x,z) then tail=tail+1; queue(tail,:)=[x y z]; outside(y,x,z)=%t; end
    end, end, end
    while head<=tail, point=queue(head,:); head=head+1; for d=1:size(directions,1), xx=point(1)+directions(d,1); yy=point(2)+directions(d,2); zz=point(3)+directions(d,3); if xx>=1 & xx<=cols & yy>=1 & yy<=rows & zz>=1 & zz<=slices & ~mask(yy,xx,zz) & ~outside(yy,xx,zz) then tail=tail+1; queue(tail,:)=[xx yy zz]; outside(yy,xx,zz)=%t; end, end, end
    out = mask | ~outside;
endfunction
