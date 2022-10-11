function [outline_image] = detector_laplace(binary_image, laplace_threshold)
%DETECTOR_SOBER 此处显示有关此函数的摘要
%   Sobel算子是主要用于边缘检测的离散微分算子，它结合了高斯平滑和微分求导，用于计算图像灰度函数的近似梯度。
%   Gx = -1 0 1         Gy = -1 -2 -1
%        -2 0 2               0  0  0
%        -1 0 1               1  2  1

height = size(binary_image, 1);
width = size(binary_image, 2);

outline_image = zeros(height, width);

G =  [ 1, 1, 1;
       1,-8, 1;
       1, 1, 1];

for i = 2 : height - 1
    for j = 2 : width - 1
        value = sum(binary_image(i - 1 : i + 1, j - 1 : j + 1) .* G, 'all');

        % value = abs(t1) + abs(t2);
        if value < laplace_threshold
            outline_image(i, j) = 0;
        else
            outline_image(i, j) = 1;
        end
        
    end
end

end