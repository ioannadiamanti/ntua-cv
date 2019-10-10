function [dx,dy] = lk_multiscale(I1,I2,rho,epsilon,d_x0,d_y0,N)

dx = d_x0;
dy = d_y0;

s = 3;
ns=ceil(3*s)*2+1;
Gs = fspecial('gaussian',ns,s);

cellI1 = cell(N,1);
cellI2 = cell(N,1);
cellI1{1} = I1;
cellI2{1} = I2;
for i = 2:N
    tempI1 = imfilter(cellI1{i-1},Gs,'conv');
    tempI2 = imfilter(cellI2{i-1},Gs,'conv');
    cellI1{i} = impyramid(tempI1,'reduce');
    cellI2{i} = impyramid(tempI2,'reduce');
end

for i=N:-1:1
    if i<N
        dx = 2*imresize(dx,2);
        dy = 2*imresize(dy,2);
    end
    [dx,dy] = lk(cellI1{i},cellI2{i},rho,epsilon,dx,dy);
end
end