//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2018  Tan Chin Luh
//=============================================================================
function ret = dnn_list()
    // List all loaded DNN models in memory
    //
    // Syntax
    //    dnn_list()
    //
    // Parameters
    //
    // Description
    //    This function is used for list all loaded DNN models in the memory.
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

//    try 
        
        ret = int_dnn_list();

        var_list = who_user(%f);


        opened_net = [];
        num = 1;
        for cnt1 = [ret']
            for cnt2 = 1:size(var_list,1)
               
                if type(evstr(var_list(cnt2)))==17
                    if isfield(evstr(var_list(cnt2)),'ptr')
                        temp_net_ptr = getfield('ptr',evstr(var_list(cnt2)));
                        if temp_net_ptr == cnt1
                            opened_net(num) = var_list(cnt2);
                            disp(string(evstr(var_list(cnt2)+'.ptr'))+'. '+ var_list(cnt2) + ': ' + evstr(var_list(cnt2)+'.name'))
                            num = num + 1;
                        end
                    end
                end
            end   
        end

        //disp('DNN '+ net.name + ' has been unloaded, please clear the obj from the workspace manually.');
//    catch
//        error(lasterror);
//    end




endfunction
