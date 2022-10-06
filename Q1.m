%% Display the original image on screen.

data = importdata("chromo.txt");
original_image = decode(data);
figure(1);
imshow(original_image, [], 'InitialMagnification','fit');

%% Threshold the image and convert it into binary image.

% naive mannualy setting
binary_image = gray2binary_naive(original_image);
figure(2);
imshow(binary_image, [], 'InitialMagnification','fit');

% % global mean threshold
% binary_image = gray2binary_globalMeanThreshold(original_image);
% figure(3);
% imshow(binary_image, [], 'InitialMagnification','fit');

% iterative threshold method
binary_image = gray2binary_iterative(original_image);
figure(4);
imshow(binary_image, [], 'InitialMagnification','fit');

% Kittler
% bad performance
binary_image = gray2binary_kittler(original_image);
figure(6);
imshow(binary_image, [], 'InitialMagnification','fit');

% Bernsen
binary_image = gray2binary_bernsen(original_image, 7, 10, best_threshold);
figure(7);
imshow(binary_image, [], 'InitialMagnification','fit');

% Niblack
binary_image = gray2binary_niblack(original_image, 7, 0.01);
figure(8);
imshow(binary_image, [], 'InitialMagnification','fit'); 

% OTSU
[best_threshold, binary_image] = gray2binary_otsu(original_image);
figure(5);
imshow(binary_image, [], 'InitialMagnification','fit');

%% Determine an one-pixel thin image of the objects

%   255 -> 1; 0 -> 0
binary_image = binary_image > 0;

% Helditch
thin_image = thin_hilditch(binary_image);
figure(9);
imshow(thin_image, [], 'InitialMagnification','fit');

%%




