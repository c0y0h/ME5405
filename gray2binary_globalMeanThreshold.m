function [binary_image] = gray2binary_globalMeanThreshold(original_image)
%GRAY2BINARY_GLOBALMEANTHRESHOLD 此处显示有关此函数的摘要
%   此处显示详细说明
binary_image = zeros(64, 64, "uint8");
sum = 0;
for i = 1 : 64
    for j = 1 : 64
        sum = sum + original_image(i, j);
    end
end
global_mean_threshold = sum / (size(original_image, 1) * size(original_image, 1));

for i = 1 : 64
    for j = 1 : 64
        if(original_image(i, j) <= global_mean_threshold)
            binary_image(i, j) = 31;
        else
            binary_image(i, j) = 0;
        end
    end
end

end

