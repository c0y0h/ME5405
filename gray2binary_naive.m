function [binary_image] = gray2binary_naive(original_image, threshold)
%NAIVE_MANNUAL_SET 此处显示有关此函数的摘要
%   此处显示详细说明
height = size(original_image, 1);
width = size(original_image, 2);
binary_image = zeros(height, width);
for i = 1 : height
    for j = 1 : width
        if(original_image(i, j) <= threshold)
            binary_image(i, j) = 1;
        else
            binary_image(i, j) = 0;
        end
    end
end

end

