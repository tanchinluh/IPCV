////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function demo_filter2()

    re = messagebox("This demo will show you the frequency domain filter design with Scilab and IPCV", "Frequency Domain Filter Design", "info", ["Continue" "Stop"], "modal") 

    if re == 1 then

        str = "S = imread(fullpath(getIPCVpath() + ""/images/measure_gray.jpg""));";
        re = messagebox(["First, let''s load the image into Scilab";"Syntax : S = imread(""myimage.jpg"")";"For this example:";str], "Step 1", "info", ["Continue" "Stop"], "modal") 
        if re == 1
            execstr (str);
            imshow(S);title("Original Image");
            str2 = "h = mkfftfilter(S,""gauss"",0.3);";
            re = messagebox(["Now, create a low pass filter with follwing command";str2], "Step 2", "info", ["Continue" "Stop"], "modal") 
            if re == 1
                execstr (str2);
                clf;imsurf(h);title("Low pass filter, middle of plot shows the low frequencies components.");
                str3 = "S2 = fft2(im2double(S));";
                re = messagebox(["Take the FFT of the image";str3], "Step 3", "info", ["Continue" "Stop"], "modal") 
                if re == 1
                    execstr (str3);
                    clf;imsurf(log(S2),128);title("Image imformation on low frequencies - 4 corners");
                    str4 = "S3 = S2.*fftshift(h);";
                    re = messagebox(["Multiply the transform image with the filter.";str4], "Step 4", "info", ["Continue" "Stop"], "modal") 
                    if re == 1
                        execstr (str4);
                        clf;imsurf(log(S3),128);title("After applying low pass filter");
                        str5 = "S4 = real(ifft(S3));";
                        re = messagebox(["Take the inverse FFT.";str5], "Step 5", "info", ["Continue" "Stop"], "modal")
                        if re==1
                            execstr (str5);
                            clf;imshow(S4); title("Filtered Image");
                        else
                            messagebox("Thanks!", "End of demo", "info", "Done", "modal") ;
                        end
                    else
                        messagebox("Exit Demo Now", "User Interruption", "warning", "Done", "modal") ;
                    end
                else
                        messagebox("Exit Demo Now", "User Interruption", "warning", "Done", "modal") ;
                end
            else
                        messagebox("Exit Demo Now", "User Interruption", "warning", "Done", "modal") ;
            end
        else
                        messagebox("Exit Demo Now", "User Interruption", "warning", "Done", "modal") ;
        end
    else
                        messagebox("Exit Demo Now", "User Interruption", "warning", "Done", "modal") ;
    end

endfunction
// ====================================================================
demo_filter2();
clear demo_filter2;
// ====================================================================
