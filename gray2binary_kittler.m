function [binary_image] = gray2binary_kittler(original_image)
%GRAY2BINARY_KITTLER 此处显示有关此函数的摘要
%   计算图像的梯度灰度的平均值，作为阈值
binary_image = zeros(64, 64, "uint8");
tmp = 0;
grad = 0;

for i = 1 : 64
    for j = 1 : 64
        tmp = tmp + double(original_image(i, j));
    end
end

for i = 1 : 63
    for j = 1 : 63
        dx = double(original_image(i, j + 1)) - double(original_image(i, j));
        dy = double(original_image(i + 1, j)) - double(original_image(i, j));
        % ds = abs(dx) + abs(dy);
        ds = sqrt(dx*dx + dy*dy);
        grad = grad + ds;
    end
end

imageAvG = grad + tmp;
threshold = imageAvG / (64 * 64);

for i = 1 : 64
    for j = 1 : 64
        if(original_image(i, j) <= threshold)
            binary_image(i, j) = 31;
        else
            binary_image(i, j) = 0;
        end
    end
end

end

