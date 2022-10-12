function [outline_image] = detector_sobel(binary_image, sobel_threshold)
%DETECTOR_SOBER 此处显示有关此函数的摘要
%   Sobel算子是主要用于边缘检测的离散微分算子，它结合了高斯平滑和微分求导，用于计算图像灰度函数的近似梯度。
%   Gx = -1 0 1         Gy = -1 -2 -1
%        -2 0 2               0  0  0
%        -1 0 1               1  2  1

height = size(binary_image, 1);
width = size(binary_image, 2);

% binary_image = double(binary_image);

outline_image = zeros(height, width);

Gx = [-1, 0, 1;
      -2, 0, 2;
      -1, 0, 1];
Gy = [-1, -2, -1;
       0,  0,  0;
       1,  2,  1];

for i = 2 : height - 1
    for j = 2 : width - 1
        t1 = sum(binary_image(i - 1 : i + 1, j - 1 : j + 1) .* Gx, 'all');
        t2 = sum(binary_image(i - 1 : i + 1, j - 1 : j + 1) .* Gy, 'all');
%         t1 = -binary_image(i - 1, j - 1) + binary_image(i - 1, j + 1) - ...
%             2 * binary_image(i, j - 1) + 2 * binary_image(i, j + 1) - ...
%             binary_image(i + 1, j - 1) + binary_image(i + 1, j + 1);
        value = sqrt(t1 * t1 + t2 * t2);
        % value = abs(t1) + abs(t2);
        if value < sobel_threshold
            outline_image(i, j) = 0;
        else
            outline_image(i, j) = 1;
        end
        
    end
end

end

