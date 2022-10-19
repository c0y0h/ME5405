function [rotatedImg_nni, rotatedImg_bi] = rotate_backwardMapping(original_image, theta)
%IMG_ROTATE https://blog.csdn.net/lkj345/article/details/50555870
%   此处显示详细说明
original_image = double(original_image);
height = size(original_image, 1);
width = size(original_image, 2);

%   旋转后的图像尺寸
new_h = ceil(abs(height*cosd(theta)) + abs(width*sind(theta)));
new_w = ceil(abs(width*cosd(theta)) + abs(height*sind(theta)));

rotatedImg_nni = zeros(new_h, new_w);
rotatedImg_bi = zeros(new_h, new_w);

%   reverse mapping matrices
translate1 = [1   0   -0.5*new_w;
              0  -1    0.5*new_h;
              0   0       1];
rotation_matrix = [cosd(theta)    sind(theta)    0;
                   -sind(theta)   cosd(theta)    0;
                   0              0              1];
translate2 = [1   0   0.5*width;
              0  -1   0.5*height;
              0   0       1];

%   reverse mapping
for i = 1 : new_w   %x
    for j = 1 : new_h   %y
        old_point = translate2 * rotation_matrix * translate1 * [i; j; 1];
        ptx = round(old_point(1));
        pty = round(old_point(2));
        
        % overflow
        if pty < 1 || ptx < 1 || pty > height || ptx > width
            rotatedImg_nni(j,i) = 0;
            rotatedImg_nni(j,i) = 0;
        else
            % nearest neighbor interpolation
            rotatedImg_nni(j,i) = original_image(pty,ptx);

            % bilinear interpolation
            left = floor(ptx);
            right = ceil(ptx);
            top = floor(pty);
            bottom = ceil(pty);

            a = ptx - left;
            b = pty - top;
            rotatedImg_bi(j,i) = (1-a)*(1-b)*original_image(top,left) + ...
                                 a*(1-b)*original_image(top,right) + ...
                                 (1-a)*b*original_image(bottom,left) + ...
                                 a*b*original_image(bottom,right);
        end
    end
end


end

