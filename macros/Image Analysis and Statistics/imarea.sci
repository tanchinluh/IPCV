function area = imarea(image)
    // Count foreground pixels in a binary or numeric image.
    mask = ipcv_binary_mask(image, "imarea");
    area = sum(matrix(mask, -1, 1));
endfunction
