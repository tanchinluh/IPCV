//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
//=============================================================================
function borderValue = ipcv_morphology_border_type(borderType)
    if type(borderType) == 10 then
        key = convstr(borderType, "l");
        select key
        case "constant" then
            borderValue = 0;
        case "replicate" then
            borderValue = 1;
        case "reflect" then
            borderValue = 2;
        case "reflect101" then
            borderValue = 4;
        case "reflect_101" then
            borderValue = 4;
        case "default" then
            borderValue = 4;
        case "isolated" then
            borderValue = 16;
        else
            error("Unsupported border type. Use ''constant'', ''replicate'', ''reflect'', ''reflect101'', ''default'', or ''isolated''.");
        end
    else
        borderValue = round(borderType);
    end
endfunction
