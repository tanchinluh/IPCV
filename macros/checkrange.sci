function out = checkrange(num, in,low,hi)
    
    
    if isscalar(in)
        if in>=low & in<=hi then
            out = 0;
        else
            //out = -1;
            error('Argument ' + string(num) + ' : Value must be bewteen ' + string(low) + ' and ' + string(hi));   
        end
    else
        error('Input must be a scalar.');
    end
    
    
    
    
endfunction
