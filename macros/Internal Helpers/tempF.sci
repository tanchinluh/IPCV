function fY = tempF(Y)
//    if Y>0.008856 then
//        fY = Y.^(1/3);
//    elseif Y<=0.008856
//        fY = 7.787.*Y + 16/116;
//    end
fY = real(Y.^(1/3));
i = (Y < 0.008856);
fY(i) = Y(i)*(841/108) + (4/29);
endfunction
