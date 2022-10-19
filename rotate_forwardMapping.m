function [rotatedImg] = rotate_forwardMapping(original_image, theta)
%IMG_ROTATE https://blog.csdn.net/lkj345/article/details/50555870
%   此处显示详细说明
original_image = double(original_image);
height = size(original_image, 1);
width = size(original_image, 2);

%   旋转后的图像尺寸
new_h = ceil(abs(height*cosd(theta)) + abs(width*sind(theta)));
new_w = ceil(abs(width*cosd(theta)) + abs(height*sind(theta)));

rotatedImg = zeros(new_h, new_w);

translate1 = [1   0   -0.5*width;
              0  -1    0.5*height;
              0   0       1];
rotation_matrix = [cosd(theta)   -sind(theta)   0;
                   sind(theta)    cosd(theta)   0;
                   0             0              1];
translate2 = [1   0   0.5*new_w;
              0  -1   0.5*new_h;
              0   0       1];

%   前向映射
for i = 1 : width
    for j = 1 : height
        new_point = translate2 * rotation_matrix * translate1 * [i;j;1];
%         new_point = [i j 1] * translate1' * rotation_matrix' * translate2';
        ptx = round(new_point(1));
        pty = round(new_point(2));
        if ptx > new_w
            ptx = new_w;
        elseif ptx < 1
            ptx = 1;
        end
        if pty > new_h
            pty = new_h;
        elseif pty < 1
            pty = 1;
        end


        rotatedImg(pty, ptx) = original_image(j, i);
    end
end



end

