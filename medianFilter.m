function [img_afterFilter] = medianFilter(original_image, kernel_size)
%MEDIANFILTER 此处显示有关此函数的摘要
%   此处显示详细说明
[height, width] = size(original_image);
img_afterFilter = original_image;
% img_afterFilter = ones(height, width) * 31;

shift = floor(kernel_size / 2);

for i = 1 + shift : height - shift
    for j = 1 + shift : width - shift
        value = median(original_image(i - shift : i + shift, j - shift : j + shift), 'all');
        img_afterFilter(i, j) = value;
    end
end

end

