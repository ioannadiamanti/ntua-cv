%1.2 Υλοποίηση Αλγορίθμων ανίχνευσης ακμών
function D = EdgeDetect(I,sigma,theta,LaplacType)

%1.2.1
n = ceil(3*sigma)*2+1;
G = fspecial('gaussian',n,sigma);
LoG = fspecial('log',n,sigma);

%1.2.2
A=[0 1 0;1 0 1;0 1 0;];
B = strel(A);
Is = imfilter(I,G,'conv');
if LaplacType == 0
    L = imfilter(I,LoG,'conv');
else
    L = imdilate(Is,B) + imerode(Is,B) - 2.*Is;
end


%1.2.3
%a)
%X = (L>=0)
X=im2bw(L,0);


%b)
Y = imdilate(X,B)-imerode(X,B);

%1.2.4
[r,c]=size(Y);
D = zeros(r,c);
[Isx,Isy] = gradient(double(Is));
m = hypot(Isx,Isy);
const = theta*max(m(:));
for i=1:r
    for j=1:c
        if m(i,j)>const && Y(i,j) == 1 
            D(i,j) = 1;
        end
    end
end
end