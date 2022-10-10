function [best_threshold, binary_image] = gray2binary_otsu(original_image)
%GRAY2BINARY_OTSU 此处显示有关此函数的摘要
%   n0, n1, m0, m1, p0, p1
%   g = p0 * p1 * (m0 - m1) ^ 2
%   https://blog.csdn.net/qq_43743037/article/details/105376884
height = size(original_image, 1);
width = size(original_image, 2);
binary_image = zeros(height, width);
best_threshold = 0;
g_max = 0;

for k = 0 : 31
    n0 = 0;
    n1 = 0;
    sum0 = 0;
    sum1 = 0;

    for i = 1 : height
        for j = 1 : width
            if(original_image(i, j) <= k)
                sum0 = sum0 + double(original_image(i, j));
                n0 = n0 + 1;
            else
                sum1 = sum1 + double(original_image(i, j));
                n1 = n1 + 1;
            end
        end
    end

    p0 = n0 / (height * width);
    p1 = n1 / (height * width);
    m0 = sum0 / n0;
    m1 = sum1 / n1;
    m = m0 * p0 + m1 * p1;
    g = p0 * (m0 - m) * (m0 - m) + p1 * (m1 - m) * (m1 - m);
    %g = p0 * p1 * (m0 - m1) * (m0 - m1);


    if(g > g_max)
        g_max = g;
        best_threshold = k;
    end
end

for i = 1 : height
    for j = 1 : width
        if(original_image(i, j) <= best_threshold)
            binary_image(i, j) = 31;
        else
            binary_image(i, j) = 0;
        end
    end
end

end

