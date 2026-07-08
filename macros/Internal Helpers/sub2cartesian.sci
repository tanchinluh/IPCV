function [cart_x,cart_y] = sub2cartesian(dim, sub_r,sub_c)
    
    cart_x = sub_c;
    cart_y = dim(1) - sub_r;
    
endfunction
