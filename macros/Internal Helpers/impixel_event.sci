//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [] = impixel_event(win, x, y, ibut)
    //realtime(0);
    if ibut == (-1000) then   return,end,
    [x,y] = xchange(x, y, 'i2f');


    f = gcf();
    S = f.children.children.data;
    [r,c] = size(S);
    y = r + 1 - y;
    if x>=1 & x<=c & y>=1 & y<=r    
        val = S(round(y),round(x), :);
        if  length(val) == 3
            if type(val(1)) == 1
                // xinfo(sprintf('RGB at (%i,%i) = [%f %f %f]', x, y,val(1),val(2),val(3)))
                f.info_message = sprintf('RGB at (%i,%i) = [%f %f %f]', x, y,val(1),val(2),val(3));
            else
                // xinfo(sprintf('RGB at (%i,%i) = [%i %i %i]', x, y,val(1),val(2),val(3)));
                f.info_message = sprintf('RGB at (%i,%i) = [%i %i %i]', x, y,val(1),val(2),val(3));
            end
        else
            if type(val(1)) == 1
                //xinfo(sprintf('Intensity at (%i,%i) = [%f]', x, y,val));    
                f.info_message = sprintf('Intensity at (%i,%i) = [%f]', x, y,val);
            else
                //xinfo(sprintf('Intensity at (%i,%i) = [%i]', x, y,val));
                f.info_message = sprintf('Intensity at (%i,%i) = [%i]', x, y,val);
            end
        end

    else
        if   ~exists('val') | length(val) == 3 
            //xinfo(sprintf('RGB at (%i,%i) = [%f %f %f]', x, y,%nan,%nan,%nan));
            f.info_message = ' '; //sprintf('RGB at (%i,%i) = [%f %f %f]', x, y,%nan,%nan,%nan);
        else
            //xinfo(sprintf('Intensity at (%i,%i) = [%f]', x, y,%nan));
            f.info_message =' '; //sprintf('Intensity at (%i,%i) = [%f]', x, y,%nan);
        end                

    end
  //realtime(1);
endfunction
