function [binary_image] = gray2binary_kittler(original_image)
%GRAY2BINARY_KITTLER 此处显示有关此函数的摘要
%   计算图像的梯度灰度的平均值，作为阈值
%   https://blog.csdn.net/qq_43743037/article/details/105376884
height = size(original_image, 1);
width = size(original_image, 2);
binary_image = zeros(height, width);
tmp = 0;
grad = 0;

for i = 1 : height
    for j = 1 : width
        tmp = tmp + double(original_image(i, j));
    end
end

for i = 1 : height - 1
    for j = 1 : width - 1
        dx = double(original_image(i, j + 1)) - double(original_image(i, j));
        dy = double(original_image(i + 1, j)) - double(original_image(i, j));
        % ds = abs(dx) + abs(dy);
        ds = sqrt(dx*dx + dy*dy);
        grad = grad + ds;
    end
end

imageAvG = grad + tmp;
threshold = imageAvG / (height * width);

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

