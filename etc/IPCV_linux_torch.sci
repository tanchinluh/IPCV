function IPCV_linux_torch(root_tlbx,TORCH_LIBS)
    // Try to use included precompiled OpenCV
    [a, b] = getversion();
    is_x64 = or(b == 'x64');


    TORCH_LIBS = "lib" + TORCH_LIBS;

    if (is_x64) then
        torchDynLibPath = fullpath(root_tlbx + "/thirdparty/libtorch/" + getos() + "/x64/lib/");
    else
        torchDynLibPath = fullpath(root_tlbx + "/thirdparty/libtorch/" + getos() + "/x86/lib/");
    end
    pp = pwd();
    cd(torchDynLibPath);
    while 1
        // 1. Using All Pre-Compiled Libraries
        bDepsLoaded = %t;
        p = [];
        for l = 1:size(TORCH_LIBS, '*')
            //if execstr('p(' + string(l)+')=link(torchDynLibPath + TORCH_LIBS(l) + getdynlibext())', 'errcatch') <> 0 then
            if execstr('p(' + string(l)+')=link(TORCH_LIBS(l) + getdynlibext())', 'errcatch') <> 0 then
		bDepsLoaded = %f;
                //disp("Unloading incomplete precompiled libraries...");
                ulink(p);
                break;
            end
            disp("Loading Pre-Compiled Lib : " + TORCH_LIBS(l));
        end
        cd(pp);

        if bDepsLoaded == %t then
            disp("Pre-Compiled OpenCV lib used");
            break;
        end

        // 2. Using All System Libraries
        bDepsLoaded = %t;
        p = [];
        for l = 1:size(TORCH_LIBS, '*')
            if execstr('p(' + string(l)+')=link(TORCH_LIBS(l) + getdynlibext())', 'errcatch') <> 0 then
                bDepsLoaded = %f;
                //disp("Unloading incomplete system libraries...");
                ulink(p);
                break;
            end
            //disp("Loading System Lib : " + TORCH_LIBS(l));

        end
        
        if bDepsLoaded == %t then
            disp("System OpenCV lib used");
            break;
        end

 	// 3. Using Mixed Libraries
        bDepsLoaded = %t;
        p = [];
        for l = 1:size(TORCH_LIBS, '*')
	    if execstr('p(' + string(l)+')=link(torchDynLibPath + TORCH_LIBS(l) + getdynlibext())', 'errcatch') == 0 then
		//disp("Loading Pre-Compiled Lib : " + TORCH_LIBS(l));
            elseif execstr('p(' + string(l)+')=link(TORCH_LIBS(l) + getdynlibext())', 'errcatch') == 0 then
		//disp("Loading System Lib : " + TORCH_LIBS(l));      
	    else          
		bDepsLoaded = %f;
                //disp("Unloading incomplete libraries...");
                ulink(p);
                break;
            end

        end
        
        if bDepsLoaded == %t then
            disp("Mixed OpenCV lib used");
            break;
        end

	break;

    end


    err = lasterror();
    if bDepsLoaded <> %t then
        disp('');		
        disp('------------------------------------------------------');
        disp("Error : Can not load some dependencies.");
        if grep(err,'libgomp')
            disp("Consider remove the libgomp libraries distributed with Scilab 6.0 at SCI/lib/third party/redist/");
            disp('');
            disp(" Visit ""http://scilabipcv.tritytech.com/2017/03/17/installation-of-scilab-ipcv/"" for more details");
	else
	    disp(err);	
        end
        disp('');	
        disp('------------------------------------------------------');
        return;
    end




endfunction
