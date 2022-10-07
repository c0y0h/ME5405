function [thin_image] = thin_rosenfeld(binary_image)
%THIN_ROSENFELD 此处显示有关此函数的摘要
%   1. 扫描所有像素，如果像素是北部边界点，且是8simple，但不是孤立点和端点，删除该像素。
%   2. 扫描所有像素，如果像素是南部边界点，且是8simple，但不是孤立点和端点，删除该像素。
%   3. 扫描所有像素，如果像素是东部边界点，且是8simple，但不是孤立点和端点，删除该像素。
%   4. 扫描所有像素，如果像素是西部边界点，且是8simple，但不是孤立点和端点，删除该像素。
%   执行完上面4个步骤后，就完成了一次迭代，我们重复执行上面的迭代过程，直到图像中再也没有可以删除的点后，退出迭代循环。

%   note: 8 simple 即把中间的像素从1变为0后，不改变周围八个邻居的八联通性

%   https://www.freesion.com/article/71451169858/

height = size(binary_image, 1);
width = size(binary_image, 2);

thin_image = binary_image;
while true
    s1 = [];
    s2 = [];
    s3 = [];
    s4 = [];
    for n = 1 : 4
        for i = 2 : height - 1
            for j = 2 : width - 1
    
                if thin_image(i, j) == 0
                    continue;
                end
    
                %   是孤立点或端点，跳过
    %             if sum(thin_image(i - 1 : i + 1, j - 1 : j + 1), 'all') - 1 == 0
    %                 continue;
    %             end
    %             if sum(thin_image(i - 1 : i + 1, j - 1 : j + 1), 'all') - 1 == 1
    %                 continue;
    %             end
                if sum(thin_image(i - 1 : i + 1, j - 1 : j + 1), 'all') <= 2
                    continue;
                end
    
                %   不是 8simple，跳过
                is8simple = 1;
                p2 = thin_image(i - 1, j);
                p3 = thin_image(i - 1, j + 1);
                p4 = thin_image(i, j + 1);
                p5 = thin_image(i + 1, j + 1);
                p6 = thin_image(i + 1, j);
                p7 = thin_image(i + 1, j - 1);
                p8 = thin_image(i, j - 1);
                p9 = thin_image(i - 1, j - 1);
                if p2 == 0 && p6 == 0
                    if (p9==1||p8==1||p7==1)&&(p3==1||p4==1||p5==1)
                        is8simple = 0;
                    end
                end
    
                if p4 == 0 && p8 == 0
                    if (p9==1||p2==1||p3==1)&&(p5==1||p6==1||p7==1)
                        is8simple = 0;
                    end
                end
    
                if p8 == 0 && p2 == 0
                    if p9==1&&(p3==1||p4==1||p5==1||p6==1||p7==1)
                        is8simple = 0;
                    end
                end
    
                if p4 == 0 && p2 == 0
                    if p3==1&&(p5==1||p6==1||p7==1||p8==1||p9==1)
                        is8simple = 0;
                    end
                end
    
                if p8 == 0 && p6 == 0
                    if p7==1&&(p3==9||p2==1||p3==1||p4==1||p5==1)
                        is8simple = 0;
                    end
                end
    
                if p4 == 0 && p6 == 0
                    if p5==1&&(p7==1||p8==1||p9==1||p2==1||p3==1)
                        is8simple = 0;
                    end
                end
                
                if is8simple == 0
                    continue;
                end
    
                %   不是 北南东西 边界点， 跳过
                if (n == 1 && p2 ~= 0) || (n == 2 && p6 ~= 0) || (n == 3 && p4 ~= 0) || (n == 4 && p8 ~= 0)
                    continue;
                end

                if(n == 1)
                    s1 = [s1; [i, j]];
                elseif(n == 2)
                    s2 = [s2; [i, j]];
                elseif(n == 3)
                    s3 = [s3; [i, j]];
                else
                    s4 = [s4; [i, j]];
                end

            end
        end

        if(n == 1)
            for k = 1 : size(s1, 1)
                thin_image(s1(k, 1), s1(k, 2)) = 0;
            end
        elseif(n == 2)
            for k = 1 : size(s2, 1)
                thin_image(s2(k, 1), s2(k, 2)) = 0;
            end
        elseif(n == 3)
            for k = 1 : size(s3, 1)
                thin_image(s3(k, 1), s3(k, 2)) = 0;
            end
        else
            for k = 1 : size(s4, 1)
                thin_image(s4(k, 1), s4(k, 2)) = 0;
            end
        end
    end

    if size(s1, 1) == 0 && size(s2, 1) == 0 && size(s3, 1) == 0 && size(s4, 1) == 0
        break;
    end
end

end


