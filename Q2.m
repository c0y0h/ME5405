%%  Display the original image on screen.
original_image = imread("hello_world.jpg");
original_image = rgb2gray(original_image);
figure(1);
imshow(original_image, [], 'InitialMagnification','fit');

%%  Create an image which is a sub-image of the original image comprising the middleline – HELLO, WORLD.
words_image = original_image(1/3*size(original_image, 1) : 2/3*size(original_image, 1), 5 : 1/2*size(original_image, 2));
figure(2);
imshow(words_image, [], 'InitialMagnification','fit');

%%  Create a binary image from Step 2 using thresholding.
[best_threshold, binary_image] = gray2binary_otsu(words_image, 256);
binary_image = 1 - binary_image;
figure(3);
imshow(binary_image, [], 'InitialMagnification','fit');

% binary_image = gray2binary_bernsen(words_image, 7, 10, best_threshold);
% binary_image = 1 - binary_image;
% figure(4);
% imshow(binary_image, [], 'InitialMagnification','fit');

binary_image = gray2binary_naive(words_image, 100);
binary_image = 1 - binary_image;
figure(4);
imshow(binary_image, [], 'InitialMagnification','fit');

% binary_image = gray2binary_niblack(words_image, 9, 0.1);
% binary_image = 1 - binary_image;
% figure(5);
% imshow(binary_image, [], 'InitialMagnification','fit');

% binary_image = gray2binary_kittler(words_image);
% binary_image = 1 - binary_image;
% figure(5);
% imshow(binary_image, [], 'InitialMagnification','fit');


%%  Determine a one-pixel thin image of the characters.

thin_image = thin_zhangSuen(binary_image);
figure(5);
imshow(thin_image, [], 'InitialMagnification','fit');

thin_image = thin_rosenfeld(binary_image);
figure(6);
imshow(thin_image, [], 'InitialMagnification','fit');

%%  Determine the outline(s) of characters of the image.
sobel_threshold = 3.7;
outline_image = detector_sobel(binary_image, sobel_threshold);
figure(7);
imshow(outline_image, [], 'InitialMagnification','fit');

%`  Prewitt detector
prewitt_threshold = 2.8;
outline_image = detector_prewitt(binary_image, prewitt_threshold);
figure(8);
imshow(outline_image, [], 'InitialMagnification','fit');

% matlab自带的 canny 边缘检测函数
ed = edge(binary_image, 'canny', 0.5);
figure(9);
imshow(ed, [], 'InitialMagnification','fit');

%   Roberts detector
outline_image = detector_roberts(binary_image);
figure(10);
imshow(outline_image, [], 'InitialMagnification','fit');

% %   Laplace
% laplace_threshold = 2.8;
% binary_image = binary_image * 255;
% outline_image = detector_laplace(binary_image, laplace_threshold);
% figure(10);
% imshow(outline_image, [], 'InitialMagnification','fit');

%%  Segment the image to separate and label the different characters.

%   classical connected components algorithm
label_matrix = label_classical(binary_image);
label_img = label2rgb(label_matrix, 'jet', 'w', 'shuffle');
figure(11);
imshow(label_img, [], 'InitialMagnification','fit');

%   region seeds growing
label_matrix = label_rsg(binary_image);
label_img = label2rgb(label_matrix, 'jet', 'w', 'shuffle');
figure(12);
imshow(label_img, [], 'InitialMagnification','fit');
%%
%   seperate
[img_num, s] = img_seperate(label_matrix);
for i = 1 : img_num
    figure(12+i);
    imshow(s(i).Image, [], 'InitialMagnification','fit');
end

%% Train the (conventional) unsupervised classification method of your choice 
% (i.e., self-ordered maps (SOM), k-nearest neighbors (kNN), or support vector machine (SVM)) to
% recognize the different characters ("H", "E”, “L”, “O”, “W”, “R”, “D”). You should
% use 75% of the dataset to train your classifier, and the remaining 25% for validation
% (testing). Then, test your trained classifier on each characters in image 1, reporting
% the final classification results. 

train_knn(5);






























