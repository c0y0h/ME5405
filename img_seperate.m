function [count, s] = img_seperate(label_matrix)
%IMG_SEPERATE 此处显示有关此函数的摘要
%   统计label数目
count = 0;
label = [];
h = size(label_matrix, 1);
w = size(label_matrix, 2);
for i = 1 : h
    for j = 1 : w
        if label_matrix(i,j) == 0
            continue;
        else
            if ~ismember(label_matrix(i,j), label)
                label = [label, label_matrix(i,j)];
                count = count + 1;
            end
        end
    end
end


s(count) = struct('Image',[],'address',[],'Centroid',[],'BoundingBox',[]);
for i=1:count
    [r,c] = find(label_matrix == label(i));
    s(i).address = [r,c];

    r_ = r-min(r)+1;
    c_ = c-min(c)+1;
    s(i).Image = zeros(max(r_),max(c_));
    s(i).BoundingBox=[min(r)-0.5,min(c)-0.5,max(r)+0.5,max(c)+0.5];
    for q=1:size(r_)
        s(i).Image(r_(q),c_(q))=1;
    end  
    s(i).Centroid=[mean(r),mean(c)];
     
end


end

