function [histgram] = histgram_transform(original_image, gray_level)
%HISTGRAM_TRANSFORM 此处显示有关此函数的摘要
%   此处显示详细说明
histgram = zeros(1, gray_level);
for i = 1 : size(original_image, 1)
    for j = 1 : size(original_image, 2)
        histgram(original_image(i, j) + 1) = histgram(original_image(i, j) + 1) + 1;
    end
end
end

