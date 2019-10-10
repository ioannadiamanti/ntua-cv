%2.1 Ανίχνευση Γωνιών
function coord = CornerDetect(I,sigma,r,k,theta)

%2.1.1
ns = ceil(3*sigma)*2+1;
nr = ceil(3*r)*2+1;
Gs = fspecial('gaussian',ns,sigma);
Gr = fspecial('gaussian',nr,r);
Is = imfilter(I,Gs,'conv');
[Isx,Isy] = gradient(double(Is));
J1 = imfilter(Isx.*Isx,Gr,'conv');
J2 = imfilter(Isx.*Isy,Gr,'conv');
J3 = imfilter(Isy.*Isy,Gr,'conv');


%2.1.2
lamdaplus = 1/2*(J1+J3+sqrt((J1-J3).^2+4.*(J2.^2)));
lamdaminus = 1/2*(J1+J3-sqrt((J1-J3).^2+4.*(J2.^2)));
%figure(7);
%subplot(1,2,1);
%imshow(lamdaplus);
%title('Lamda Plus');

%subplot(1,2,2);
%imshow(lamdaminus);
%title('Lamda Minus');

%saveas(gcf,'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\lamdas.png');

%2.1.3
R = lamdaplus.*lamdaminus - k.*((lamdaminus+lamdaplus).^2);
%figure(8);
%subplot(1,1,1);
%imshow(R);
%title('R')

%saveas(gcf,'C:\Users\Ioanna\Documents\ΣΗΜΜΥ\Όραση Υπολογιστών\1η Εργαστηριακή ’σκηση\R.png');

%Σ1
B_sq = strel('square',ns);
Cond1 = (R == imdilate(R,B_sq));

%Σ2
          
Cond2 = (R > theta*max(R(:)));

temp = Cond1 & Cond2;
[r,c] = size(temp);

k=1;

for i=1:r
    for j=1:c
        if temp(i,j) == 1
            coord(k,1) = j;
            coord(k,2) = i;
            coord(k,3) = sigma;
            k = k +1;
        end
    end
end

end