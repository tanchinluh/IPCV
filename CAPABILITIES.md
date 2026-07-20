# IPCV Capability Matrix

Last updated: 17-Jul-26

This matrix tracks user-facing capability by help category for the OpenCV 5.0.0
development line. It is a roadmap aid, not a claim of complete MATLAB API
compatibility.

Coordinate convention: image functions return image-space coordinates with the
origin at the upper-left corner. Scilab plotting uses a lower-left Cartesian
origin, so plotted overlays on `imshow()` output must convert coordinates with
`rect2cart()` or `sub2cart()`.

Status meanings:

- **Strong**: broad working coverage with current regression tests.
- **Functional**: useful coverage exists, with known breadth or consistency gaps.
- **Partial**: narrow or legacy coverage; Step 3 work is still needed.
- **Specialized**: intentionally focused on a smaller workflow.

| Help category | Status | Representative IPCV coverage | Priority gaps |
| --- | --- | --- | --- |
| Image Reading, Display and Exploration | **Strong** | Image I/O, multipage read, codec discovery, display | Metadata breadth, large-image workflows |
| Image Types and Color Space Conversions | **Strong** | Integer/double conversion, RGB/gray/HSV/Lab/YUV/YCbCr, `immat2gray`, `imlabel2rgb` | Alpha-channel policy, broader high-depth contracts |
| Image Arithmetic | **Strong** | Add, subtract, multiply, divide, absolute difference | Explicit saturation and mixed-class policy |
| Image Linear Filtering | **Strong** | Convolution, `imfilter2`, `imfspecial`, box, Gaussian, bilateral, median, order-statistic, local callback filtering | Border policy consistency across every filter |
| Morphological Operations | **Strong** | Structuring elements, `imbw...` morphology, thinning, fill, reconstruction, connected components, area opening, clear-border, area filtering, bottom-hat, flood fill | Additional grayscale morphology operators |
| Image Analysis and Statistics | **Functional** | Histograms, entropy, range, variance, local entropy, texture maps, histogram back-projection, `imedge`, measurement, region properties, local extrema, Sobel gradients, k-means, GrabCut, superpixels, quality metrics, thresholding/binarization, local range, stereo BM/SGBM | Regional statistics, robust multichannel statistics |
| Spatial Transformations | **Functional** | Resize, rotate, translate, flip, padding, remap, affine/perspective warp, pyramids | Spatial references and interpolation breadth |
| Image Transforms | **Functional** | DCT, distance transform, Radon, inverse Radon, Hough peaks and lines, log-polar, watershed | Fourier workflow consistency and inverse-transform coverage |
| Image Enhancement and Restoration | **Functional** | Histogram equalization, CLAHE, denoise, inpaint, deconvolution, contrast limits, local brightening, histogram matching, local contrast, noise tools, flat-field correction, diffusion, guided filtering, local normalization | Parameter consistency, quantitative restoration examples |
| Structural Analysis and Shape Descriptors | **Functional** | Contours, `imbwboundaries`, hulls, defects, area, arc length, bounding boxes, line and ellipse fitting | Region-property breadth and shape descriptors |
| Feature Detection, Description and Matching | **Strong** | FAST, GFTT, MSER, ORB, BRISK, SIFT, optional SURF/STAR, matching | Detector capability reporting, geometric verification |
| Image Registration and Image Fusion | **Functional** | Transform estimation, phase correlation, template matching, lens correction, rectification, fusion | Robust registration pipelines and quality diagnostics |
| ROI Processing | **Functional** | ROI filtering and filling, `impoly2mask`, `imbwselect` | Crop/measure/export workflows |
| Image Block Processing | **Functional** | Block and sliding-window processing | Parallel/batched execution and boundary policy |
| Filter Design and Visualization | **Specialized** | FFT filter helpers and surface visualization | Modern filter-design coverage |
| Image Stitching | **Specialized** | OpenCV panorama stitching | Diagnostics, masks, camera parameter exposure |
| Super Resolution | **Specialized** | Classical and DNN super-resolution | Model presets, tiling, memory-aware large images |
| Object Detection and Tracking | **Functional** | Cascade detection and OpenCV trackers | Modern detector integration and lifecycle diagnostics |
| Deep Learning | **Functional** | OpenCV DNN, common decoders, preprocessing, Zoo browser | Broader model contracts, batching, backend capability reporting |
| Video and Camera Handling | **Functional** | Read/write, seek, properties, camera capture | Cross-platform device tests, streaming pipelines |
| Utilities and Interactive Tools | **Functional** | Display overlays, ROI tools, annotations, version reporting | Unified annotation/measurement application workflow |
| Analytic Geometry | **Partial** | Limited plotting helpers | Deliberate scope decision or expanded geometry utilities |

## Step 3 Batches 1 To 13 And Native 3-D Foundation

- `imthreshold`: fixed, Otsu, and Triangle threshold modes with normalized levels.
- `imbinarize`: boolean-output fixed or automatic binarization.
- `imconnectedcomponents`: 4/8-connectivity labels, areas, 1-based boxes, and centroids.
- `imlabel`: compatibility API now delegates to the shared connected-components engine.
- `imbwareaopen`: removes foreground components below a measured area threshold.
- `imclearborder`: removes components touching the image border.
- `imarea`, `imcentroid`, `imboundingbox`, and `imperimeter`: measure binary image geometry.
- `imbwareafilt`: keeps components inside an inclusive area range.
- `imreconstruct`: performs binary geodesic reconstruction.
- `imregionalmax`, `imregionalmin`, `imextendedmax`, and `imextendedmin`: detect local extrema and contrast-filtered extrema.
- `imgradientxy` and `imgradientmagnitude`: expose Sobel derivatives and magnitude.

## Step 3 Batch 5

- Standardize 18 public image, filtering, statistics, binary, ROI, and boundary names around the `im...` convention.
- Add the executable `imfilter2` double-output filtering entry point and optional-noise behavior to `imwiener2`.
- Archive replaced non-`im` sources under `macros/old`; `buildmacros.sce` excludes that folder.

## Step 3 Batch 6

- Add spatial workflow helpers: `imflip`, `impadarray`, and `imtile`.
- Add MATLAB-style `imbothat` morphology naming over the OpenCV black-hat operation.
- Add OpenCV 5 segmentation APIs: `imsegkmeans`, `imgrabcut`, and `imsuperpixels`.
- Add `imregionprops` for label-region measurements, plus `imentropy`, `imrange`, and `imvar`.
- Add neighborhood and illumination tools: `imordfilt`, `imcolfilt`, and `imflatfield`.
- Add focused stability coverage and help examples with author and History sections.

## Step 3 Batch 7

- Add spatial and display workflow helpers: `imtranslate` and `imshowpair`.
- Add contrast, local-brightening, grayscale-region, quantization, and multilevel threshold APIs: `imstretchlim`, `imlocalbrighten`, `imgrayconnected`, `imquantize`, and `immultithresh`.
- Add binary topology and distance utilities: `imbweuler`, `imbwdistgeodesic`, and `imlabeln`.
- Add inverse Radon reconstruction and Hough post-processing: `imiradon`, `imhoughpeaks`, and `imhoughlines`.
- Add feature helpers `imcorner` and `imhog`, plus regularized and iterative restoration helpers `imdeconvblind` and `imdeconvreg`.
- Add one-command-per-line examples, author metadata, History sections, and a 17-function stability test. **Implemented; Windows stability coverage 29/29**

## Step 3 Batch 8

- Add enhancement helpers `imhistmatch`, `imlocalcontrast`, `imhmax`, and `imhmin`, plus documentation for `imnoise`.
- Add morphology and analysis helpers `imimposemin`, `immajority`, `imlocalentropy`, `imtexture`, `imroi2mask`, `immeanshift`, and `imbackproject`.
- Add matching, flow, lens-correction, and rectification entry points: `imtemplatematch`, `imopticalflow`, `imundistort`, and `imrectify`.
- Document existing `improfile` and `imphasecorr` workflows in the same batch. **Implemented; Windows stability coverage 30/30**

## Step 3 Batch 9

- Add `imfloodfill`, `imlocalrange`, and the stereo baselines `imstereobm` and `imstereosgbm`.
- Add color transfer, diffusion, guided filtering, and local normalization helpers:
  `imcolortransfer`, `imdiffusefilt`, `imguidedfilter`, and `imlocalnormalize`.
- Add registration and camera workflow baselines: `imseamlessclone`, `imregister`,
  and `imcalibratecamera`.
- Add geometric fitting helpers `imfitline` and `imellipsefit`.
- Add one-command-per-line examples, author metadata, History sections, and
  focused stability coverage. **Implemented; Windows stability coverage 30/30**
- Deliberately skip `im2gray` because `rgb2gray` and `immat2gray` already cover
  the conversion workflow; skip `imoverlay` because `imoverlaymask` exists;
  skip `imlabeloverlay` because `imlabel2rgb` plus overlay helpers exist;
  skip `imregcorr` because `imphasecorr` covers translation registration; and
  skip `imwarp` because `imtransform` covers the current warp workflow.

## Step 3 Batch 10

- Add robust intensity statistics: `imautocorr`, `imskewness`, `imkurtosis`,
  and `immad`.
- Add segmentation and structural response baselines: `imsegfcm`,
  `imsegactivecontour`, `imphasecong`, and `imridge`.
- Add 3D volume operations: `imresize3`, `imcrop3`, `imrotate3`,
  `imgradient3`, `imregionprops3`, and `imshow3d`.
- Add OpenCV 5 camera geometry gateways: `imsolvepnp`,
  `imestimatefundamental`, and `imtriangulate`.
- Skip `imfindcircles` because the existing OpenCV-backed `imhoughc`
  already provides circle detection.
- Add help examples, History metadata, and focused stability tests.
  **Implemented; Batch 10 stability test passes.**
- Native 3-D foundation: shared Scilab/C++ hypermatrix exchange, true 6/18/26-connected `imlabeln`, plateau-aware `imregionalmax3`, and accelerated volume filtering and binary morphology.
  **Implemented; native volume build and focused Windows tests pass.**
- Medical-volume I/O: `dicomread` supports uncompressed 8/16-bit MONOCHROME1/2 single- and multi-frame DICOM with core metadata, while `dicomshow` provides selectable slice grids and metadata modes.
  **Implemented; compressed transfer syntaxes and directory-series assembly remain future work.**
- Interactive volume display: `volshow` provides WebGL 2 ray-cast volume
  rendering, MIP, isosurface, orthogonal planes, scrollable 2-D layers, workspace export, clipping, transfer controls,
  physical voxel spacing, and PNG export inside a Scilab figure.
  **Implemented; GPU/browser validation remains platform-specific.**

## Step 3 Batch 4

- Filtering compatibility entry points: `imboxfilt`, `imgaussfilt`, `immedianfilt`, `imbilateralfilt`, `immedian`, and `imwiener2`. They preserve separate public names and may add MATLAB-oriented defaults or validation while sharing current backends.
- Enhancement compatibility entry points: `imnlmfilt` and `imadapthistequal`; separate compositions: `imsharpen` and `imlaplacian`.
- Gradient and local statistics: `imgradientdirection`, `imlocalmean`, and `imlocalstd`.
