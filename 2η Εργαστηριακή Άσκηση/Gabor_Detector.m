function points = Gabor_Detector(I,sigma,taf)

ns = ceil(3*sigma)*2+1;
Gs = fspecial('gaussian',ns,sigma);
Is = zeros(size(I,1),size(I,2),size(I,3));

for i=1:size(I,3)
    Is(:,:,i) = imfilter(I(:,:,i),Gs,'conv');
end

w = 4/taf;
t = -2*taf:2*taf;

hev = -cos(2*pi*t*w).*exp(-t.^2/(2*taf^2));
hev = hev/norm(hev,1);
hod = -sin(2*pi*t*w).*exp(-t.^2/(2*taf^2));
hod = hod/norm(hod,1);

hev_t = zeros(1,1,size(hev,2));
hev_t(1,1,:) = hev;

hod_t = zeros(1,1,size(hod,2));
hod_t(1,1,:) = hod;

Iev = convn(Is,hev_t,'same');
Iod = convn(Is,hod_t,'same');

H = Iev.^2+Iod.^2;

[~,index] = sort(H(:));
%Discard first 100 elements as artefacts
index = index(101:300);
[points(:,2),points(:,1),points(:,4)] = ind2sub(size(H),index);
points(:,3) = sigma;

end