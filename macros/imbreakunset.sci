//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function imbreakunset()
    // Unset the break event with Scilab figure
    //
    // Syntax
    //    imbreakunset()
    //
    // Parameters
    //
    // Description
    //    This function unset the event handle for a figure which has been set by imbreakset
    // 
    // Examples
    //  global breakloop;
    //  breakloop = %f;
    //  plot(0,0);
    //  imbreakset();
    //  for cnt = 1:10
    //     sleep(500);
    //     disp(cnt);
    //        if breakloop == %t
    //           disp('User Break');
    //          break
    //       end
    //  end
    //  imbreakset();
    //
    // See also
    //    imlsusb
    //
    // Authors
    //     Tan Chin Luh
    //    

seteventhandler('');
//clearglobal breakloop;
endfunction
