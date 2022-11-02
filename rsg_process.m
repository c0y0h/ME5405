function [label_matrix] = rsg_process(binary_image, seeds)
%LABEL_RSG 此处显示有关此函数的摘要
%   区域生长实现的步骤如下:
% 1. 对图像顺序扫描!找到第1个还没有归属的像素, 设该像素为(x0, y0);
% 2. 以(x0, y0)为中心, 考虑(x0, y0)的8邻域像素(x, y)如果(x0, y0)满足生长准则, 将(x, y)与(x0, y0)合并(在同一区域内),
%    同时将(x, y)压入堆栈;
% 3. 从堆栈中取出一个像素, 把它当作(x0, y0)返回到步骤2;
% 4. 当堆栈为空时!返回到步骤1;
% 5. 重复步骤1 - 4直到图像中的每个点都有归属时。生长结束。

% 原文链接：https://blog.csdn.net/qiuqchen/article/details/45127449

height = size(binary_image, 1);
width = size(binary_image, 2);

connects = [-1, -1;
             0, -1;
             1, -1;
             1,  0;
             1,  1;
             0,  1;
            -1,  1;
            -1,  0];
 label_matrix = zeros(height, width);
 labelFlag = zeros(height, width);

%   人为设置三个种子点
% seed1 = [15, 15];
% seed2 = [47, 25];
% seed3 = [50, 39];
% seed4 = [30, 55];

stk = seeds;

label_count = 1;

while size(stk, 1) > 0
    seed = stk(end,:);
    stk = stk(1:end-1,:);

    for i = 1 : 8
        tmpx = seed(1) + connects(i,1);
        tmpy = seed(2) + connects(i,2);

        if tmpx < 1 || tmpy < 1 || tmpx > height || tmpy > width
            continue;
        end

        % 前景点且未被标记
        if binary_image(tmpx, tmpy) ~= 0 && labelFlag(tmpx, tmpy) == 0
            label_matrix(tmpx, tmpy) = label_count;
            labelFlag(tmpx, tmpy) = 1;
            stk = [stk; [tmpx, tmpy]];
        end
    end
    
end


end

