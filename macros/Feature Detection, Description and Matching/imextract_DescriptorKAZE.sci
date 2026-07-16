function descriptors = imextract_DescriptorKAZE(image, features)
    // Extract KAZE descriptors for an IPCV feature object.
    if argn(2)<>2 then error("imextract_DescriptorKAZE: image and features are required."); end
    if typeof(image)<>"uint8" then image=im2uint8(image); end
    descriptors=int_imextract_DescriptorKAZE(image,[features.x;features.y;features.size;features.angle;features.response;features.octave;features.class_id]);
endfunction
