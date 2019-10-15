function IPCV_windows(root_tlbx,OPENCV_LIBS)
    
    if win64() then
        opencvDllPath = root_tlbx + '\thirdparty\opencv\windows\x64\bin\';
    else
        opencvDllPath = root_tlbx + '\thirdparty\opencv\windows\x86\bin\';
    end

//    for l = 1:size(OPENCV_LIBS, '*')
//        if execstr('link(opencvDllPath + OPENCV_LIBS(l) + getdynlibext())', 'errcatch') <> 0 then
//            bDepsLoaded = %f;
//            
//            break;
//        end
//    end

    tmp = pwd();
    cd(opencvDllPath);

    for l = 1:size(OPENCV_LIBS, '*')
        if execstr('link(OPENCV_LIBS(l) + getdynlibext())', 'errcatch') <> 0 then
            bDepsLoaded = %f;
            disp(OPENCV_LIBS(l));
            break;
        end
    end
    
    cd(tmp);

endfunction
