function BoundingBox = fd(frame,mu,sigma)
frame = im2double(rgb2ycbcr(frame));
frame1_cb = frame(:,:,2);
frame1_cr = frame(:,:,3);
frame1_cb_vector = reshape(frame1_cb,[],1);
frame1_cr_vector = reshape(frame1_cr,[],1);

%Plot skin texture propability density distribution
%Create Cb/Cr 2D space
X=linspace(0,1,255);
Y=linspace(0,1,255);
[mX, mY]=meshgrid(X,Y);
%Calculate propability density for all space
Z=mvnpdf([mX(:) mY(:)],mu,sigma);
Z=reshape(Z,length(Y),length(X));

figure(1);
subplot(1,2,1);
mesh(X,Y,Z);
xlabel 'Cb';
ylabel 'Cr';
zlabel 'Propability Density';
subplot(1,2,2);
X=linspace(mu(1)-0.1,mu(1)+0.1,100);
Y=linspace(mu(2)-0.1,mu(2)+0.1,100);
[mX, mY]=meshgrid(X,Y);
Z=mvnpdf([mX(:) mY(:)],mu,sigma);
Z=reshape(Z,length(Y),length(X));
subplot(1,2,2);
mesh(X,Y,Z);
xlabel 'Cb';
ylabel 'Cr';
zlabel 'Propability Density';


P = mvnpdf([frame1_cb_vector(:) frame1_cr_vector(:)],mu,sigma);
P = reshape(P,size(frame1_cb,1),size(frame1_cb,2));
P = P./max(P(:));
thresh = 0.1;
B = (P>thresh);

figure(2);
imshow(B);
title('Binary Image of Skin (frame 1)');

A = strel('disk',2);
O = imopen(B,A);
A = strel('disk',10);
C = imclose(O,A);


figure(3);
imshow(C);
title('Binary Image of Skin after Morpological Filtering (frame 1)');

L = logical(C);
stats = regionprops(L);
t = cat(1,stats.Area);
index = find(t == max(t(:)));
BoundingBox = cat(1,stats(index).BoundingBox);

end