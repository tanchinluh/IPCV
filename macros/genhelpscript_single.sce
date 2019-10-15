//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
//
// Generate for Image Reading, Display and Exploration

//exec(SCI+'\modules\helptools\macros\help_from_comment.sci');
//exec(SCI+'\modules\helptools\macros\help_from_sci.sci');
current_path = pwd();
current_path = get_absolute_file_path("genhelpscript_single.sce");
path_macros = fullpath(current_path) + filesep();


//p1Help = fullpath(current_path + '/../help/en_US/Image Reading, Display and Exploration');
//help_from_sci(path_macros + 'imread.sci', p1Help);
//help_from_sci(path_macros + 'imshow.sci', p1Help);
//help_from_sci(path_macros + 'imwrite.sci', p1Help);
//help_from_comment(path_macros + 'imdisplay.sci', p1Help);
//help_from_comment(path_macros + 'imdestroy.sci', p1Help);
//help_from_comment(path_macros + 'imdestroyall.sci', p1Help);
//help_from_comment(path_macros + 'imcreatechecker.sci', p1Help);
//
////help_from_sci(path_macros + 'tifread.sci', p1Help);
//
// Generate for Image Types and Color Space Conversions
//p2Help = fullpath(current_path + '/../help/en_US/Image Types and Color Space Conversions');
//help_from_sci(path_macros + 'imgraythresh.sci', p2Help);
//help_from_sci(path_macros + 'rgb2hsv.sci', p2Help);
//help_from_sci(path_macros + 'hsv2rgb2.sci', p2Help);
//help_from_sci(path_macros + 'im2bw.sci', p2Help);
//help_from_sci(path_macros + 'im2double.sci', p2Help);
//help_from_sci(path_macros + 'im2int16.sci', p2Help);
//help_from_sci(path_macros + 'im2int32.sci', p2Help);
//help_from_sci(path_macros + 'im2int8.sci', p2Help);
//help_from_sci(path_macros + 'im2uint16.sci', p2Help);
//help_from_sci(path_macros + 'im2uint8.sci', p2Help);
//help_from_sci(path_macros + 'imnorm.sci', p2Help);
//help_from_sci(path_macros + 'mat2gray.sci', p2Help);
//help_from_sci(path_macros + 'rgb2lab.sci', p2Help);
//help_from_sci(path_macros + 'rgb2ind.sci', p2Help);
//help_from_sci(path_macros + 'rgb2gray.sci', p2Help)
//help_from_sci(path_macros + 'rgb2ycbcr.sci', p2Help)
//help_from_sci(path_macros + 'rgb2ntsc.sci', p2Help)
//help_from_sci(path_macros + 'ntsc2rgb.sci', p2Help)
//help_from_sci(path_macros + 'xs2im.sci', p2Help)
//help_from_sci(path_macros + 'ycbcr2rgb.sci', p2Help)
//help_from_sci(path_macros + 'ind2rgb.sci', p2Help)
//
//// Generate for Utilities and Interactive Tools
p3Help = fullpath(current_path + '/../help/en_US/Utilities and Interactive Tools');
//help_from_sci(path_macros + 'imroi.sci', p3Help);
//help_from_sci(path_macros + 'imselect.sci', p3Help);
//help_from_sci(path_macros + 'imrects.sci', p3Help);
//help_from_sci(path_macros + 'imdistline.sci', p3Help);
//help_from_sci(path_macros + 'imaddtext.sci', p3Help);
//help_from_sci(path_macros + 'im2movie.sci', p3Help);
//help_from_sci(path_macros + 'imlsusb.sci', p3Help);
//help_from_sci(path_macros + 'imcaminfo.sci', p3Help);
//help_from_sci(path_macros + 'imbreakset.sci', p3Help);
//help_from_sci(path_macros + 'imbreakunset.sci', p3Help);
//help_from_sci(path_macros + 'impixelval.sci', p3Help);
//help_from_sci(path_macros + 'rectangle.sci', p3Help);
help_from_sci(path_macros + 'imchoose.sci', p3Help);
//
//// Generate for Spatial Transformations
//p4Help = fullpath(current_path + '/../help/en_US/Spatial Transformations');
//help_from_sci(path_macros + 'imcrop.sci', p4Help);
//help_from_sci(path_macros + 'imcropm.sci', p4Help);
//help_from_sci(path_macros + 'imrotate.sci', p4Help);
//help_from_sci(path_macros + 'imresize.sci', p4Help);
//help_from_comment(path_macros + 'impyramid.sci', p4Help);
//
//// Generate for Image Registration and Image Fusion
//p4bHelp = fullpath(current_path + '/../help/en_US/Image Registration and Image Fusion');
//help_from_sci(path_macros + 'warpmatselect.sci', p4bHelp);
//help_from_sci(path_macros + 'imgettransform.sci', p4bHelp);
//help_from_sci(path_macros + 'imtransform.sci', p4bHelp);
////help_from_sci(path_macros + 'imfeaturematch.sci', p4bHelp);
//help_from_sci(path_macros + 'imphasecorr.sci', p4bHelp);
//help_from_sci(path_macros + 'imfuse.sci', p4bHelp);
//
//// Generate for Image Analysis and Statistics
//p5Help = fullpath(current_path + '/../help/en_US/Image Analysis and Statistics');
//help_from_sci(path_macros + 'corr2.sci', p5Help);
//help_from_sci(path_macros + 'edge.sci', p5Help);
//help_from_sci(path_macros + 'impixel.sci', p5Help);
//help_from_sci(path_macros + 'improfile.sci', p5Help);
//help_from_sci(path_macros + 'imhist.sci', p5Help);
//help_from_sci(path_macros + 'mean2.sci', p5Help);
//help_from_sci(path_macros + 'stdev2.sci', p5Help);
//help_from_sci(path_macros + 'std2.sci', p5Help);
//
//// Generate for Image Arithmetic
//p6Help = fullpath(current_path + '/../help/en_US/Image Arithmetic');
//help_from_sci(path_macros + 'imabsdiff.sci', p6Help);
//help_from_sci(path_macros + 'imadd.sci', p6Help);
//help_from_sci(path_macros + 'imcomplement.sci', p6Help);
//help_from_sci(path_macros + 'imdivide.sci', p6Help);
//help_from_sci(path_macros + 'imlincomb.sci', p6Help);
//help_from_sci(path_macros + 'immultiply.sci', p6Help);
//help_from_sci(path_macros + 'imsubtract.sci', p6Help);
//
//// Generate for Image Enhancement and Restoration 
//p7Help = fullpath(current_path + '/../help/en_US/Image Enhancement and Restoration');
//help_from_sci(path_macros + 'imhistequal.sci', p7Help);
//help_from_sci(path_macros + 'imadjust.sci', p7Help);
//help_from_sci(path_macros + 'imwiener2.sci', p7Help);
//help_from_sci(path_macros + 'imdeconvl2.sci', p7Help);
//help_from_sci(path_macros + 'imdeconvsobolev.sci', p7Help);
//help_from_sci(path_macros + 'imdeconvwiener.sci', p7Help);
//help_from_sci(path_macros + 'immedian.sci', p7Help);
//help_from_sci(path_macros + 'iminpaint.sci', p7Help);
//help_from_sci(path_macros + 'imdecorrstretch.sci', p7Help);
//help_from_sci(path_macros + 'imnoise.sci', p7Help);
//
//// Generate for Image Linear Filtering
//p8Help = fullpath(current_path + '/../help/en_US/Image Linear Filtering');
//help_from_sci(path_macros + 'fspecial.sci', p8Help);
//help_from_sci(path_macros + 'imfilter.sci', p8Help);
//help_from_comment(path_macros + 'filter2.sci', p8Help);
//// Generate for Filter Design and Visualization
//p9Help = fullpath(current_path + '/../help/en_US/Filter Design and Visualization');
//help_from_sci(path_macros + 'fft2pad.sci', p9Help);
//help_from_sci(path_macros + 'immesh.sci', p9Help);
//help_from_sci(path_macros + 'imsurf.sci', p9Help);
//help_from_sci(path_macros + 'imsmoothsurf.sci', p9Help);
//help_from_sci(path_macros + 'mkfftfilter.sci', p9Help);
//
//// Generate for Image Transforms
p10Help = fullpath(current_path + '/../help/en_US/Image Transforms');
//help_from_sci(path_macros + 'imdct.sci', p10Help); 
help_from_sci(path_macros + 'imidct.sci', p10Help);
//help_from_sci(path_macros + 'imradon.sci', p10Help);
//help_from_sci(path_macros + 'imhough.sci', p10Help);
//help_from_sci(path_macros + 'imhoughc.sci', p10Help);
//help_from_sci(path_macros + 'imlogpolar.sci', p10Help);
//
//// Generate for Morphological Operations
//p11Help = fullpath(current_path + '/../help/en_US/Morphological Operations');
//help_from_sci(path_macros + 'imgradient.sci', p11Help);
//help_from_sci(path_macros + 'imblackhat.sci', p11Help);
//help_from_sci(path_macros + 'imclose.sci', p11Help);
//help_from_sci(path_macros + 'imdilate.sci', p11Help);
//help_from_sci(path_macros + 'imerode.sci', p11Help);
//help_from_sci(path_macros + 'imhitmiss.sci', p11Help);
//help_from_sci(path_macros + 'imopen.sci', p11Help);
//help_from_sci(path_macros + 'imtophat.sci', p11Help);
//help_from_sci(path_macros + 'imlabel.sci', p11Help);
//help_from_sci(path_macros + 'imblobprop.sci', p11Help);
//help_from_sci(path_macros + 'bwborder.sci', p11Help);
//help_from_sci(path_macros + 'imcreatese.sci', p11Help);
//help_from_sci(path_macros + 'imfill.sci', p11Help);
////
//// Generate for ROI Processing
//p12Help = fullpath(current_path + '/../help/en_US/ROI Processing');


//help_from_sci(path_macros + 'imroifill.sci', p12Help);
//help_from_sci(path_macros + 'imroifilt.sci', p12Help);
////
//// Generate for Image Block Processing
//p13Help = fullpath(current_path + '/../help/en_US/Image Block Processing');
//help_from_sci(path_macros + 'im2col.sci', p13Help);
//help_from_sci(path_macros + 'imblockproc.sci', p13Help);
//help_from_sci(path_macros + 'imblockslide.sci', p13Help);
//help_from_sci(path_macros + 'imcolproc.sci', p13Help);
//
//// Generate for Video Handling
p14Help = fullpath(current_path + '/../help/en_US/Video Handling');
//help_from_sci(path_macros + 'aviclose.sci', p14Help);
//help_from_sci(path_macros + 'avicloseall.sci', p14Help);
help_from_sci(path_macros + 'avireadframe.sci', p14Help);
//help_from_sci(path_macros + 'aviopen.sci', p14Help);
//help_from_sci(path_macros + 'avifile.sci', p14Help);
//help_from_sci(path_macros + 'aviaddframe.sci', p14Help);
//help_from_sci(path_macros + 'addframe.sci', p14Help);
//help_from_sci(path_macros + 'avilistopened.sci', p14Help);
help_from_sci(path_macros + 'aviinfo.sci', p14Help);
//
//// Generate for Camera Handling
//p14bHelp = fullpath(current_path + '/../help/en_US/Camera Handling');
//help_from_sci(path_macros + 'camopen.sci', p14bHelp);
//help_from_sci(path_macros + 'camread.sci', p14bHelp);
//help_from_sci(path_macros + 'camclose.sci', p14bHelp);
//help_from_sci(path_macros + 'camcloseall.sci', p14bHelp);
//help_from_sci(path_macros + 'camlistopened.sci', p14bHelp);
//
//// Generate for Object Detection
//p15Help = fullpath(current_path + '/../help/en_US/Object Detection');
//help_from_sci(path_macros + 'imdetectobjects.sci', p15Help);
//
//// Generate for Analytic Geometry
//p16Help = fullpath(current_path + '/../help/en_US/Analytic Geometry');
////help_from_sci(path_macros + 'delaunay.sci', p16Help);
//help_from_sci(path_macros + 'plot3dot.sci', p16Help);
////help_from_sci(path_macros + 'grid2Ddata.sci', p16Help);


//// Feature Detection, Description and Matching
p17Help = fullpath(current_path + '/../help/en_US/Feature Detection, Description and Matching');
//help_from_sci(path_macros + 'imdetect_FAST.sci', p17Help);
//help_from_sci(path_macros + 'imdetect_MSER.sci', p17Help);
//help_from_sci(path_macros + 'imdetect_ORB.sci', p17Help);
//help_from_sci(path_macros + 'imdetect_BRISK.sci', p17Help);
//help_from_sci(path_macros + 'imdetect_STAR.sci', p17Help);
//help_from_sci(path_macros + 'imdetect_SURF.sci', p17Help);
//help_from_sci(path_macros + 'imdetect_SIFT.sci', p17Help);
//help_from_sci(path_macros + 'imdetect_HARRIS.sci', p17Help);
//help_from_sci(path_macros + 'imdetect_GFTT.sci', p17Help);
//help_from_sci(path_macros + 'imdetect_DENSE.sci', p17Help);
//help_from_sci(path_macros + 'imextract_DescriptorSIFT.sci', p17Help);
//help_from_sci(path_macros + 'imextract_DescriptorSURF.sci', p17Help);
//help_from_sci(path_macros + 'imextract_DescriptorBRIEF.sci', p17Help);
//help_from_sci(path_macros + 'imextract_DescriptorBRISK.sci', p17Help);
//help_from_sci(path_macros + 'imextract_DescriptorORB.sci', p17Help);
//help_from_sci(path_macros + 'imextract_DescriptorFREAK.sci', p17Help);
//help_from_sci(path_macros + 'immatch_BruteForce.sci', p17Help);
//help_from_sci(path_macros + 'imdrawmatches.sci', p17Help);
//help_from_sci(path_macros + 'imbestmatches.sci', p17Help);
help_from_sci(path_macros + 'plotfeature.sci', p17Help);
////help_from_sci(path_macros + 'grid2Ddata.sci', p16Help);

//// Generate for Image Stitching
//p18Help = fullpath(current_path + '/../help/en_US/Image Stitching');
//help_from_sci(path_macros + 'imstitchimage.sci', p18Help);
//help_from_sci(path_macros + 'imstitchimage_params.sci', p18Help);


//// Generate for Super Resolution
//p19Help = fullpath(current_path + '/../help/en_US/Super Resolution');
//help_from_sci(path_macros + 'imsuperres.sci', p19Help);
//help_from_sci(path_macros + 'imsuperres_params.sci', p19Help);

////Structural Analysis and Shape Descriptors
//p20Help = fullpath(current_path + '/../help/en_US/Structural Analysis and Shape Descriptors');
//help_from_sci(path_macros + 'imfindcontours.sci', p20Help);
//help_from_sci(path_macros + 'imdrawcontours.sci', p20Help);
//help_from_sci(path_macros + 'imconvexHull.sci', p20Help);

////Deep Learning 
p21Help = fullpath(current_path + '/../help/en_US/Deep Learning');
help_from_sci(path_macros + 'dnn_getparam.sci', p21Help);
help_from_sci(path_macros + 'dnn_forward.sci', p21Help);
help_from_sci(path_macros + 'dnn_unloadallmodels.sci', p21Help);
help_from_sci(path_macros + 'dnn_unloadmodel.sci', p21Help);
help_from_sci(path_macros + 'dnn_list.sci', p21Help);
help_from_sci(path_macros + 'dnn_readmodel.sci', p21Help);
help_from_sci(path_macros + 'dnn_showfeature.sci', p21Help);
help_from_sci(path_macros + 'dnn_showparam.sci', p21Help);
help_from_sci(path_macros + 'dnn_showparamf2d.sci', p21Help);
help_from_sci(path_macros + 'dnn_showparamf3d.sci', p21Help);


//Deep Learning 
p22Help = fullpath(current_path + '/../help/en_US/Object Tracking');
help_from_sci(path_macros + 'imtrack_init.sci', p22Help);
help_from_sci(path_macros + 'imtrack_update.sci', p22Help);
help_from_sci(path_macros + 'imtrack_unloadall.sci', p22Help);

