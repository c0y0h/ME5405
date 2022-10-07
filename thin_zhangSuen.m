function [thin_image] = thin_zhangSuen(binary_image)
%THIN_ZHANGSUEN 
%   Step One：循环所有前景像素点，对符合如下条件的像素点标记为删除：
%   1.  2 <= N(p1) <=6
%   2.  S(P1) = 1
%   3.  P2 * P4 * P6 = 0
%   4.  P4 * P6 * P8 = 0
%           P9  P2  P3  
%           P8  P1  P4
%           P7  P6  P5
%   其中，N(P1)表示8个邻居中为1的数目
%        S(P1)表示从P2-P9-P2（顺时针）转一圈，从0到1变化的次数

%   Step Two：循环所有前景像素点，对符合如下条件的像素点标记为删除：
%   1.  2 <= N(p1) <=6
%   2.  S(P1) = 1
%   3.  P2 * P4 * P8 = 0
%   4.  P2 * P6 * P8 = 0

%   inverse, 算法把0作为前景，1作为后景
thin_image = binary_image;
thin_image = 1 - thin_image;

while true
    s1 = [];
    s2 = [];
    
    % Step 1
    for i = 2 : 63
        for j = 2 : 63  
            
            %   不是前景点不理会
            if thin_image(i, j) > 0
                continue;
            end
    
            %   condition 1
            flag1 = sum(thin_image(i - 1 : i + 1, j - 1 : j + 1), 'all');
            if flag1 < 2 || flag1 > 6
                continue;
            end
    
            %   condition 2
            flag2 = 0;
            if(thin_image(i - 1, j + 1) - thin_image(i - 1, j) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i, j + 1) - thin_image(i - 1, j + 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i + 1, j + 1) - thin_image(i, j + 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i + 1, j) - thin_image(i + 1, j + 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i + 1, j - 1) - thin_image(i + 1, j) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i, j - 1) - thin_image(i + 1, j - 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i - 1, j - 1) - thin_image(i, j - 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i - 1, j) - thin_image(i - 1, j - 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i - 1, j) - thin_image(i - 1, j - 1) == 1)
                flag2 = flag2 + 1;
            end
            
            if flag2 ~= 1
                continue;
            end
    
    
            %   condition 3
            if(thin_image(i - 1, j) + thin_image(i, j + 1) + thin_image(i + 1, j) < 1)
                continue;
            end
    
            %   condition 4
            if(thin_image(i, j + 1) + thin_image(i + 1, j) + thin_image(i, j - 1) < 1)
                continue;
            end

            s1 = [s1; [i, j]];
            
        end
    end
    
    for k = 1 : size(s1, 1)
        thin_image(s1(k, 1), s1(k, 2)) = 1;
    end
    

    % Step 2
    for i = 2 : 63
        for j = 2 : 63  
            
            %   不是前景点不理会
            if thin_image(i, j) > 0
                continue;
            end
    
            %   condition 1
            flag1 = sum(thin_image(i - 1 : i + 1, j - 1 : j + 1), 'all');
            if flag1 < 2 || flag1 > 6
                continue;
            end
    
            %   condition 2
            flag2 = 0;
            if(thin_image(i - 1, j + 1) - thin_image(i - 1, j) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i, j + 1) - thin_image(i - 1, j + 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i + 1, j + 1) - thin_image(i, j + 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i + 1, j) - thin_image(i + 1, j + 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i + 1, j - 1) - thin_image(i + 1, j) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i, j - 1) - thin_image(i + 1, j - 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i - 1, j - 1) - thin_image(i, j - 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i - 1, j) - thin_image(i - 1, j - 1) == 1)
                flag2 = flag2 + 1;
            end
            if(thin_image(i - 1, j) - thin_image(i - 1, j - 1) == 1)
                flag2 = flag2 + 1;
            end
            
            if flag2 ~= 1
                continue;
            end
    
    
            %   condition 3
            if(thin_image(i - 1, j) + thin_image(i, j + 1) + thin_image(i, j - 1) < 1)
                continue;
            end
    
            %   condition 4
            if(thin_image(i - 1, j) + thin_image(i + 1, j) + thin_image(i, j - 1) < 1)
                continue;
            end

            s2 = [s2; [i, j]];
            
        end
    end
    
    for k = 1 : size(s2, 1)
        thin_image(s2(k, 1), s2(k, 2)) = 1;
    end

    %   如果两步中都没有点要删除，结束循环
    if size(s1, 1) == 0 && size(s2, 1) == 0
        break;
    end
end

    thin_image = 1 - thin_image;


end

