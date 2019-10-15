function y = imfinfo(x)
    
    y = int_imfinfo(x);
    s = imread(x);
    if isbw(s)
        y(2) = 7;
    end
    imfinfo_print(y);
    
endfunction
