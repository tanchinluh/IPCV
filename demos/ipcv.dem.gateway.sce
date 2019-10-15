//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function subdemolist = demo_gateway()
  demopath = get_absolute_file_path("ipcv.dem.gateway.sce");

  subdemolist = ["Image Filter in Spatial Domain", "demo_filter1.sci"; ..
                 "Frequency Domain Filter Design","demo_filter2.sci"; ..
                 "Image Analysis and Stats","demo_imagestats.sci"; ..
                 "Image Transformation", "demo_transform.sci"; ..
                 "Image Arithmetic", "demo_arithmetic.sci"; ..
                 "WebCam Demo", "demo_webcam.sci"];

  subdemolist(:,2) = demopath + subdemolist(:,2);
endfunction
// ====================================================================
subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
// ====================================================================
