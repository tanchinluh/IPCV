function [labels, centers] = imsegkmeans(image, clusterCount)
    // Segment an image using OpenCV k-means clustering.
    //
    // Syntax
    //    [labels, centers] = imsegkmeans(image, clusterCount)
    //
    // labels is a 1-based label image. centers contains one row per cluster
    // and one column per image channel.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/peppers.png"));
    //    [labels, centers] = imsegkmeans(image, 4);
    //    segmented = imlabel2rgb(labels);
    //    imshow(segmented);
    //
    // See also
    //    imlabel
    //    imconnectedcomponents
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    if argn(2) <> 2 then error("imsegkmeans: image and cluster count are required."); end
    if type(clusterCount) <> 1 | size(clusterCount, "*") <> 1 | clusterCount < 2 then error("imsegkmeans: cluster count must be at least 2."); end
    [labels, centers] = int_imsegkmeans(image, round(clusterCount));
endfunction
