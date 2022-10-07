function [GaussianKernel] = getGaussianKernel(kernel_size, sigma)
%GETGAUSSIANKERNEL 此处显示有关此函数的摘要
%   https://www.pianshen.com/article/98071264153/
center = round(kernel_size / 2);
sum = 0;
GaussianKernel = zeros(kernel_size, kernel_size);
for i = 1 : kernel_size
    for j = 1 : kernel_size
        GaussianKernel(i, j) = 1 / (2 * pi * sigma * sigma) * ...
                    exp(-((i - center) * (i - center) + (j - center) * (j - center)) / (2 * sigma * sigma));
        sum = sum + GaussianKernel(i, j);
    end
end

for i = 1 : kernel_size
    for j = 1 : kernel_size
        GaussianKernel(i, j) = GaussianKernel(i, j) / sum;
    end
end
end

