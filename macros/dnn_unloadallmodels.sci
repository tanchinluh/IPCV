//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2018  Tan Chin Luh
//=============================================================================
function dnn_unloadallmodels()
    // Unload all loaded DNN models from memory
    //
    // Syntax
    //    dnn_unloadallmodels()
    //
    // Parameters
    //
    // Description
    //    This function is used for unloading all loaded DNN models from the memory.
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
    if rhs ~= 0; error("Function expect no input arguments"); end    
   
   try 
        int_dnn_unloadall();
        disp('All DNN models have been unloaded, please clear the obj from the workspace manually.');
        //disp('DNN '+ net.name + ' has been unloaded, please clear the obj from the workspace manually.');
   catch
       error(lasterror);
   end
  
    
    
    
endfunction
