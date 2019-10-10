%2.3 Ανίχνευση Blobs
%2.3.1
function blobs = BlobDetector(I,sigma,theta)

n = ceil(3*sigma)*2+1;
%Sunflower Image
G = fspecial('gaussian',n,sigma);
Is = imfilter(I,G,'conv');
[Isx,Isy] = gradient(double(Is));
[Isxx,~] = gradient(Isx);
[Isxy,Isyy] = gradient(Isy);
DetI = Isxx.*Isyy - Isxy.*Isxy;

%figure(15);
%subplot(1,2,1);
%imshow(DetI);
%2.3.2

%Σ1
B_sq = strel('square',n);
Cond1 = (DetI == imdilate(DetI,B_sq));

%Σ2
          
Cond2 = (DetI > theta*max(DetI(:)));

temp = Cond1 & Cond2;
[r,c] = size(temp);

k=1;

for i=1:r
    for j=1:c
        if temp(i,j) == 1
            blobs(k,1) = j;
            blobs(k,2) = i;
            blobs(k,3) = sigma;
            k = k +1;
        end
    end
end
end