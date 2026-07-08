//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2018  Tan Chin Luh
//=============================================================================
function dnn_unloadmodel(net)
    // Unload DNN model from memory
    //
    // Syntax
    //    dnn_unloadmodel(net)
    //
    // Parameters
    //    net : DNN model object
    //
    // Description
    //    This function is used for unloading DNN model from the memory.
    //
    // Examples
    //
    // See also
    //     dnn_readmodel
    //     dnn_list
    //     dnn_unloadmodel
    //     dnn_unloadallmodels
    //     dnn_forward 
    //     dnn_getparam
    //
    // Authors
    //    CL Tan - Trity Technologies.
    //
    rhs=argn(2);
    // Error Checking 
    if rhs < 1; error("At least 1 argument expected, model object"); end    
   
   try 
        int_dnn_unload(net.ptr);
        //net = [];
        //net = resume(net);
        // Model is unloaded silently so scripts and tests remain deterministic.
   catch
       error(lasterror);
   end
  
    
    
    
endfunction
