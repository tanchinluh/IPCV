function out = imdrawkeypoints(image, features, rgb)
    // Draw feature locations as small image-space boxes.
    rhs=argn(2); if rhs < 2 | rhs > 3 then error("imdrawkeypoints: image and feature object are required."); end
    if rhs < 3 then rgb=[0 255 0]; end
    if ~isfield(features,"n") | features.n==0 then out=image; return; end
    boxes=zeros(features.n,4);
    for i=1:features.n, radius=max(2,round(features.size(i)/2)); boxes(i,:)=[features.x(i)-radius features.y(i)-radius 2*radius 2*radius]; end
    out=imdrawboxes(image,boxes,rgb);
endfunction
