clc;
close all;
clear all;

p = which('CV2');
idcs = strfind(p,'\');
p = p(1:idcs(end)-1);
cd(p);
addpath(genpath('part1'));
addpath(genpath('GreekSignLanguage\GSLframes'));
%%
%Μέρος 1ο
frame1 = imread('1.png');

load('skinSamplesRGB.mat','skinSamplesRGB');
samples = rgb2ycbcr(skinSamplesRGB);
cb = im2double(samples(:,:,2));
cr = im2double(samples(:,:,3));

mu = [mean2(cb) mean2(cr)];
sigma = cov(cb,cr);


BoundingBox = round(fd(frame1,mu,sigma));
BoundingBox(1) = BoundingBox(1)-5;
BoundingBox(2) = BoundingBox(2)-5;
BoundingBox(3) = BoundingBox(3)+5;
BoundingBox(4) = BoundingBox(4)+5;

figure(4);
imshow(frame1);
hold on;
rectangle('Position',BoundingBox,...
    'EdgeColor','g', 'LineWidth', 3);
hold off;
title('Bounding Box in Frame 1');

rho = 3;
epsilon = 0.05;
dx0=0;
dy0=0;

BoundingBoxes = zeros(4,72);
BoundingBoxes(:,1) = BoundingBox;
frame1 = frame1(BoundingBox(2):BoundingBox(2) + BoundingBox(4),BoundingBox(1):BoundingBox(1)+ BoundingBox(3),1);
dx = zeros(size(frame1,1),size(frame1,2),72);
dy = zeros(size(frame1,1),size(frame1,2),72);
for n=2:72
  frame2 = imread(sprintf('%01d.png',n));
  frame22 = frame2(BoundingBoxes(2,n-1):BoundingBoxes(2,n-1)+ BoundingBoxes(4,n-1),BoundingBoxes(1,n-1):BoundingBoxes(1,n-1)+BoundingBoxes(3,n-1),1);
  [dx(:,:,n-1),dy(:,:,n-1)] = lk(frame1,frame22,rho,epsilon,dx0,dy0);
  [displ_x,displ_y] = displ(dx(:,:,n-1),dy(:,:,n-1));
  BoundingBoxes(:,n) = round(BoundingBoxes(:,n-1) - [displ_x;displ_y;0;0]);
  frame1=frame2;
  frame1 = frame1(BoundingBoxes(2,n):BoundingBoxes(2,n)+ BoundingBoxes(4,n),BoundingBoxes(1,n):BoundingBoxes(1,n)+BoundingBoxes(3,n),1);
end

figure(5);
d_x_r = imresize(dx(:,:,65),0.5);
d_y_r = imresize(dy(:,:,65),0.5);
quiver(-d_x_r,d_y_r);
title('Optical Flow (Frame 65)');
axis equal;

figure(6);
energy = flipud(dx(:,:,65).^2+dy(:,:,65).^2);
imshow(energy);
title('Optical Flow Energy (Frame 65)');

%Display Video
for i=1:72
frame = imread(sprintf('%01d.png',i));
imshow(frame);
hold on;
rectangle('Position',BoundingBoxes(:,i),...
'EdgeColor','g', 'LineWidth', 3);
hold off;
% fname = 'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Σ\Όραση Υπολογιστών\2η Εργαστηριακή ’σκηση\video';
% filename = sprintf('%01d.png',i);
% saveas(gcf,fullfile(fname,filename));
pause(0.1);
end

%%
%Μέρος 2ο
addpath(genpath('part2'));
addpath(genpath('samples'));
addpath(genpath('boxing'));
addpath(genpath('running'));
addpath(genpath('walking'));

B1 = readVideo('person16_boxing_d4_uncomp.avi',200,0);
B2 = readVideo('person21_boxing_d1_uncomp.avi',200,0);
B3 = readVideo('person25_boxing_d4_uncomp.avi',200,0);

R1 = readVideo('person09_running_d1_uncomp.avi',200,0);
R2 = readVideo('person15_running_d1_uncomp.avi',200,0);
R3 = readVideo('person23_running_d3_uncomp.avi',200,0);

W1 = readVideo('person07_walking_d2_uncomp.avi',200,0);
W2 = readVideo('person14_walking_d2_uncomp.avi',200,0);
W3 = readVideo('person20_walking_d3_uncomp.avi',200,0);

PointsB1 = Harris_Detector(B1,2,1.5,0.01);
PointsB2 = Harris_Detector(B2,2,1.5,0.01);
PointsB3 = Harris_Detector(B3,2,1.1,0.01);

PointsR1 = Harris_Detector(R1,2,1.5,0.01);
PointsR2 = Harris_Detector(R2,2,1.5,0.01);
PointsR3 = Harris_Detector(R3,2,1.5,0.01);

PointsW1 = Harris_Detector(W1,2,1.5,0.01);
PointsW2 = Harris_Detector(W2,2,1.5,0.02);
PointsW3 = Harris_Detector(W3,2,1.5,0.01);

% Uncomment to use Gabor
% PointsB1 = Gabor_Detector(B1,2,2.5);
% PointsB2 = Gabor_Detector(B2,2,2.5);
% PointsB3 = Gabor_Detector(B3,2,1.1);
% 
% PointsR1 = Gabor_Detector(R1,2,1.1);
% PointsR2 = Gabor_Detector(R2,2,1.1);
% PointsR3 = Gabor_Detector(R3,2,1.1);
% 
% PointsW1 = Gabor_Detector(W1,2,2.2);
% PointsW2 = Gabor_Detector(W2,2,2.2);
% PointsW3 = Gabor_Detector(W3,2,2.5);

DB1 = Descriptors(B1,PointsB1);
DB2 = Descriptors(B2,PointsB2);
DB3 = Descriptors(B3,PointsB3);

DR1 = Descriptors(R1,PointsR1);
DR2 = Descriptors(R2,PointsR2);
DR3 = Descriptors(R3,PointsR3);

DW1 = Descriptors(W1,PointsW1);
DW2 = Descriptors(W2,PointsW2);
DW3 = Descriptors(W3,PointsW3);

Histograms = [DB1; DB2; DB3; DR1; DR2; DR3; DW1; DW2; DW3];
[~,C] = kmeans(Histograms,20);

bincounts = zeros(9,20);
bincounts(1,:) = BoVW(DB1,C);
bincounts(2,:) = BoVW(DB2,C);
bincounts(3,:) = BoVW(DB3,C);

bincounts(4,:) = BoVW(DR1,C);
bincounts(5,:) = BoVW(DR2,C);
bincounts(6,:) = BoVW(DR3,C);

bincounts(7,:) = BoVW(DW1,C);
bincounts(8,:) = BoVW(DW2,C);
bincounts(9,:) = BoVW(DW3,C);


Z = linkage(bincounts, 'average', 'distChiSq');
labels = ['Box_1'; 'Box_2'; 'Box_3'; 'Run_1'; 'Run_2'; 'Run_3';'Wlk_1'; 'Wlk_2'; 'Wlk_3'];
figure(6);
dendrogram(Z, 'Labels', labels);
title('Dendrogram');