function [binary_image] = gray2binary_naive(original_image)
%NAIVE_MANNUAL_SET 此处显示有关此函数的摘要
%   此处显示详细说明
binary_image = zeros(64, 64, "uint8");
for i = 1 : 64
    for j = 1 : 64
        if(original_image(i, j) <= 18)
            binary_image(i, j) = 31;
        else
            binary_image(i, j) = 0;
        end
    end
end

end

