//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imadjust(imin,src,dest,gm)
    // Adjust the intensity of an image from given source histogram range to the destination histogram range
    //
    // Syntax
    //    imout = imadjust(imin,src,dest)
    //
    // Parameters
    //    imin : Source Image
    //    src : Source histogram range [min max]
    //    dest : destination histogram range [min max]
    //    imout : Destination Image
    //
    // Description
    //    This function use to adjust the intensity of an image using histogram 
    //    range method. The new image would be map into the new range with given
    //    min and max values
    //
    // Examples
    //    I = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    J = imadjust(I,[0 0.5],[0.5 1]);
    //    imshow(I)
    //    figure();imshow(J);
    //
    // See also
    //     imhistequal
    //
    // Authors
    //    Tan Chin Luh


    // Error Checking
    rhs=argn(2);
    dim = size(imin);
    rows = dim(1);
    cols = dim(2);

    if length(dim) == 3 then
        deps = dim(3);
    else
        deps = 1;
    end


    if rhs < 1; error("Expect at least 1 arguments, source image"); end
    tempIm = im2double(imin);
    if rhs < 2 | src == [];
        src=[];
        for cnt =1:deps 
            src = [src [min(tempIm(:,:,cnt));max(tempIm(:,:,cnt))]]; 
        end
        //pause
    end    
    if rhs < 3 | dest == []; 
        dest = [];
        for cnt =1:deps 
            dest = [dest [0;1]]; 
        end
    end
    if rhs < 4 | gm == []; gm = 1; end
    //if deps > 1; error("Matrix must be in 2D"); end
    //if length(src) ~= 2; error("Source histogram range must be in form of [m n], where m and n are within 0 to 1"); end
    //if length(dest) ~= 2; error("Destination histogram range must be in form of [m n], where m and n are within 0 to 1"); end

    // End of Error Checking
    if  deps == 1 then
        minX = src(1);
        maxX = src(2);
        minY = dest(1);
        maxY = dest(2);
        tempIm = (tempIm-minX)/(maxX-minX)*gm*(maxY-minY)+minY;
        tempIm(tempIm>maxY) = 1;
        tempIm(tempIm<minY) = 0;
    else
          tempR = tempIm(:,:,1);
          tempG = tempIm(:,:,2);
          tempB = tempIm(:,:,3);                    
          
          if length(src)==2
              src = repmat(src',1,3);
          end
          
          if length(dest)==2
              dest = repmat(dest',1,3);
          end
              
            minX = src(1,:);
            maxX = src(2,:);
            minY = dest(1,:);
            maxY = dest(2,:);
          
        //for cnt = 1:3
          tempR = (tempR-minX(1))/(maxX(1)-minX(1))*gm*(maxY(1)-minY(1))+minY(1);
          tempR(tempR>maxY(1)) = 1;
          tempR(tempR<minY(1)) = 0;
          tempG = (tempG-minX(2))/(maxX(2)-minX(2))*gm*(maxY(2)-minY(2))+minY(2);
          tempG(tempG>maxY(2)) = 1;
          tempG(tempG<minY(2)) = 0;
          tempB = (tempB-minX(3))/(maxX(3)-minX(3))*gm*(maxY(3)-minY(3))+minY(3);
          tempB(tempB>maxY(3)) = 1;
          tempB(tempB<minY(3)) = 0;
        //end
        tempIm(:,:,1) = tempR;
        tempIm(:,:,2) = tempG;
        tempIm(:,:,3) = tempB;
            

    end

    imout = tempIm;


    //    if typeof(imin(1)) == 'uint8' then
    //        imout = im2uint8(imout);
    //    elseif typeof(imin(1)) == 'int8' then
    //        imout = im2int8(imout);        
    //    elseif typeof(imin(1)) == 'uint16' then
    //        imout = im2uint16(imout);        
    //    elseif typeof(imin(1)) == 'int16' then
    //        imout = im2int16(imout);        
    //    end    


    if type(imin(1)) == 4 then
        imout = im2bw(imout);
    elseif type(imin(1)) == 8 then
        tt = typeof(imin(1));
        con_str = "imout = im2" + tt + "(imout)";
        execstr (con_str);
    end   

endfunction

