function IPCV_windows(root_tlbx,OPENCV_LIBS)
    
    ARCH = getenv("PROCESSOR_ARCHITECTURE");
    opencvDynLibPath = fullpath(fullfile(root_tlbx,"thirdparty",getos(),ARCH,"lib"));

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
