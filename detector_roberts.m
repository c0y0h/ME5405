function [outline_image] = detector_roberts(binary_image)
%DETECTOR_ROBERTS 此处显示有关此函数的摘要
%   Robert算子是用于求解对角线方向的梯度，
%   因为根据算子GX和GY的元素设置可以看到，只有对角线上的元素非零，其本质就是以对角线作为差分的方向来检测。

height = size(binary_image, 1);
width = size(binary_image, 2);

outline_image = zeros(height, width);

for i = 1 : height - 1
    for j = 1 : width - 1
        t1 = (binary_image(i, j) - binary_image(i + 1, j + 1)).^2;
        t2 = (binary_image(i, j + 1) - binary_image(i + 1, j)).^2;
        outline_image(i, j) = int32(sqrt(t1 + t2));
    end
end
    
end

