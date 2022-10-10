function [img_afterFilter] = gaussianFilter(original_image, GK_size, GK_sigma)
%GAUSSIANFILTER 此处显示有关此函数的摘要
%   此处显示详细说明
%   1. 高斯滤波
height = size(original_image, 1);
width = size(original_image, 2);

center = round(GK_size / 2);    % 3 -> 2
cl = floor(GK_size / 2);        % 3 -> 1

tmp = double(original_image);
pad_image = zeros(height + cl * 2, width + cl * 2);
pad_image(cl + 1 : end - cl, cl + 1 : end - cl) = tmp;

img_afterFilter = zeros(height, width);

GK = getGaussianKernel(GK_size, GK_sigma);

for i = 1 : height
    for j = 1 : width
        value = sum(pad_image(i : i + GK_size - 1, j : j + GK_size - 1) .* GK , 'all');
        img_afterFilter(i, j) = value;
    end
end

% for i = center : height - cl
%     for j = center : width - cl
%         value = sum(pad_image(i - cl : i + cl, j - cl : j + cl) .* GK, 'all');
%         img_afterFilter(i, j) = value;
%     end
% end

end

