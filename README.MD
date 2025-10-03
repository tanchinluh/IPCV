# Image Processing and Computer Vision Toolbox (IPCV) - Version 4.5.0.1 (24-Feb-25)

Version 4.5.0.1 (24-Feb-25)
1. backport master branch fixes

Version 4.5 (21-Nov-23):
1. Change OpenCV Dependency to 4.5
2. base64toimg, imgtobase64 (20-Sep-2022) - experimental, requite USB E for image exchange

Version 4.1.2.2 (24-Jul-20):
1. Add imreadmulti
2. Add modes for imread

Version 4.1.2.1 (Jun-20):
1. Fix imrotate

Version 4.1-2 (15-Nov-19):
1. Change dnn_readmodel 4th options from torch to ONNX
Affected files : dnn_readmodel.sci, int_dnn_init.cpp
2. Update to OpenCV 4.1.2 engine
3. Changes of extern C to prepare for the sciTorch integration

Version 4.1 (17-Juy-19):
Update OPENCV to 4.1, subsequence versioning will follow the OPENCV versionn number
1. Updated imfinfo for Scilab 6.0.2
2. imroi and imselect to cater the zoom image
3. imread to be able to read alpha channels, and convert to binary when all values are ones and zeros.
4. Add tracking features
5. Better Deep Neural Network (DNN) support
6. Remove unsupported functions by CV4
7. RaspberryPi Ready. :)

Version 2.1 (10-Mar-19):
1799	Problem with function "imblobprop", Modified imlabel to use double, and imblobprop to return 0 when the sequence labels are skipped
1797	Proposed correct way of using function
1791	Issue related for previous version. 
1788	Invalid, user error
1790	Issue related of the way of using this function, propose 1823 as new feature

Enhancement
1. Upgrading OpenCV Library to 3.4.3
2. imshow now able to show image with alpha layer.
3. aviinfo added
4. avireadframe now allows to choose which frame to read
5. improve api to support multi layers images, such as png with alpha channels, and for future multilayers image support


Version 2.0 (11-July-18): 
Bugs fixed:
1739	Error function "edge" with method "canny"
1740	Some problem with the function: imaddtext - Won't fix
1736	Error function "imwrite"
1737	Error function "imlogpolar"
1686	imshow() example yields an error about mat2utfimg
1715	On your watch list. -error1000 while installing IPCV - Won't fix
1691	ind2rgb function is missing

Major Changes
1. Upgrading OpenCV Library to 3.4.1
2. Changes in Features detection and extraction, some functions removed due to changes in lib. More algo will be supported in coming release
3. Video and camera handling has been seperated.

New Features
1. Deep Learning Network Inference system support 

Version 1.2 (7-Dec-17): 
Bugs fixed:
1701 - Image Flood Fill (imfloodfill) function name
1702 - imwrite unable to save 16 bit tif
1703 - Imlabel to output more than 255 objects

New functions:
1. imconvexHull
2. imfindContours
3. imfill
4. imsuperres
5. imstitch

Version 1.1 (6-Apr-17): Add features and tests, improved start file

Version 1.0 (17-Mar-17): Initial Release 
