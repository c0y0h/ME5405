%% 1. Display the original image on screen.

fid = fopen('chromo.txt');
lf = char(10);
cr = char(13);
A = fscanf(fid,[cr lf '%c'],[64,64]);
fclose(fid);
A = A';
A(isletter(A))= A(isletter(A))-55;
A(A>='0'&A<='9')=A(A>='0'&A<='9')-48;
A=uint8(A);
imwrite(A,'image.bmp');
figure;
imshow(A)

%% 2. Create a binary image using thresholding.

BW=imbinarize(A);
imwrite(BW,'image1.bmp');
figure;
subplot(1,2,1),imshow('image.bmp'),title('Initial image');
subplot(1,2,2),imshow('image1.bmp'),title('Binary image');


%% 3. Determine a one-pixel thin image of the characters.

se=strel('disk',1);
th=~imdilate(~BW,se);
th=~bwmorph(~th,'thin',Inf);


%% 4. Determine the outline(s) of characters of the image.

ED1=~edge(BW,'Sobel');
ED2=~edge(BW,'Prewitt');
ED3=~edge(BW,'canny');
figure;
subplot(1,3,1),imshow('image.bmp'),title('Initial image');
subplot(1,3,2),imshow('image1.bmp'),title('Binary image');
subplot(1,3,3),imshow(th),title('Thin binary image');
figure;
subplot(1,3,1),imshow(ED1),title('Edge1 of Sobel');
subplot(1,3,2),imshow(ED2),title('Edge2 of Prewitt');
subplot(1,3,3),imshow(ED3),title('Edge3 of canny');

%% 5. Label the different objects（4-connectivity and 8-connectivity）

L = bwlabel(A,4);
L = bwlabel(A,8);
figure;
imshow(L),title('label')