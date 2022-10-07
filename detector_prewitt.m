function [outline_image] = detector_prewitt(binary_image, prewitt_threshold)
%DETECTOR_SOBER 此处显示有关此函数的摘要
%   Prewitt算子利用像素点上下、左右邻点的灰度差，在边缘处达到极值检测边缘，去掉部分伪边缘，对噪声具有平滑作用
%   Gx = -1 0 1         Gy =  1  1  1
%        -1 0 1               0  0  0
%        -1 0 1              -1 -1 -1

height = size(binary_image, 1);
width = size(binary_image, 2);

outline_image = zeros(height, width);

Gx = [-1, 0, 1;
      -1, 0, 1;
      -1, 0, 1];
Gy = [ 1,  1,  1;
       0,  0,  0;
      -1, -1, -1];

for i = 2 : height - 1
    for j = 2 : width - 1
        t1 = sum(binary_image(i - 1 : i + 1, j - 1 : j + 1) .* Gx, 'all');
        t2 = sum(binary_image(i - 1 : i + 1, j - 1 : j + 1) .* Gy, 'all');

        value = sqrt(t1 * t1 + t2 * t2);
        % value = abs(t1) + abs(t2);
        if value < prewitt_threshold
            outline_image(i, j) = 0;
        else
            outline_image(i, j) = 1;
        end
        
    end
end

end

