function [binary_image] = gray2binary_niblack(original_image, kernel_size, k)
%GRAY2BINARY_NIBLACK 此处显示有关此函数的摘要
%   T_niblack = m + k * s
%             = m + k * sqrt( 1 / (N*P) * sum((pi - m) ^ 2) )
%   https://blog.csdn.net/LOVExinxinsensen/article/details/79631924

height = size(original_image, 1);
width = size(original_image, 2);

% binary_image = zeros(height, width);

window = ones(kernel_size, kernel_size);

% compute sum of pixels in window
sp = conv2(original_image, window, 'same');

% convert to mean
n = kernel_size ^ 2;
m = sp / n;

% compute the std
if k ~= 0
    % compute sum of pixels squared in window
    sp2 = conv2(double(original_image).^2, window, 'same');
    % convert to std
    var = abs(n * sp2 - sp.^2) / n / (n - 1);
    s = sqrt(var);
    % compute Niback threshold
    t = m + k * s;
else
    t = m;
end

binary_image = original_image < t;

end