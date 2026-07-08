//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
//=============================================================================
function operationValue = ipcv_morphology_operation(operation)
    if type(operation) == 10 then
        key = convstr(operation, "l");
        select key
        case "erode" then
            operationValue = 0;
        case "dilate" then
            operationValue = 1;
        case "open" then
            operationValue = 2;
        case "close" then
            operationValue = 3;
        case "gradient" then
            operationValue = 4;
        case "tophat" then
            operationValue = 5;
        case "blackhat" then
            operationValue = 6;
        case "hitmiss" then
            operationValue = 7;
        case "hit-miss" then
            operationValue = 7;
        else
            error("Unsupported morphology operation.");
        end
    else
        operationValue = round(operation);
    end
endfunction
