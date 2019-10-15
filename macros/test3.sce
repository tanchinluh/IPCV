S_rgb_uint8 = imread(getIPCVpath() + '\images\baboon.png');
//S_rgb_double = im2double(S_rgb_uint8);
S_rgb_uint8 = imresize(S_rgb_uint8,0.5);

S_lab = rgb2lab(S_rgb_uint8);

a = im2double(S_lab(:,:,1));
b = im2double(S_lab(:,:,2));

cmap = testmap(8);


// Method 1 conversion
//cmap2 = permute(cmap,[1 3 2]);
cmap2 = (permute(im2uint8(cmap),[1 3 2]));
bb = rgb2lab(cmap2);
//bb2 = permute(bb,[1 3 2]);
cmap_a = im2double(bb(:,:,1));
cmap_b = im2double(bb(:,:,2));


// Method 2 conversion 
//tm = [0.412453 0.357580 0.180423;0.212671 0.715160 0.072169; 0.019334 0.119193 0.950227];
//map1 = tm*cmap';
//map1(1,:) = map1(1,:)./0.950456;
//map1(3,:) = map1(3,:)./1.088754;
//cmap_a = 500.*(tempF(map1(1,:))- tempF(map1(2,:)));
//cmap_b = 200.*(tempF(map1(2,:))- tempF(map1(3,:)));
//cmap_a2 = (cmap_a + 128)./255;
//cmap_b2 = (cmap_b + 128)./255;


// Start Convert
c_size = size(cmap,1);
size_img = size(S_rgb_uint8);
S_ind = zeros(size_img(1),size_img(2));
tic();
for cnt1 = 1:size_img(1)
    
    for cnt2 = 1:size_img(2)
          distance = sqrt((cmap_a - a(cnt1,cnt2)).^2 +(cmap_b - b(cnt1,cnt2)).^2);
//        aa = S_rgb_double(cnt1,cnt2,:);
//        aa = squeeze(aa);
//        aa = repmat(aa,1,c_size)';
//        bb = sum((aa - cmap).^2,'c');
//        bb = cmap*abs(aa);
        [mm,ind] = min(distance);
        S_ind(cnt1,cnt2)= ind;
    end
    
end
disp(toc());
imshow(S_ind,cmap);
