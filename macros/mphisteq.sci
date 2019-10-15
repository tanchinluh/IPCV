// ===========================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================
// ToDo: Document
function aa = mphisteq(I)

[A B]=size(I);
H = imhist(I);
prob = H / sum(H);//pdf
L = prod(size(H));
new_prob = prob;


for k=5:L-4
    C = 0;
    for i=1:9
        add = prob(k-5+i);    //smooth histogram
        C = C + add;            
     end
    new_prob(k) = C / 9;
end

//------------------------------------------------------------------------
//break point detection process starts
sign = zeros(L,1);
for i=1:L-1
    delta = new_prob(i+1) - new_prob(i);
    if delta > 0
        sign(i+1) = 1;
    elseif delta < 0
        sign(i+1) = -1;
    else
        sign(i+1) = 0;
    end
end

//--------------------------------------------------------------------------
//sign changing process
// + - + change to + + + 
// and - + - change to - - - 
i = 2;
while i < L - 1,
    if sign(i)==1 & sign(i+1)==-1 & sign(i+2)==1
        sign(i+1) = 1;
        i = i + 3;
    elseif sign(i)==-1 & sign(i+1)==1 & sign(i+2)==-1   
        sign(i+1) = -1;
        i = i + 3;
    else
        i = i + 1;
    end
end

//---------------------------------------------------------------------------
//modal detection - break point is defined by 4 -ve signs followed by 8 +ve 
//signs. Break point is the point that change from -ve sign to +ve sign
gray_peak = zeros(1,23);
gray_peak(1) = 1;
i = 1;
j = 2;
k = 1;
while i < L-10
    if sign(i)==-1 & sign(i+1)==-1 & sign(i+2)==-1 & sign(i+3)==-1 & sign(i+4)==1 & sign(i+5)==1 & sign(i+6)==1 & sign(i+7)==1 & sign(i+8)==1 & sign(i+9)==1 & sign(i+10)==1 & sign(i+11)==1
        gray_peak(j) = i + 4;
        i = i + 12;
        j = j + 1;
        k = k + 1;
    else
        i = i + 1;
    end
end
// gray_peak(j) = L + 1;
// gray_peak(find(gray_peak==0))=L+1
gray_peak(j:$) = L + 1;

cum = zeros(L,1);
concatenate = [];
if k~=1
    for m=1:k
        cum = cumsum(new_prob(gray_peak(m):gray_peak(m+1)-1)) / sum(new_prob(gray_peak(m):gray_peak(m+1)-1));
        //concatenate = vertcat(concatenate,cum);
        concatenate = [concatenate;cum];
    end
end
  
// concatenate  

//---------------------------------------------------------------------------------------------------
if k~=1
for i=1:L
       X = (i >= gray_peak);//detect gray value falls under which modal
       Nth = max(find(X==1));
       newgray(i) = uint8( gray_peak(Nth)-1 + (gray_peak(Nth+1)-gray_peak(Nth))*concatenate(i) );//HE
end


for i=1:A
    for j=1:B
        temp(i,j)= double(I(i,j))+1;//add one to each pixel to prevent zero index
        aa(i,j) = newgray(temp(i,j));   //apply CDF to the image data
    end
end
else 
    aa = histeq(I);
end
endfunction
