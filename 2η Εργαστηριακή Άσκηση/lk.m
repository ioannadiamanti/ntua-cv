function [dx,dy] = lk (I1,I2,rho,epsilon,d_x0,d_y0)
n = 2*ceil(3*rho)+1;
Gp = fspecial('gaussian', n, rho);

dx = d_x0;
dy = d_y0;
[I1x,I1y] = gradient(im2double(I1));

for i=1:7
[x0,y0] = meshgrid(1:size(I1,2),1:size(I1,1));
l1 = min(size(dx,1),size(x0,1));
l2 = min(size(dy,1),size(y0,1));
dx = dx(1:l1,:);
dy = dy(1:l2,:);
I11 = interp2(im2double(I1),x0+dx,y0+dy,'linear',0);
[x0,y0] = meshgrid(1:size(I1x,2),1:size(I1x,1));
A1 = interp2(I1x,x0+dx,y0+dy,'linear',0);
[x0,y0] = meshgrid(1:size(I1y,2),1:size(I1y,1));
A2 = interp2(I1y,x0+dx,y0+dy,'linear',0);
E = im2double(I2)-I11;

c11 = imfilter(A1.^2,Gp,'conv')+epsilon;
c12 = imfilter(A1.*A2,Gp,'conv');
c21 = c12;
c22 = imfilter(A2.^2,Gp,'conv')+epsilon;

d1 = imfilter(A1.*E,Gp,'conv');
d2 = imfilter(A2.*E,Gp,'conv');

detc = c11.*c22 - c12.*c21;

ux = (c22.*d1-c21.*d2)./detc;
uy = (-c12.*d1+c11.*d2)./detc;

dx = dx+ux;
dy = dy+uy;
end
dx = flipud(dx);
dy = flipud(dy);
end