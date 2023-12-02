function [image] = FourierT(I,k,display)
//This function is to perform fourier transform on the image with the desire factor value

I = im2double(I);
//divide the image into segment with size of 16*16 pixels for fft
// complement = 1-I2;
[M N]=size(I);
imgsizeX = floor(M/16)*16;
imgsizeY = floor(N/16)*16;
inter = zeros(imgsizeX,imgsizeY);

for i=1:16:imgsizeX
    for j=1:16:imgsizeY
        m = i+15;
        n = j+15;
        F1 = fft2(I(i:m,j:n));
        H = abs(F1).^k;
        block = abs(ifft(F1.*H));
        
        larv=max(block(:));
        if larv==0;
            larv=1;
        end;
        block= block./larv;
        inter(i:m,j:n) = block;
    end;
end;


I1 = inter;
I2 = imhistequal(I1);
image = I2;

if display==1 
    scf;imshow(I1);title('FFT enhancement');  
    scf;imshow(I2);title('FFT & histogram');
end

endfunction
