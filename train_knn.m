function [out] = train_knn(K,test_img,valid_or_test)
%TRAIN_KNN Summary of this function goes here
%   Detailed explanation goes here
matrix=[];  % for training
filename={'D','E','H','L','O','R','W'};
% for delta=1:7
%     label_path=strcat('./p_dataset_26/Sample',filename{delta},'/');
%     disp(length(dir([label_path '*.png'])));
%     for i=1:round(0.75*length(dir([label_path, '*.png'])))
%         pstr=strcat(label_path,'img0',num2str(filename{delta}-'A'+11),'-',num2str(i,'%05d'),'.png');
%         im=imread(pstr);
%         disp(['read',pstr]);
%         im=imbinarize(im);  %binarize
%         temp=[];
%         for j=1:size(im,1)  %turn to row vector
%             temp=[temp,im(j,:)];
%         end
%         matrix=[matrix;temp];
%     end
% end
% 
% save './train_matrix.mat' matrix;

load('./train_matrix.mat');

label=[];   %label
for delta=1:7
    label_path=strcat('./p_dataset_26/Sample',filename{delta},'/');
    tem=ones(round(0.75*length(dir([label_path, '*.png']))),1)*(filename{delta}-'A'+11);
    label=[label;tem];
end

matrix=horzcat(matrix,label);   % training matrix with label

if valid_or_test==1
    out=[];
    pic_sum=0;
    %valid set
    for delta = 1:7
        test_path = strcat('./p_dataset_26/Sample',filename{delta},'/');
        len = round(0.75*length(dir([test_path '*.png'])));
        disp(len);
        p = 0;
        for i = len+1:length(dir([test_path '*.png']))
            vec = [];        
            test_im = imread(strcat(test_path,'img0',num2str(filename{delta}-'A'+11),'-',num2str(i,'%05d'),'.png'));
            test_im = imbinarize(test_im);
            for j = 1:size(test_im,1)
                vec = [vec,test_im(j,:)];
            end
    
            dis = [];
            for count = 1:len * 7
                row = matrix(count,1:end-1);% 不带标签的训练矩阵每一行向量
                distance = norm(row(1,:)-vec(1,:));% 求欧氏几何距离
                dis = [dis;distance(1,1)];% 距离列向量
            end
            test_matrix = horzcat(matrix,dis);% 加入表示距离的列向量
    
    
            %根据最后一列（距离）排序
            test_matrix = sortrows(test_matrix,size(test_matrix,2));
            %输入K值，前K个行向量标签的众数作为结果输出
    %         K = 5;
            result = mode(test_matrix(1:K,end-1));
            pic_sum=pic_sum+1;
            disp(strcat('图像','img0',num2str(filename{delta}-'A'+11),'-',num2str(i,'%05d'),'.png','的识别结果是：',char('A'+result-11)));
    
            if(filename{delta}-'A'+11 == result)
                p = p + 1;
            end
            
            disp(strcat('The current accuracy is: ',num2str(p/pic_sum*100), ' %!'));
            
        end
        pi = p/(length(dir([test_path '*.png']))-len);
        disp(strcat('识别精度为：',num2str(pi)));
        disp('Finished!'); 
        
        out=[out;pi];
    end
else
    vec=[];
    for j = 1:size(test_img,1)
        vec = [vec,test_img(j,:)];
    end
    dis = [];
    len=size(matrix,1);
    for count = 1:len
        row = matrix(count,1:end-1);% 不带标签的训练矩阵每一行向量
        distance = norm(row(1,:)-vec(1,:));% 求欧氏几何距离
        dis = [dis;distance(1,1)];% 距离列向量
    end
        test_matrix = horzcat(matrix,dis);% 加入表示距离的列向量
    
    
    %根据最后一列（距离）排序
    test_matrix = sortrows(test_matrix,size(test_matrix,2));
    %输入K值，前K个行向量标签的众数作为结果输出
    result = mode(test_matrix(1:K,end-1));
    out=strcat('The input image is: ', char('A'+result-11),'!');
    disp(out);
end


end

