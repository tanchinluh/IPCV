function IPCV_linux(root_tlbx,OPENCV_LIBS)
    // Try to use included precompiled OpenCV
    [a, b] = getversion();
    is_x64 = or(b == 'x64');



    //    image_codec_libs = ["png12"; "jpeg"];
    //    video_codec_libs = ["gstbase-0.10";"openh264";"gstreamer-0.10";"gstvideo-0.10";"gstapp-0.10";...
    //    "gstriff-0.10";"gstpbutils-0.10";"QtOpenGL";"QtTest";"gstinterfaces-0.10";"gstaudio-0.10";"gsttag-0.10"];
    //    ffmpeg_libs = ["avutil"; "swscale"; "avcodec"; "avformat"; "avfilter"; "avdevice"];
    //    OPENCV_LIBS = [image_codec_libs; video_codec_libs; ffmpeg_libs; OPENCV_LIBS];

    OPENCV_LIBS = "lib" + OPENCV_LIBS;

    if (is_x64) then
        opencvDynLibPath = fullpath(root_tlbx + "/thirdparty/opencv/" + getos() + "/x64/lib/");
    else
        opencvDynLibPath = fullpath(root_tlbx + "/thirdparty/opencv/" + getos() + "/x86/lib/");
    end
    pp = pwd();
    cd(opencvDynLibPath);
    while 1
        // 1. Using All Pre-Compiled Libraries
        bDepsLoaded = %t;
        p = [];
        for l = 1:size(OPENCV_LIBS, '*')
            //if execstr('p(' + string(l)+')=link(opencvDynLibPath + OPENCV_LIBS(l) + getdynlibext())', 'errcatch') <> 0 then
            if execstr('p(' + string(l)+')=link(OPENCV_LIBS(l) + getdynlibext())', 'errcatch') <> 0 then
		bDepsLoaded = %f;
                //disp("Unloading incomplete precompiled libraries...");
                ulink(p);
                break;
            end
        //    disp("Loading Pre-Compiled Lib : " + OPENCV_LIBS(l));
        end
        cd(pp);

        if bDepsLoaded == %t then
            disp("Pre-Compiled OpenCV lib used");
            break;
        end

        // 2. Using All System Libraries
        bDepsLoaded = %t;
        p = [];
        for l = 1:size(OPENCV_LIBS, '*')
            if execstr('p(' + string(l)+')=link(OPENCV_LIBS(l) + getdynlibext())', 'errcatch') <> 0 then
                bDepsLoaded = %f;
                //disp("Unloading incomplete system libraries...");
                ulink(p);
                break;
            end
            //disp("Loading System Lib : " + OPENCV_LIBS(l));

        end
        
        if bDepsLoaded == %t then
            disp("System OpenCV lib used");
            break;
        end

 	// 3. Using Mixed Libraries
        bDepsLoaded = %t;
        p = [];
        for l = 1:size(OPENCV_LIBS, '*')
	    if execstr('p(' + string(l)+')=link(opencvDynLibPath + OPENCV_LIBS(l) + getdynlibext())', 'errcatch') == 0 then
		//disp("Loading Pre-Compiled Lib : " + OPENCV_LIBS(l));
            elseif execstr('p(' + string(l)+')=link(OPENCV_LIBS(l) + getdynlibext())', 'errcatch') == 0 then
		//disp("Loading System Lib : " + OPENCV_LIBS(l));      
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
