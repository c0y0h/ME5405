%% Display the original image on screen.

data = importdata("chromo.txt");
original_image = decode(data);
figure(1);
imshow(original_image, [], 'InitialMagnification','fit');

%%  Filter
% imhist(original_image, 32);
histgram = histgram_transform(original_image, 32);
figure(2);
bar(histgram);

%   median filter
img_afterFilter = medianFilter(original_image, 3);
figure(3);
imshow(img_afterFilter, [], 'InitialMagnification','fit');

histgram = histgram_transform(img_afterFilter, 32);
figure(4);
bar(histgram);
%%
%   compute the Fourier spectrum using fft2
[m, n] = size(original_image);
F = fft2(double(original_image), m, n);
F_shift = fftshift(F);
figure(2);
imshow(log(F_shift + 1), []);

%% Threshold the image and convert it into binary image.

% naive mannualy setting
binary_image = gray2binary_naive(original_image, 20);
figure(2);
imshow(binary_image, [], 'InitialMagnification','fit');

% %%
% % global mean threshold
% binary_image = gray2binary_globalMeanThreshold(original_image);
% figure(3);
% imshow(binary_image, [], 'InitialMagnification','fit');

% iterative threshold method
binary_image = gray2binary_iterative(original_image);
figure(4);
imshow(binary_image, [], 'InitialMagnification','fit');

% OTSU
[best_threshold, binary_image] = gray2binary_otsu(original_image, 32);
figure(5);
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

% 最终选用 OTSU
[best_threshold, binary_image] = gray2binary_otsu(original_image, 32);
figure(9);
imshow(binary_image, [], 'InitialMagnification','fit');

%% Determine an one-pixel thin image of the objects

% Helditch
thin_image = thin_hilditch(binary_image);
figure(10);
imshow(thin_image, [], 'InitialMagnification','fit');

% Zhang Suen
thin_image = thin_zhangSuen(binary_image);
figure(11);
imshow(thin_image, [], 'InitialMagnification','fit');

% Rosenfeld
thin_image = thin_rosenfeld(binary_image);
figure(12);
imshow(thin_image, [], 'InitialMagnification','fit');

% Look for table
thin_image = thin_lookForTable(binary_image);
figure(13);
imshow(thin_image, [], 'InitialMagnification','fit');

% 最后选用 Rosenfeld
thin_image = thin_rosenfeld(binary_image);
figure(14);
imshow(thin_image, [], 'InitialMagnification','fit');

%% Determine the outline(s)

%   Roberts detector
outline_image = detector_roberts(binary_image);
figure(15);
imshow(outline_image, [], 'InitialMagnification','fit');

%   Sobel detector
sobel_threshold = 3.7;
outline_image = detector_sobel(binary_image, sobel_threshold);
figure(16);
imshow(outline_image, [], 'InitialMagnification','fit');

%`  Prewitt detector
prewitt_threshold = 2.8;
outline_image = detector_prewitt(binary_image, prewitt_threshold);
figure(17);
imshow(outline_image, [], 'InitialMagnification','fit');

%   Laplace detector
%   乘一个系数效果才好
laplace_threshold = 2.8;
binary_image = binary_image * 31;
outline_image = detector_laplace(binary_image, laplace_threshold);
figure(18);
imshow(outline_image, [], 'InitialMagnification','fit');

%%
img_afterFilter = gaussianFilter(original_image, 5, 0.5);
figure(19);
imshow(img_afterFilter, [], 'InitialMagnification','fit');

[best_value, binary_image] = gray2binary_otsu(img_afterFilter, 32);
figure(20);
imshow(binary_image, [], 'InitialMagnification','fit');

%   Canny detector
%   binary_image, GK_size, GK_sigma, Kxy_size, lowTh, ratio
[outline_image1, outline_image2, outline_image3] = detector_canny(binary_image, 3, 1, 3, 0.8, 2);
% subplot(3, 1, 1);
figure(21);
imshow(outline_image1, [], 'InitialMagnification','fit');
% subplot(3, 1, 2);
figure(22);
imshow(outline_image2, [], 'InitialMagnification','fit');
% subplot(3, 1, 3);
figure(23);
imshow(outline_image3, [], 'InitialMagnification','fit');

% matlab自带的 canny 边缘检测函数，效果比自己写的好太多了
ed = edge(binary_image, 'canny', 0.5);
figure(24);
imshow(ed, [], 'InitialMagnification','fit');


%%  Label the different objects.

%   region seeds growing
%   seen as pre-processing
%   mannually choose seeds, can be designed as integraction
binary_image = rsg_process(binary_image);
figure(25);
imshow(binary_image, [], 'InitialMagnification','fit');

%   classical connected components algorithm
label_matrix = label_classical(binary_image);
% figure(25);
% imshow(label_matrix, [], 'InitialMagnification','fit');

label_img = label2rgb(label_matrix, 'jet', 'w', 'shuffle');
figure(26);
imshow(label_img, [], 'InitialMagnification','fit');

%   rsg label
label_matrix = label_rsg(binary_image);
label_img = label2rgb(label_matrix, 'jet', 'w', 'shuffle');
figure(27);
imshow(label_img, [], 'InitialMagnification','fit');

% %   seperate
% [img_num, s] = img_seperate(label_matrix);
% for i = 1 : img_num
%     figure(27+i);
%     imshow(s(i).Image, [], 'InitialMagnification','fit');
% end

%%  Rotate the original image by 30 degrees, 60 degrees and 90 degrees respectively.













