////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function demo_webcam()

    re = messagebox("Make sure you have a supported webcam connected", "WebCam Demo", "info", ["Continue" "Stop"], "modal") 

    if re ==1 then
        avicloseall();
        n = camopen(0);
        while(1)
            im = camread(n); //get a frame
            br = imdisplay(im,'Press anykey to exit');
            if br == -1
                break
            end            

        end

        avicloseall();
        imdestroyall

        messagebox("Thanks!", "End of demo", "info", "Done", "modal") ;        

    else
        messagebox("Exit Demo Now", "User Interruption", "warning", "Done", "modal") ;
    end

endfunction
// ====================================================================
demo_webcam();
clear demo_webcam;
// ====================================================================
