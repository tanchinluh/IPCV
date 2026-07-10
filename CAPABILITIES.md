# IPCV Capability Matrix

Last updated: 10-Jul-26

This matrix tracks user-facing capability by help category for the OpenCV 5.0.0
development line. It is a roadmap aid, not a claim of complete MATLAB API
compatibility.

Status meanings:

- **Strong**: broad working coverage with current regression tests.
- **Functional**: useful coverage exists, with known breadth or consistency gaps.
- **Partial**: narrow or legacy coverage; Step 3 work is still needed.
- **Specialized**: intentionally focused on a smaller workflow.

| Help category | Status | Representative IPCV coverage | Priority gaps |
| --- | --- | --- | --- |
| Image Reading, Display and Exploration | **Strong** | Image I/O, multipage read, codec discovery, display | Metadata breadth, large-image workflows |
| Image Types and Color Space Conversions | **Strong** | Integer/double conversion, RGB/gray/HSV/Lab/YUV/YCbCr | Alpha-channel policy, broader high-depth contracts |
| Image Arithmetic | **Strong** | Add, subtract, multiply, divide, absolute difference | Explicit saturation and mixed-class policy |
| Image Linear Filtering | **Strong** | Convolution, box, Gaussian, bilateral, median, local mean/std, Laplacian, MATLAB-style filter names | Border policy consistency across every filter |
| Morphological Operations | **Strong** | Structuring elements, morphology, thinning, fill, reconstruction, connected components, area opening, clear-border, area filtering | Perimeter helpers |
| Image Analysis and Statistics | **Functional** | Histograms, measurement, local extrema, Sobel gradients, statistics, quality metrics, thresholding/binarization | Regional statistics, robust multichannel statistics |
| Spatial Transformations | **Functional** | Resize, rotate, remap, affine/perspective warp, pyramids | Translation/reflection convenience APIs, spatial references |
| Image Transforms | **Functional** | DCT, distance transform, Radon, Hough, log-polar, watershed | Fourier workflow consistency and inverse-transform coverage |
| Image Enhancement and Restoration | **Functional** | Histogram equalization, CLAHE, denoise, inpaint, deconvolution | Parameter consistency, quantitative restoration examples |
| Structural Analysis and Shape Descriptors | **Functional** | Contours, hulls, defects, area, arc length, bounding boxes | Region-property breadth and shape descriptors |
| Feature Detection, Description and Matching | **Strong** | FAST, GFTT, MSER, ORB, BRISK, SIFT, optional SURF/STAR, matching | Detector capability reporting, geometric verification |
| Image Registration and Image Fusion | **Functional** | Transform estimation, phase correlation, fusion | Robust registration pipelines and quality diagnostics |
| ROI Processing | **Partial** | ROI filtering and filling | Mask-first APIs, crop/measure/export workflows |
| Image Block Processing | **Functional** | Block and sliding-window processing | Parallel/batched execution and boundary policy |
| Filter Design and Visualization | **Specialized** | FFT filter helpers and surface visualization | Modern filter-design coverage |
| Image Stitching | **Specialized** | OpenCV panorama stitching | Diagnostics, masks, camera parameter exposure |
| Super Resolution | **Specialized** | Classical and DNN super-resolution | Model presets, tiling, memory-aware large images |
| Object Detection and Tracking | **Functional** | Cascade detection and OpenCV trackers | Modern detector integration and lifecycle diagnostics |
| Deep Learning | **Functional** | OpenCV DNN, common decoders, preprocessing, Zoo browser | Broader model contracts, batching, backend capability reporting |
| Video and Camera Handling | **Functional** | Read/write, seek, properties, camera capture | Cross-platform device tests, streaming pipelines |
| Utilities and Interactive Tools | **Functional** | Display overlays, ROI tools, annotations, version reporting | Unified annotation/measurement application workflow |
| Analytic Geometry | **Partial** | Limited plotting helpers | Deliberate scope decision or expanded geometry utilities |

## Step 3 Batches 1 To 4

- `imthreshold`: fixed, Otsu, and Triangle threshold modes with normalized levels.
- `imbinarize`: boolean-output fixed or automatic binarization.
- `imconnectedcomponents`: 4/8-connectivity labels, areas, 1-based boxes, and centroids.
- `imlabel`: compatibility API now delegates to the shared connected-components engine.
- `bwareaopen`: removes foreground components below a measured area threshold.
- `imclearborder`: removes components touching the image border.
- `imarea`, `imcentroid`, `imboundingbox`, and `imperimeter`: measure binary image geometry.
- `bwareafilt`: keeps components inside an inclusive area range.
- `imreconstruct`: performs binary geodesic reconstruction.
- `imregionalmax`, `imregionalmin`, `imextendedmax`, and `imextendedmin`: detect local extrema and contrast-filtered extrema.
- `imgradientxy` and `imgradientmagnitude`: expose Sobel derivatives and magnitude.

## Step 3 Batch 4

- Filtering compatibility entry points: `imboxfilt`, `imgaussfilt`, `immedianfilt`, `imbilateralfilt`, `medfilt2`, and `wiener2`. They preserve separate public names and may add MATLAB-oriented defaults or validation while sharing current backends.
- Enhancement compatibility entry points: `imnlmfilt` and `adapthisteq`; separate compositions: `imsharpen` and `imlaplacian`.
- Gradient and local statistics: `imgradientdirection`, `imlocalmean`, and `imlocalstd`.
