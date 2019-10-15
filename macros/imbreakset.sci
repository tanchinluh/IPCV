//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function imbreakset()
    // Set the break event with Scilab figure
    //
    // Syntax
    //    imbreakset()
    //
    // Parameters
    //
    // Description
    //    This function set the event handle for a figure and listen to the "Esc" key. The global variable "breakloop" is set to true if Esc key detected and break from the loop prematured or break from the infinite loop.
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
    //  imbreakunset();
    //
    // See also
    //    imlsusb
    //
    // Authors
    //     Tan Chin Luh
    //    
global breakloop;
breakloop = %f;
seteventhandler('imbreak_event');

endfunction
