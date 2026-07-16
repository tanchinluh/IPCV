function out = imbitwise(image1, image2, operation)
    // Apply uint8 bitwise AND, OR, XOR, or NOT operations.
    rhs=argn(2); if rhs < 2 | rhs > 3 then error("imbitwise: invalid arguments."); end
    if rhs == 2 then operation=image2; image2=[]; end
    key=convstr(operation,"l"); a=uint8(image1); if key<>"not" then if isempty(image2) | or(size(a)<>size(image2)) then error("imbitwise: image sizes must match."); end; b=uint8(image2); end
    select key
    case "and" then out=bitand(a,b);
    case "or" then out=bitor(a,b);
    case "xor" then out=bitxor(a,b);
    case "not" then out=bitcmp(a,8);
    else error("imbitwise: operation must be and, or, xor, or not.");
    end
endfunction
