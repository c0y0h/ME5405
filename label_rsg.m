function [label_matrix] = label_rsg(binary_image)
%LABEL_RSG 此处显示有关此函数的摘要
%   区域生长实现的步骤如下:
% 1. 对图像顺序扫描!找到第1个还没有归属的像素, 设该像素为(x0, y0);
% 2. 以(x0, y0)为中心, 考虑(x0, y0)的8邻域像素(x, y)如果(x0, y0)满足生长准则, 将(x, y)与(x0, y0)合并(在同一区域内),
%    同时将(x, y)压入堆栈;
% 3. 从堆栈中取出一个像素, 把它当作(x0, y0)返回到步骤2;
% 4. 当堆栈为空时!返回到步骤1;
% 5. 重复步骤1 - 4直到图像中的每个点都有归属时。生长结束。

% 原文链接：https://www.cnblogs.com/vincent2012/archive/2013/01/25/2876986.html

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
label_flag = zeros(height, width);

stk = [];

label_count = 0;

for i = 1 : height
    for j = 1 : width
        if binary_image(i, j) == 1 && label_flag(i, j) == 0
            label_count = label_count + 1;
            %   push into stack
            stk = [stk; [i, j]];
            label_matrix(i, j) = label_count;
            label_flag(i, j) = 1;

            while size(stk, 1) > 0
                pt = stk(end,:);
                stk = stk(1:end-1,:);
    
                for k = 1 : 8
                    tmpx = pt(1) + connects(k,1);
                    tmpy = pt(2) + connects(k,2);
    
                    if tmpx < 1 || tmpy < 1 || tmpx > height || tmpy > width
                        continue;
                    end
                       
                    % 前景点，标上和父节点一样的标签，并且压入栈
                    if binary_image(tmpx, tmpy) ~= 0 && label_flag(tmpx, tmpy) == 0
                        label_matrix(tmpx, tmpy) = label_count;
                        label_flag(tmpx, tmpy) = 1;
                        stk = [stk; [tmpx, tmpy]];
                    end
                end
            end
        end
    end
end


end

