# IPCV OpenCV 5 and C++ Migration

OpenCV 5 migration branch
1. Target OpenCV/OpenCV contrib 5.0.0 for thirdparty builds
2. Update gateway linking and C++ compile flags for OpenCV 5

Migrated code
1. Core source library
   - Renamed source DLL target from `libipcv_decode` to `libipcv_core`
   - Split source C++ into category files under `src/cpp`
2. Image I/O
   - `imread` -> `src/cpp/ipcv_image_io.cpp`
   - `imreadmulti` -> `src/cpp/ipcv_image_io.cpp`
   - `imfinfo` -> `src/cpp/ipcv_image_io.cpp`
   - `imwrite` -> `src/cpp/ipcv_image_io.cpp`
3. Arithmetic
   - `imadd` -> `src/cpp/ipcv_arithmetic.cpp`
   - `imsubtract` -> `src/cpp/ipcv_arithmetic.cpp`
   - `immultiply` -> `src/cpp/ipcv_arithmetic.cpp`
   - `imdivide` -> `src/cpp/ipcv_arithmetic.cpp`
   - `imabsdiff` -> `src/cpp/ipcv_arithmetic.cpp`
4. Spatial transformations
   - `imresize` -> `src/cpp/ipcv_spatial_transform.cpp`
   - `impyramid` -> `src/cpp/ipcv_spatial_transform.cpp`
   - `imtransform(..., "affine", ...)` / `int_affinetransform` -> `src/cpp/ipcv_spatial_transform.cpp`
   - `imtransform(..., "perspective", ...)` / `int_perspectivetransform` -> `src/cpp/ipcv_spatial_transform.cpp`
   - `imgettransform(..., "affine", ...)` / `int_getaffinetransform` -> `src/cpp/ipcv_spatial_transform.cpp`
   - `imgettransform(..., "perspective", ...)` / `int_getperspectivetransform` -> `src/cpp/ipcv_spatial_transform.cpp`
   - `imrotate` -> `src/cpp/ipcv_spatial_transform.cpp`
5. Filtering
   - `filter2` -> `src/cpp/ipcv_filtering.cpp`
   - `imfilter` -> `src/cpp/ipcv_filtering.cpp`
6. Morphology
   - `imcreatese` -> `src/cpp/ipcv_morphology.cpp`
   - `imdilate` -> `src/cpp/ipcv_morphology.cpp`
   - `imerode` -> `src/cpp/ipcv_morphology.cpp`
   - `imopen` / `imclose` / `imgradient` / `imtophat` / `imblackhat` / `imhitmiss` -> `src/cpp/ipcv_morphology.cpp`
7. Color conversion
   - `rgb2gray` -> `src/cpp/ipcv_color.cpp`
   - `rgb2lab` -> `src/cpp/ipcv_color.cpp`
   - `bgr2lab` -> `src/cpp/ipcv_color.cpp`
   - `rgb2hsv` / `hsv2rgb2` / `rgb2ycbcr` / `ycbcr2rgb` -> `src/cpp/ipcv_color.cpp`
8. Edge/detail filtering
   - `edge(..., "sobel", ...)` / `int_sobel` -> `src/cpp/ipcv_edge_filter.cpp`
   - `edge(..., "canny", ...)` / `int_canny` -> `src/cpp/ipcv_edge_filter.cpp`
   - `immedian` -> `src/cpp/ipcv_edge_filter.cpp`
9. Binary analysis
   - `imdist` -> `src/cpp/ipcv_binary_analysis.cpp`
   - `imdistransf` -> `src/cpp/ipcv_binary_analysis.cpp`
   - `imfill` -> `src/cpp/ipcv_binary_analysis.cpp`
   - `imlabel` -> `src/cpp/ipcv_binary_analysis.cpp`
10. Enhancement and restoration
   - `imdct` -> `src/cpp/ipcv_enhancement.cpp`
   - `imidct` -> `src/cpp/ipcv_enhancement.cpp`
   - `imadapthistequal` -> `src/cpp/ipcv_enhancement.cpp`
   - `iminpaint` -> `src/cpp/ipcv_enhancement.cpp`
11. Image transforms and segmentation
   - `imradon` -> `src/cpp/ipcv_image_transform.cpp`
   - `imwatershed` -> `src/cpp/ipcv_segmentation.cpp`
12. Structural analysis
   - `imfindContours` -> `src/cpp/ipcv_structural_analysis.cpp`
   - `imconvexHull` -> `src/cpp/ipcv_structural_analysis.cpp`
   - `imconvexityDefects` -> `src/cpp/ipcv_structural_analysis.cpp`
   - `imboundingRect` -> `src/cpp/ipcv_structural_analysis.cpp`
13. Feature detection
   - `imdetect_FAST` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imdetect_BRISK` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imdetect_GFTT` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imdetect_MSER` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imdetect_ORB` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imdetect_SIFT` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imdetect_STAR` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imdetect_SURF` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imextract_DescriptorBRISK` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imextract_DescriptorORB` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imextract_DescriptorSIFT` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imextract_DescriptorSURF` -> `src/cpp/ipcv_feature_detection.cpp`
   - `immatch_BruteForce` -> `src/cpp/ipcv_feature_detection.cpp`
   - `immatch_Flann` -> `src/cpp/ipcv_feature_detection.cpp`
   - `imdrawmatches` -> `src/cpp/ipcv_feature_detection.cpp`
14. Hough and stitching
   - `int_imhough` -> `src/cpp/ipcv_hough.cpp`
   - `int_imhoughcircles` -> `src/cpp/ipcv_hough.cpp`
   - `imstitchimage` / `int_imstitchImage` -> `src/cpp/ipcv_stitching.cpp`
15. Removed obsolete gateways
   - Removed `sci_int_imfindContours2.cpp`
   - Removed `sci_int_imread2.cpp`
16. Gateway image exchange
   - Added `sci_gateway/cpp/ipcv_gateway_image.cpp`
   - Added `sci_gateway/cpp/ipcv_gateway_image.h`
17. Current unit tests
   - Current OpenCV 5 migration tests are in `tests/unit_tests`
   - Previous 4.5 unit tests are archived in `tests/unit_tests/4.5`
   - `tests/unit_tests/ipcv_image_io.tst`
   - `tests/unit_tests/ipcv_arithmetic.tst`
   - `tests/unit_tests/ipcv_spatial_transform.tst`
   - `tests/unit_tests/ipcv_filtering.tst`
   - `tests/unit_tests/ipcv_morphology.tst`
   - `tests/unit_tests/ipcv_color.tst`
   - `tests/unit_tests/ipcv_edge_filter.tst`
   - `tests/unit_tests/ipcv_binary_analysis.tst`
   - `tests/unit_tests/ipcv_enhancement.tst`
   - `tests/unit_tests/ipcv_image_transform.tst`
   - `tests/unit_tests/ipcv_structural_analysis.tst`
   - `tests/unit_tests/ipcv_feature_detection.tst`
   - `tests/unit_tests/ipcv_hough_stitching.tst`
   - `tests/unit_tests/ipcv_gateway_image_exchange.tst`

Version 4.5.0.2 (03-Oct-25)
1. Fix compilation warnings
2. Fix call of deprecated macros for Scilab 2026.0.0
3. Use Ninja for thirdparty OpenCV build

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
