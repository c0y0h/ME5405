function [binary_image] = gray2binary_iterative(original_image)
%GRAY2BINARY_GLOBALMEANTHRESHOLD 此处显示有关此函数的摘要
%   此处显示详细说明
binary_image = zeros(64, 64, "uint8");

threshold = (0 + 31) / 2;
new_threshold = 0;

while(abs(threshold - new_threshold) < 1e-5)
    sum_low = 0;
    count_low = 0;
    sum_high = 0;
    count_high = 0;

    for i = 1 : 64
        for j = 1 : 64
            if(original_image(i, j) <= threshold)
                sum_low = sum_low + original_image(i, j);
                count_low = count_low + 1;
            else
                sum_high = sum_high + original_image(i, j);
                count_high = count_high + 1;
            end
        end
    end

    average_low = sum_low / count_low;
    average_high = sum_high / count_high;
    new_threshold = (average_high + average_low) / 2;

end

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