function descriptors = imextract_DescriptorAKAZE(image, features)
    // Extract AKAZE descriptors for an IPCV feature object.
    if argn(2)<>2 then error("imextract_DescriptorAKAZE: image and features are required."); end
    if typeof(image)<>"uint8" then image=im2uint8(image); end
    descriptors=int_imextract_DescriptorAKAZE(image,[features.x;features.y;features.size;features.angle;features.response;features.octave;features.class_id]);
endfunction
