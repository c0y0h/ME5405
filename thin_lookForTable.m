function [thin_image] = thin_lookForTable(binary_image)
%THIN_LOOKFORTABLE https://www.cnblogs.com/xianglan/archive/2011/01/01/1923779.html
%   判断一个点是否能去掉是以8个相邻点（八连通）的情况来作为判据的，具体判据为：
%   1，内部点不能删除
%   2，鼓励点不能删除
%   3，直线端点不能删除
%   4，如果P是边界点，去掉P后，如果连通分量不增加，则P可删除

%   我们对于黑色的像素点，对于它周围的8个点，我们赋予不同的价值，
%   若周围某黑色，我们认为其价值为0，为白色则取九宫格中对应的价值
%   1   2   4
%   8   0   16
%   32  64  128
%   他这里黑色意思是前景点，白色是背景点
%   加权算出价值后再去索引表找，来看是否要保留这个点

%   这个算法快是快，但是台垃圾了，可以改进但是很麻烦，直接放弃

m = size(binary_image, 1);
n = size(binary_image, 2);

table = [0,0,1,1,0,0,1,1,1,1,0,1,1,1,0,1,...
         1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,1,...
         0,0,1,1,0,0,1,1,1,1,0,1,1,1,0,1,...
         1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,1,...
         1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,...
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,...
         1,1,0,0,1,1,0,0,1,1,0,1,1,1,0,1,...
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,...
         0,0,1,1,0,0,1,1,1,1,0,1,1,1,0,1,...
         1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,1,...
         0,0,1,1,0,0,1,1,1,1,0,1,1,1,0,1,...
         1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,...
         1,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,...
         1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,...
         1,1,0,0,1,1,0,0,1,1,0,1,1,1,0,0,...
         1,1,0,0,1,1,1,0,1,1,0,0,1,0,0,0];

mask = [1,  2,  4;
        8,  0,  16;
        32, 64, 128];

thin_image = ones(m, n);
tmp = 1 - binary_image;

for i = 2 : m - 1
    for j = 2 : n - 1
        if tmp(i, j) > 0
            continue;
        end
        mask_tmp = mask;
        part = tmp(i - 1 : i + 1, j - 1 : j + 1);
        for height = 1 : 3
            for width = 1 : 3
                if part(height, width) == 0
                    mask_tmp(height, width) = 0;
                end
            end
        end
        s = sum(mask_tmp .* part, 'all');
        thin_image(i, j) = table(s + 1);
    end
end

thin_image = 1 - thin_image;
        

end

