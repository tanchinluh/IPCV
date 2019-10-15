S_rgb_uint8 = imread(getIPCVpath() + '\images\baboon.png');
S_rgb_double = im2double(S_rgb_uint8);
S_rgb_double = imresize(S_rgb_double,0.5);

cmap = testmap(6.6);

c_size = size(cmap,1);

size_img = size(S_rgb_double);
S_ind = zeros(size_img(1),size_img(2));
tic();
for cnt1 = 1:size_img(1)
    
    for cnt2 = 1:size_img(2)
        aa = S_rgb_double(cnt1,cnt2,:);
        aa = squeeze(aa);
        aa = repmat(aa,1,c_size)';
        bb = sum((aa - cmap).^2,'c');
        //bb = cmap*abs(aa);
        [mm,ind] = min(bb);
        S_ind(cnt1,cnt2)= ind;
    end
    
end
disp(toc())
