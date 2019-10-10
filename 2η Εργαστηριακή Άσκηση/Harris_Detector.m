function points = Harris_Detector(I,sigma,r,k)

Is = imgaussfilt3(I,sigma);


Kernelx = [-1 0 1];
Isx = convn(Is,Kernelx,'same');
Kernely = [-1; 0; 1;];
Isy = convn(Is,Kernely,'same');
Kernelt = zeros(1,1,3);
Kernelt(2,2,2) = -1;
Kernelt(1,1,3) = 1;
Ist= convn(Is,Kernelt,'same');

J11 = imgaussfilt3(Isx.*Isx,r);
J12 = imgaussfilt3(Isx.*Isy,r);
J13 = imgaussfilt3(Isx.*Ist,r);
J21 = J12;
J22 = imgaussfilt3(Isy.*Isy,r);
J23 = imgaussfilt3(Isy.*Ist,r);
J31 = J13;
J32 = J23;
J33 = imgaussfilt3(Ist.*Ist,r);

H = J11.*(J22.*J33-J23.^2)-J12.*(J21.*J33-J31.*J23) + J13.*(J21.*J32-J31.*J22) - k.*((J11+J22+J33).^3);

[~,index] = sort(H(:),'descend');
%Discard first 100 elements as artefacts
index = index(101:600);
[points(:,2),points(:,1),points(:,4)] = ind2sub(size(H),index);
points(:,3) = sigma;

end