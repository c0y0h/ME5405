function [thin_image] = thin_hilditch(binary_image)
%THIN_HILDITCH 此处显示有关此函数的摘要
%   Hilditch 算法是判断图像中的点属于边界点还是连通点，如为边界点则可以去掉此点。 
%   应用过程为对一幅图像从左上角开始到右下角的每个像素进行迭代运算，
%   每次迭代运算可以将图像最外面一 层像素剔去，层层剥离后最终剩下最中间的一条线，
%   得到最终的骨架线，即细化后的图像。
%   
%   在进行迭代运算时，当某个像素满足以下六个条件时即被标记删除:
%   P3      P2      P1
%   P4      P       P0
%   P5      P6      P7
% (1）   P为前景点；
% (2)   P0、P2、P4、P6不全为前景点，即P为边界点；
% (3)   P0~P7中至少有2个前景点，表示P不是端点或孤立点，端点和孤立点不能删除；
% (4)   P的八联通区域连接数为1，保证细化后的骨架线不会出现断裂的情况；
% (5)   若P2被标记删除，P2为0时，P的联通连接数为1，保证两个像素宽的水平条不会被腐蚀掉；
% (6)   若P4被标记删除，P4为0时，P的联通连接数为1，保证两个像素宽的垂直条不会被腐蚀掉。
%  以上判据就是：1.内部点不能删除、2.孤立点不能删除、3.端点不能删除、4.若P是边界点，去掉P后，连通分量不增加，则P可以删除。

%   4联通计算公式:
%   Nc(p) = sum(x_2i-1 - x_2i-1 * x_2i * x_2i+1), i from 1 to 4;
%   8联通计算公式:
%   Nc(p) = sum(x_2i-1 - x_2i-1 * x_2i * x_2i+1), i from 1 to 4;

%   preprocessing, zero_padding
pad_image = zeros(64 + 4, 64 + 4);
pad_image(3 : end - 2, 3 : end - 2) = binary_image;

flag = 1;

while flag
    flag = 0;
    [row, col] = find(pad_image == 1);
    pic_del = ones(size(pad_image));
    count = 0;     % 存储每次迭代需要移除的数量，若为0则说明细化结束

    for i = 1 : length(row)

        X = row(i);
        Y = col(i);
        %   X4   X3   X2
        %   X5   P    X1
        %   X6   X7   X8
        P = [pad_image(X, Y+1), pad_image(X-1, Y+1), pad_image(X-1, Y), ...
             pad_image(X-1, Y-1), pad_image(X, Y-1), pad_image(X+1, Y-1), ...
             pad_image(X+1, Y), pad_image(X+1, Y+1), pad_image(X, Y+1)];

        %   条件2: X1, X3, X5, X7 不全为1
        C2 = P(1) + P(3) + P(5) + P(7);
        if C2 == 4
            continue;
        end

        %   条件3: 非细线尖端，X1 - X8 中至少有两个为 1
        if sum(P(1 : 8)) < 2
            continue;
        end

        %   条件4: 非最后一个遗留待处理点， 至少有一个前景邻居未被移除
        w = 0;
        for m = X-1 : X+1
            for n = Y-1 : Y+1
                if m == X && n == Y
                    continue;
                end
                if pad_image(m, n) == 1 && pic_del(m, n) == 1
                    w = w + 1;
                end
            end
        end
        if w < 1
            continue;
        end

        %   条件5: 计算连接数（8连接计算取反）
        if c_number(P) ~= 1
            continue;
        end

        % condition6：与已移除的任何邻居一起移除不会改变连通性，只需计算X3和X5
        if pic_del(X-1, Y) == 0
            P3 = [pad_image(X, Y+1), pad_image(X-1, Y+1), 0, ...
                  pad_image(X-1, Y-1), pad_image(X, Y-1), pad_image(X+1, Y-1), ...
                  pad_image(X+1, Y), pad_image(X+1, Y+1), pad_image(X, Y+1)];
             if c_number(P3) ~= 1
                 continue;
             end
        end
        
        % condition6：X5
        if pic_del(X, Y-1) == 0
            P5 = [pad_image(X, Y+1), pad_image(X-1, Y+1), pad_image(X-1, Y), ...
                  pad_image(X-1, Y-1), 0, pad_image(X+1, Y-1), ...
                  pad_image(X+1, Y), pad_image(X+1, Y+1), pad_image(X, Y+1)];
            if c_number(P5) ~= 1
                continue;
            end
        end

        pic_del(X, Y) = 0;
        count = count + 1;
    end
    if count ~= 0
        pad_image = pad_image .* pic_del;   %更新
        flag = 1;
    end
end

thin_image = pad_image(3 : end - 2, 3 : end - 2);

end

