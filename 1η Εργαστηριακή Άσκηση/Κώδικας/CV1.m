clc;
close all;
%%
%Μέρος 1ο - Ανίχνευση ακμών σε γκρίζες εικόνες

%1.1 Δημιουργία εικόνων εισόδου
%Ερώτημα 1.1.1
I0 = imread('C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\cv19_lab1_parts1_2_material\edgetest_19.png');
figure(1);
subplot(1,1,1);
imshow(I0);
title('EdgeTest');

%Ερώτημα 1.1.2

ID=im2double(I0);
Imax = max(ID(:));
Imin = min(ID(:));

%i) PSNR = 20 dB
PSNR=20;
sn = (Imax-Imin)/(10^(PSNR/20));
I20 = imnoise(I0,'gaussian',0,double(sn));
figure(2);
subplot(1,1,1);
imshow(I20);
title('EdgeTest with PSNR=20dB');

%saveas(gcf,'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\I20dB.png');

%ii) PSNR = 10 dB
PSNR=10;
sn = (Imax-Imin)/(10^(PSNR/20));
I10 = imnoise(I0,'gaussian',0,double(sn));
figure(3);
subplot(1,1,1);
imshow(I10);
title('EdgeTest with PSNR=10dB');
%saveas(gcf,'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\I10dB.png');


%1.2 Υλοποίηση Αλγορίθμων ανίχνευσης ακμών
D1 = EdgeDetect(I20,1.5,0.3,0);
figure(4);
subplot(1,2,1);
imshow(D1);
title(' Linear Edge Detection- PSNR = 20dB');

D2 = EdgeDetect(I20,1.5,0.3,1);
subplot(1,2,2);
imshow(D2);
title(' Non Linear Edge Detection - PSNR = 20dB');

%saveas(gcf,'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\EdgeDetect-20dB.png');


D3 = EdgeDetect(I10,3.5,0.2,0);
figure(5);
subplot(1,2,1);
imshow(D3);
title(' Linear Edge Detection- PSNR = 10dB');

D4 = EdgeDetect(I10,3,0.2,1);
subplot(1,2,2);
imshow(D4);
title(' Non Linear Edge Detection - PSNR = 10dB');

%saveas(gcf,'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\EdgeDetect-10dB.png');

%1.3 Αξιολόγηση των αποτελεσμάτων ανίχνευσης ακμών

%1.3.1
A=[0 1 0;1 1 1;0 1 0;];
B = strel(A);
M = imdilate(I0,B)-imerode(I0,B);
T = im2bw(M,0.1);
figure(6);
imshow(T);
title('Edge Detection on the original image I0');

%saveas(gcf,'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\EdgeDetect-I0.png');

%1.3.2
Intersection = D1&T;
prtd1 = sum(Intersection(:))/sum(D1(:));
prdt1 = sum(Intersection(:))/sum(T(:));
C20_linear = (prtd1 + prdt1)/2;

Intersection = D2&T;
prtd2 = sum(Intersection(:))/sum(D2(:));
prdt2 = sum(Intersection(:))/sum(T(:));
C20_nonlinear = (prtd2 + prdt2)/2;

Intersection = D3&T;
prtd1 = sum(Intersection(:))/sum(D3(:));
prdt1 = sum(Intersection(:))/sum(T(:));
C10_linear = (prtd1 + prdt1)/2;

Intersection = D4&T;
prtd2 = sum(Intersection(:))/sum(D4(:));
prdt2 = sum(Intersection(:))/sum(T(:));
C10_nonlinear = (prtd2 + prdt2)/2;

%1.3.3


%1.4 Εφαρμογή των αλγορίθμων ανίχνευσης ακμών σε πραγματικές εικόνες

%1.4.1
V = imread('C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\cv19_lab1_parts1_2_material\venice_edges.png');
D3 = EdgeDetect(V,2,0.17,0);
figure(7);
subplot(2,1,1);
imshow(D3);
title('Linear Edge Detection On venice edges.png');

D4 = EdgeDetect(V,2,0.17,1);
subplot(2,1,2);
imshow(D4);
title('Non Linear Edge Detection On venice edges.png');

%saveas(gcf,'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\EdgeDetect-on venice.png');

%%
%Mέρος 2ο - Ανίχνευση σημείων ενδιαφέροντος

S = imread('C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\cv19_lab1_parts1_2_material\sunflowers19.png');
B = imread('C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\cv19_lab1_parts1_2_material\balloons19.png');

%2.1- Ανίχνευση Γωνιών

coord = CornerDetect(S(:,:,1),2,2.5,0.05,0.005);
figure(10);
subplot(1,2,1);
interest_points_visualization(S,coord);
title('Corner Detection On sunflowers19.png');

coord = CornerDetect(B(:,:,1),2,2.5,0.05,0.005);
figure(10);
subplot(1,2,2);
interest_points_visualization(B,coord);
title('Corner Detection On balloons19.png');


%2.2 - Πολυκλιμακωτή ανίχνευση γωνιών
res = MultiScaleCornerDetect(S(:,:,1),2,2.5,0.05,0.005,1.5,4); 
figure(11);
subplot(1,2,1);
interest_points_visualization(S,res);
title('Multiscale Corner Detection On sunflowers19.png');

res= MultiScaleCornerDetect(B(:,:,1),2,1.5,0.05,0.005,1.5,4);
figure(11);
subplot(1,2,2);
interest_points_visualization(B,res);
title('Multiscale Corner Detection On balloons19.png');

%saveas(gcf,'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\MultiscaleCornerDetect.png');

%2.3 Ανίχνευση Blobs
%2.3.1

%Sunflower Image

blobs1 = BlobDetector(S(:,:,1),2.5,0.1);
figure(12);
subplot(1,2,1);
interest_points_visualization(S,blobs1);
title('Blob Detection sunflowers19.png');

%Balloons Image
blobs2 = BlobDetector(B(:,:,1),6,0.2);
figure(12);
subplot(1,2,2);
interest_points_visualization(B,blobs2);
title('Blob Detection On balloons19.png');

%2.4 Πολυκλιμακωτή ανίχνευση Blobs
%2.4.1
%Sunflower image
multiblobs1 = MultiScaleBlobDetector(S(:,:,1),2,0.4,1.5,4);
figure(13);
subplot(1,2,1);
interest_points_visualization(S,multiblobs1);
title('Multi Scale Blob Detection On sunflowers19.png');

%Balloons image 
multiblobs2 = MultiScaleBlobDetector(B(:,:,1),2,0.3,1.5,4);
figure(13);
subplot(1,2,2);
interest_points_visualization(B,multiblobs2);
title('Multi Scale Blob Detection On balloons19.png');

%2.5 Επιτάχυνση με χρήση Box Filters και ολοκληρωτικών εικόνων

%2.5.3 - Ανίνχνευση Blobs με BoxFilters

%Sunflower image
blobs3 = BlobDetector_BoxFilters(S(:,:,1),2.5,0.1);
figure(14);
subplot(1,2,1);
interest_points_visualization(S,blobs3);
title('Blob Detection Using Box Filters sunflowers19.png');

%Balloons Image
blobs4 = BlobDetector_BoxFilters(B(:,:,1),6,0.1);
figure(14);
subplot(1,2,2);
interest_points_visualization(B,blobs4);
title('Blob Detection Using Box Filters On balloons19.png');

%2.5.4 -Πολυκλιμακωτή Ανίνχνευση Blobs με BoxFilters
%Sunflower image
multiblobs3 = MultiScaleBlobDetector_BoxFilters(S(:,:,1),2,0.05,1.5,4);
figure(15);
subplot(1,2,1);
interest_points_visualization(S,multiblobs3);
title('Multi Scale Blob Detection Using Box Filters On sunflowers19.png');

%Balloons image 
multiblobs4 = MultiScaleBlobDetector_BoxFilters(B(:,:,1),1.2,0.02,1.5,5);
figure(15);
subplot(1,2,2);
interest_points_visualization(B,multiblobs4);
title('Multi Scale Blob Detection Using Box Filters On balloons19.png');

%%
%Μέρος 3ο - Εφαρμογές σε ταίριασμα και κατηγοριοποίηση εικόνων με χρήση τοπικών περιγραφητών στα σημεία ενδιαφέροντος

addpath(genpath('C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\cv19_lab1_part3_material\detectors'));
addpath(genpath('C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\cv19_lab1_part3_material\descriptors'));
addpath(genpath('C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\cv19_lab1_part3_material\matching'));

%3.1 - Ταίριασμα εικόνων υπό περιστροφή και αλλαγή κλίμακας

%SURF
descriptor_func = @(I,points) featuresSURF(I,points);

%Corner Detector
detector_func = @(I) CornerDetect(I,2,2.5,.05,.005);
[scale_error1,theta_error1] = evaluation(detector_func,descriptor_func);

%Multiscale Corner Detector 
detector_func = @(I) MultiScaleCornerDetect(I,2,2.5,.05,.005,1.5,4);
[scale_error2,theta_error2] = evaluation(detector_func,descriptor_func);

%Blob Detector
detector_func = @(I) BlobDetector(I,2,.005);
[scale_error3,theta_error3] = evaluation(detector_func,descriptor_func);

%Multiscale Blob Detector
detector_func = @(I) MultiScaleBlobDetector(I,2,.005,1.5,4);
[scale_error4,theta_error4] = evaluation(detector_func,descriptor_func);

%Multiscale Blob Detector Using Box Filters
detector_func = @(I) MultiScaleBlobDetector_BoxFilters(I,2,.005,1.5,4);
[scale_error5,theta_error5] = evaluation(detector_func,descriptor_func);

%HOG
descriptor_func = @(I,points) featuresHOG(I,points);

%Corner Detector
detector_func = @(I) CornerDetect(I,2,2.5,.05,.005);
[scale_error6,theta_error6] = evaluation(detector_func,descriptor_func);

%Multiscale Corner Detector 
detector_func = @(I) MultiScaleCornerDetect(I,2,2.5,.05,.005,1.5,4);
[scale_error7,theta_error7] = evaluation(detector_func,descriptor_func);

%Blob Detector
detector_func = @(I) BlobDetector(I,2,.005);
[scale_error8,theta_error8] = evaluation(detector_func,descriptor_func);

%Multiscale Blob Detector
detector_func = @(I) MultiScaleBlobDetector(I,2,.005,1.5,4);
[scale_error9,theta_error9] = evaluation(detector_func,descriptor_func);

%Multiscale Blob Detector Using Box Filters
detector_func = @(I) MultiScaleBlobDetector_BoxFilters(I,2,.005,1.5,4);
[scale_error10,theta_error10] = evaluation(detector_func,descriptor_func);

%3.2 - Κατηγοριοποίηση Εικόνων
 
cd 'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\cv19_lab1_part3_material\classification'
%3.2.1 
 
%SURF
descriptor_func = @(I,points) featuresSURF(I,points);
 
%MultiScale Corner Detect
detector_func = @(I) MultiScaleCornerDetect(I,2,2.5,.05,.005,1.5,4);
features1 = FeatureExtraction(detector_func,descriptor_func);

%MultiScale Blob Detect
detector_func = @(I) MultiScaleBlobDetector(I,2,.005,1.5,4);
features2 = FeatureExtraction(detector_func,descriptor_func);

%MultiScale Blob Detect Using Box Filters
detector_func = @(I) MultiScaleBlobDetector_BoxFilters(I,2,.005,1.5,4);
features3 = FeatureExtraction(detector_func,descriptor_func);

%HOG
descriptor_func = @(I,points) featuresHOG(I,points);

%MultiScale Corner Detect
detector_func = @(I) MultiScaleCornerDetect(I,2,2.5,.05,.005,1.5,4);
features4 = FeatureExtraction(detector_func,descriptor_func);

%MultiScale Blob Detect
detector_func = @(I) MultiScaleBlobDetector(I,2,.005,1.5,4);
features5 = FeatureExtraction(detector_func,descriptor_func);

%MultiScale Blob Detect Using Box Filters
detector_func = @(I) MultiScaleBlobDetector_BoxFilters(I,2,.005,1.5,4);
features6 = FeatureExtraction(detector_func,descriptor_func);

%3.2.2
classification(features1);

classification(features2);

classification(features3);

classification(features4);

classification(features5);

classification(features6);