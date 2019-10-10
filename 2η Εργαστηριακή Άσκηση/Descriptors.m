function Histograms = Descriptors(I,points)

grid = [3 3];
bins=4;
rho = 3;
epsilon = 0.05;
dx0=0;
dy0=0;

Histograms = zeros(size(points,1),2*grid(1)*grid(2)*bins);
[Ix1,Iy1]=gradient(im2double(I));

for i=1:size(points,1)
    Ix = Ix1(:,:,points(i,4));
    Iy = Iy1(:,:,points(i,4));
    x = max(points(i,1)-4*points(i,3),1):min(points(i,1)+4*points(i,3),size(I,2));
    y = max(points(i,2)-4*points(i,3),1):min(points(i,2)+4*points(i,3),size(I,1));
    HOG = OrientationHistogram(Ix(y,x),Iy(y,x),bins,grid);
    [dx,dy] = lk(I(y,x,min(points(i,4),199)),I(y,x,min(points(i,4),199)+1),rho,epsilon,dx0,dy0);
    HOF = OrientationHistogram(dx,dy,bins,grid);
    Histograms(i,1:grid(1)*grid(2)*bins) = HOG;
    Histograms(i,grid(1)*grid(2)*bins+1:2*grid(1)*grid(2)*bins) = HOF;
end

end