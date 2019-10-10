function blobs = BlobDetector_BoxFilters(I,sigma,theta)

[Dxx,Dyy,Dxy] = BoxFilters(I,sigma);

%2.5.3
R = Dxx.*Dyy-(0.9*Dxy).^2;
n = ceil(3*sigma)*2+1;

%figure(15);
%subplot(1,2,2);
%imshow(R);


%Ó1
B_sq = strel('square',n);
Cond1 = (R == imdilate(R,B_sq));

%Ó2
          
Cond2 = (R > theta*max(R(:)));

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
