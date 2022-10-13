function [label_matrix] = label_classical(binary_image)
%LABEL_CLASSICAL 此处显示有关此函数的摘要

[height, width] = size(binary_image);

%   zero_padding
label_matrix = zeros(height + 1, width + 2);
label_matrix(2 : height + 1, 2 : width + 1) = binary_image;
label = 0;
eq_table = [0, 0];

%   逐行扫描，8邻接
for i = 2 : height
    for j = 2 : width + 1
        if label_matrix(i, j) == 0
            continue;
        end

        %   check neighbours
        %   up-left, up, up-right, left
        if label_matrix(i-1, j-1) == 0 && label_matrix(i-1, j) == 0 && label_matrix(i-1, j+1) == 0 ...
                    && label_matrix(i, j-1) == 0
            label = label + 1;
            label_matrix(i, j) = label;
        else
            temp = [];
            %   neighbour not zero, add to temp
            if(label_matrix(i-1, j-1) > 0)
                temp = [temp; label_matrix(i-1, j-1)];
            end
            if(label_matrix(i-1, j) > 0)
                temp = [temp; label_matrix(i-1, j)];
            end
            if(label_matrix(i-1, j+1) > 0)
                temp = [temp; label_matrix(i-1, j+1)];
            end
            if(label_matrix(i, j-1) > 0)
                temp = [temp; label_matrix(i, j-1)];
            end
            
            min_label = min(temp);
            label_matrix(i, j) = min_label;
            
            %   neighbours with different labels, record in eq_table
            if min_label ~= label_matrix(i-1, j-1) && label_matrix(i-1, j-1) ~= 0
                if ~ismember([min_label, label_matrix(i-1, j-1)], eq_table, 'rows')
                    eq_table = [eq_table; [min_label, label_matrix(i-1, j-1)]];
                end
            end
            if min_label ~= label_matrix(i-1, j) && label_matrix(i-1, j) ~= 0
                if ~ismember([min_label, label_matrix(i-1, j)], eq_table, 'rows')
                    eq_table = [eq_table; [min_label, label_matrix(i-1, j)]];
                end
            end
            if min_label ~= label_matrix(i-1, j+1) && label_matrix(i-1, j+1) ~= 0
                if ~ismember([min_label, label_matrix(i-1, j+1)], eq_table, 'rows')
                    eq_table = [eq_table; [min_label, label_matrix(i-1, j+1)]];
                end
            end
            if min_label ~= label_matrix(i, j-1) && label_matrix(i, j-1) ~= 0
                if ~ismember([min_label, label_matrix(i, j-1)], eq_table, 'rows')
                    eq_table = [eq_table; [min_label, label_matrix(i, j-1)]];
                end
            end
        end
    end
end

%   相当于要创建一个并查集
% label_table = [eq_table(2, 1), eq_table(2, 2)];
% for i = 3 : size(eq_table)
%     for j = 1 : size(label_table)
%         if ~ismember(eq_table(i, 1), label_table(j,:)) && ~ismember(eq_table(i, 2), label_table(j,:))...
%                 && j == size(label_matrix)
%             label_table = [label_table; [eq_table(i, 1), eq_table(i, 2)]];
%         else
%             if ~ismember(eq_table(i, 1), label_table(j,:))
%                 label_table(j,:) = [label_table(j,:), eq_table(i, 1)];
%             end
%             if ~ismember(eq_table(i, 2), label_table(j,:))
%                 label_table(j,:) = [label_table(j,:), eq_table(i, 2)];
%             end
%         end
%     end
% end


max_label = max(max(eq_table));
fa = zeros(max_label, 1);

%   init
for i = 1 : max_label
    fa(i) = i;
end
map = containers.Map('KeyType','double','ValueType','double');

for i = 2 : size(eq_table)
    join(eq_table(i, 1), eq_table(i, 2));
end

% fathers = [myfind(eq_table(2, 1))];
fathers = [];

for i = 2 : size(eq_table)
    value = myfind(eq_table(i, 1));
    if ~ismember(value, fathers)
        fathers = [fathers, value];
        map(eq_table(i, 1)) = find(value == fathers);
        map(eq_table(i, 2)) = find(value == fathers);
    else
        map(eq_table(i, 1)) = find(value == fathers);
        map(eq_table(i, 2)) = find(value == fathers);
    end
end


count = size(map, 1);

%   the second pass
for i = 2 : height
    for j = 2 : width + 1
        if label_matrix(i, j) == 0
            continue;
        end
        if map.isKey(label_matrix(i, j))
            label_matrix(i, j) = map(label_matrix(i, j));
        else
            label_matrix(i, j) = label_matrix(i, j) + count;
        end
    end
end

label_matrix = label_matrix(2 : height + 1, 2 : width + 1);
                
    %   find
    function [father] = myfind(node)
        if node == fa(node)
            father = node;
        else
            fa(node) = myfind(fa(node));
            father = fa(node);
        end
    end
    
    %   join  
    function [] = join(a, b)
        x = myfind(a);
        y = myfind(b);
        if x ~= y 
            fa(y) = x;
        end
    end

end

