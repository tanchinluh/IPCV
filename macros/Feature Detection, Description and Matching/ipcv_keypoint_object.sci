function fobj = ipcv_keypoint_object(raw, name)
    fobj.type=name; fobj.n=size(raw,2); fobj.x=raw(1,:); fobj.y=raw(2,:); fobj.size=raw(3,:); fobj.angle=raw(4,:); fobj.response=raw(5,:); fobj.octave=raw(6,:); fobj.class_id=raw(7,:);
endfunction
