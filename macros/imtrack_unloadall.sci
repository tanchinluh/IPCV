//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2019  Tan Chin Luh
//=============================================================================
function imtrack_unloadall()
    // Unload All Trackers
    //
    // Syntax
    //    imtrack_unloadall()
    //
    // Parameters
    //
    // Description
    //    This function is used to unload all trackers
    // 
    // Examples
    //
    // See also
    //     imtrack_init
    //     imtrack_update
    //
    // Authors
    //    CL Tan - Bytecode (formally Trity Technologies)
    //

    rhs=argn(2);
    // Error Checking 
    if rhs ~= 0; error("Function expect no input arguments"); end    

    try 
        int_tracker_unloadall();
        disp('All trackers unloaded, please clear the pointer from the workspace manually.');
    catch
        error(lasterror);
    end

endfunction
