function [outline_image1, outline_image2, outline_image3] = ...
    detector_canny(binary_image, GK_size, GK_sigma, Kxy_size, lowTh, ratio)
%DETECTOR_SOBER 此处显示有关此函数的摘要
%   在梯度算子基础上，引入了一种能获得抗噪性能好、定位精度高的单像素边缘的计算策略
%   step1. 用高斯滤波器对输入图像做平滑处理 (大小为 5x5 的高斯核)
%                   2  4  5  4  2
%                   4  9 12  9  4
%       K = 1/159   5 12 15 12  5
%                   4  9 12  9  4
%                   2  4  5  4  2
%
%   step2.    计算梯度值和梯度方向
%
%       Kx = -1 0 1         Ky = -1 -2 -1
%            -2 0 2               0  0  0
%            -1 0 1               1  2  1
%          theta = arctan(Ky / Kx), 角度方向近似为四个可能值，即 0, 45, 90, 135
%
%   step3. 对图像的梯度强度进行非极大抑制, 可看做边缘细化：只有候选边缘点被保留，其余的点被移除
%   step4. 利用双阈值检测和连接边缘, 若候选边缘点大于上阈值，则被保留；小于下阈值，则被舍弃；
%          处于二者之间，须视其所连接的像素点，大于上阈值则被保留，反之舍弃

%   https://zhuanlan.zhihu.com/p/42122107
%   https://blog.csdn.net/humanking7/article/details/46606791

height = size(binary_image, 1);
width = size(binary_image, 2);

outline_image1 = zeros(height, width);      % 加非极大值抑制
outline_image2 = zeros(height, width);      % 加双阈值检测
outline_image3 = zeros(height, width);      % 加二值化

GK = getGaussianKernel(GK_size, GK_sigma);
theta = zeros(height, width);
sector = zeros(height, width);
m = zeros(height, width);

if Kxy_size == 2
    Kx = [ 1, -1;
           1, -1];
    Ky = [-1, -1;
           1,  1];
end

if Kxy_size == 3
    Kx = [-1, 0, 1;
          -2, 0, 2;
          -1, 0, 1];
    Ky = [-1, -2, -1;
           0,  0,  0;
           1,  2,  1];
end

%   1. 高斯滤波
img_afterFilter = binary_image;
% center = round(GK_size / 2);
% cl = floor(GK_size / 2);
% for i = center : height - cl
%     for j = center : width - cl
%         value = sum(binary_image(i - cl : i + cl, j - cl : j + cl) .* GK, 'all');
%         img_afterFilter(i, j) = value;
%     end
% end

% sector：将方向分为3个区域，具体如下
% 2 1 0
% 3 X 3
% 0 1 2
%   2. 计算梯度值和梯度方向
if Kxy_size == 2
    startpoint = 1;
    endpoint = height - Kxy_size + 1;
elseif Kxy_size == 3
    startpoint = 2;
    endpoint = height - startpoint + 1;
end

for i = startpoint : endpoint
    for j = startpoint : endpoint
        if Kxy_size == 2
            t1 = sum(img_afterFilter(i : i + 1, j : j + 1) .* Kx, 'all');
            t2 = sum(img_afterFilter(i : i + 1, j : j + 1) .* Ky, 'all');
        elseif Kxy_size == 3
            t1 = sum(img_afterFilter(i - 1 : i + 1, j - 1 : j + 1) .* Kx, 'all');
            t2 = sum(img_afterFilter(i - 1 : i + 1, j - 1 : j + 1) .* Ky, 'all');
        end
        m(i, j) = sqrt(t1 * t1 + t2 * t2);
        theta(i, j) = atand(t1 / t2);
        tmp = theta(i, j);
        if tmp < 67.5 && tmp > 22.5
            sector(i, j) = 0;
        elseif tmp < 22.5 && tmp > -22.5
            sector(i, j) = 3;
        elseif tmp < -22.5 && tmp > -67.5
            sector(i, j) = 2;
        else
            sector(i, j) = 1;
        end
    end
end

%   3. 非极大值抑制
% 2 1 0
% 3 X 3
% 0 1 2
for i = 2 : height - 1
    for j = 2 : width - 1
        if sector(i, j) == 2    % 右上，左下
            if m(i, j) > m(i - 1, j + 1) && m(i, j) > m(i + 1, j - 1)
                outline_image1(i, j) = m(i, j);
            else
                outline_image1(i, j) = 0;
            end
        elseif sector(i, j) == 3    % 竖直方向
            if m(i, j) > m(i - 1, j) && m(i, j) > m(i + 1, j)
                outline_image1(i, j) = m(i, j);
            else
                outline_image1(i, j) = 0;
            end
        elseif sector(i, j) == 0    % 左上 - 右下
            if m(i, j) > m(i - 1, j - 1) && m(i, j) > m(i + 1, j  + 1)
                outline_image1(i, j) = m(i, j);
            else
                outline_image1(i, j) = 0;
            end
        elseif sector(i, j) == 1
            if m(i, j) > m(i, j - 1) && m(i, j) > m(i, j + 1)
                outline_image1(i, j) = m(i, j);
            else
                outline_image1(i, j) = 0;
            end
        end
    end
end

%   4. 双阈值检测
%   (a). 如果某一像素位置的梯度幅值超过高阈值，保留为边缘像素
%   (b). 如果小于低阈值，则被排除
%   (c). 如果介于之间，则判断该像素8邻域空间的像素是否存在高于高阈值的像素，如果存在，则保留该像素
for i = 2 : height - 1
    for j = 2 : width - 1
        if outline_image1(i, j) < lowTh
            outline_image2(i, j) = 0;
            outline_image3(i, j) = 0;
            continue;
        elseif outline_image1(i, j) > ratio * lowTh
            outline_image2(i, j) = outline_image1(i, j);
            outline_image3(i, j) = 1;
            continue;
        else    % 介于之间
            neighbour = [outline_image1(i - 1 : i + 1, j - 1 : j + 1)];
            neighbour_max = max(max(neighbour));
            if neighbour_max > ratio * lowTh
                outline_image2(i, j) = neighbour_max;
                outline_image3(i, j) = 1;
                continue;
            else
                outline_image2(i, j) = 0;
                outline_image3(i, j) = 0;
                continue;
            end
        end
    end
end



end