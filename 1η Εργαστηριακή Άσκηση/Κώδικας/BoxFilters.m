%2.5 Επιτάχυνση με χρήση Box Filters και ολοκληρωτικών εικόνων

function [Dxx,Dyy,Dxy] = BoxFilters(I,sigma)
%2.5.1
I = im2double(I);
Ir = cumsum(I,2);
U = cumsum(Ir,1);

%2.5.2
n = 2*ceil(3*sigma)+1;

[rows,columns] = size(I);

%Dxx
Dxx = zeros(rows,columns);
hxx = 4*floor(n/6)+1;
wxx = 2*floor(n/6)+1;
Uzp = padarray(U,[floor(hxx/2)+1 floor(wxx/2)+wxx+1],'both');
r1 = floor(hxx/2)+2;
c1 = floor(wxx/2)+wxx+2;
k=1;
m=1;
for i= r1:rows
    for j = c1:columns
        Dxx(i-r1+1,j-c1+1) = 3*(Uzp(i+floor(hxx/2),j-floor(wxx/2)-1) - Uzp(i-floor(hxx/2)-1,j-floor(wxx/2)-1) - Uzp(i+floor(hxx/2),j+floor(wxx/2)) + Uzp(i-floor(hxx/2)-1,j+floor(wxx/2))) - Uzp(i+floor(hxx/2),j-floor(wxx/2)-wxx-1) + Uzp(i-floor(hxx/2)-1,j-floor(wxx/2)-wxx-1) + Uzp(i+floor(hxx/2),j+floor(wxx/2)+wxx) - Uzp(i-floor(hxx/2)-1,j+floor(wxx/2)+wxx);
    end
end

%Dyy
Dyy = zeros(rows,columns);
hyy = 2*floor(n/6)+1;
wyy = 4*floor(n/6)+1;
Uzp = padarray(U,[floor(hyy/2)+hyy+1 floor(wyy/2)+1],'both');
r1 = floor(hyy/2)+hyy+2;
c1 = floor(wyy/2)+2;
for i = r1:rows
    for j= c1:columns
        Dyy(i-r1+1,j-c1+1) = 3*(Uzp(i-floor(hyy/2)-1,j+floor(wyy/2))-Uzp(i+floor(hyy/2),j+floor(wyy/2)) + Uzp(i+floor(hyy/2),j-floor(wyy/2)-1) - Uzp(i-floor(hyy/2)-1,j-floor(wyy/2)-1)) - Uzp(i-floor(hyy/2)-hyy-1,j+floor(wyy/2)) + Uzp(i-floor(hyy/2)-hyy-1,j-floor(wyy/2)-1) + Uzp(i+floor(hyy/2)+hyy,j+floor(wyy/2)) - Uzp(i+floor(hyy/2)+hyy,j-floor(wyy/2)-1);
    end
end

%Dxy
Dxy = zeros(rows,columns);
hxy = 2*floor(n/6)+1;
wxy = 2*floor(n/6)+1;
Uzp = padarray(U,[hxy+1 wxy+1],'both');
r1 = hxy+2;
c1 = wxy+2;
for i= r1:rows
    for j= c1:columns
        Dxy(i-r1+1,j-c1+1)= Uzp(i-1,j-1)-Uzp(i-hxy-1,j-1)-Uzp(i-1,j-wxy-1)+Uzp(i-hxy-1,j-wxy-1)-Uzp(i-1,j+wxy)+Uzp(i-hxy-1,j+wxy)+Uzp(i-1,j)-Uzp(i-hxy-1,j) - Uzp(i+hxy,j-1)+Uzp(i,j-1) + Uzp(i+hxy,j-wxy-1) - Uzp(i,j-wxy-1) + Uzp(i+hxy,j+wxy)-Uzp(i,j+wxy)-Uzp(i+hxy,j)+Uzp(i,j);
    end
end
end

