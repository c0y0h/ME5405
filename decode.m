function [original_image] = decode(data)
%   turn from chromo to image
%   input:  chromo txt matrix
%   output: original image matrix
original_image = zeros(64, 64, "uint8");
for i = 1 : 64
    for j = 1 : 64
        if(data{i}(j) >= '0' && data{i}(j) <= '9')
            original_image(i, j) = data{i}(j) - '0';
        else
            original_image(i, j) = data{i}(j) - 'A' + 10;
        end
    end
end

end

