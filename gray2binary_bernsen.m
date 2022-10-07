function [binary_image] = gray2binary_bernsen(original_image, kernel_size, Tlocal, Tglobal)
%GRAY2BINARY_BERNSEN 此处显示有关此函数的摘要
%   设当前像素为点为 P(i，j)，
%   计算以P为中心的大小为 kernel*kernel 窗口内的所有像素的最大值 kernelMax 与最小值kernelMin，
%   若两者差值相近，该部分属于目标或背景，将该灰度与全局阈值比较，确定是目标还是背景，
%   若二者差值较大则可能属于目标与背景相交的边缘，此时将二者平均值作为 Kernel 阈值。
%   https://blog.csdn.net/Skymelu/article/details/95631992

height = size(original_image, 1);
width = size(original_image, 2);
binary_image = zeros(height, width, "uint8");
halfKernel = floor(kernel_size / 2);

kernelData = zeros(kernel_size * kernel_size, 1);

for i  = 1 : height
    for j = 1 : width
        if(i <= halfKernel || i > height - halfKernel ||  j <= halfKernel || j > width - halfKernel)
            binary_image(i, j) = 0;
        else
            k = 1;
            for x = i - halfKernel : i + halfKernel
                for y = j - halfKernel : j + halfKernel
                    kernelData(k) = original_image(x, y);
                    k = k + 1;
                end
            end
            kernelMax = max(kernelData);
            kernelMin = min(kernelData);
            Tkernel = (kernelMax + kernelMin) / 2;

            % 灰度差值小，该点要么在目标区域，要么在背景区域
            if(kernelMax - kernelMin <= Tlocal)
                if(Tkernel > Tglobal)
                    binary_image(i, j) = 0;
                else
                    binary_image(i, j) = 255;
                end

            % 灰度差值大，说明在边缘区域，将均值作为局部阈值
            else
                if(original_image(i, j) > Tkernel)
                    binary_image(i, j) = 0;
                else
                    binary_image(i, j) = 255;
                end
            end
        end
    end
end
    

end

