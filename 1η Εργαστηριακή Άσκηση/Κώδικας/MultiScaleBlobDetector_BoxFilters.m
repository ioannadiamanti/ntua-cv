%2.5.4 -Πολυκλιμακωτή Ανίνχνευση Blobs με Box Filters
%2.4.1
function res = MultiScaleBlobDetector_BoxFilters(I,sigma,theta,s,N)
sigmas = zeros(1,N);
for i=1:N
    sigmas(i) = sigma*s^(i-1);
    coord = BlobDetector_BoxFilters(I,sigmas(i),theta);
    [m,l] = size(coord);
    for x=1:m
        for y=1:l
            coords(x,y,i)=coord(x,y);
        end
    end
end


for i=1:N
    n = ceil(3*sigmas(i))*2+1;
    Gs = fspecial('gaussian',n,sigmas(i));
    Is = imfilter(I,Gs,'conv');
    [Fx,Fy] = gradient(double(Is));
    [~,Lyy] = gradient(Fy);
    [Lxx,~] = gradient(Fx);
    LoGs(:,:,i) = abs(Lxx+Lyy).*(sigmas(i)^2);
end

l=1;
for i=1:size(coords,1)
        if coords(i,1,1) >0 && coords(i,2,1)>0
            if LoGs(coords(i,2,1),coords(i,1,1),1)> LoGs(coords(i,2,1),coords(i,1,1),2)
                res(l,1)=coords(i,1,1);
                res(l,2)=coords(i,2,1);
                res(l,3)=coords(i,3,1);
                l=l+1;
            end
        end
end
        
for k=2:N-1
    for i=1:size(coords,1)
        if coords(i,1,k)>0 && coords(i,2,k)>0
            if LoGs(coords(i,2,k),coords(i,1,k),k)> LoGs(coords(i,2,k),coords(i,1,k),k-1) && LoGs(coords(i,2,k),coords(i,1,k),k)> LoGs(coords(i,2,k),coords(i,1,k),k+1)
                res(l,1)=coords(i,1,k);
                res(l,2)=coords(i,2,k);
                res(l,3)=coords(i,3,k);
                l=l+1;
            end
        end
    end
end

for i=1:size(coords,1)
        if coords(i,1,N ) >0 && coords(i,2,N)>0
            if LoGs(coords(i,2,N),coords(i,1,N),N)> LoGs(coords(i,2,N),coords(i,1,N),N-1)
                res(l,1)=coords(i,1,N);
                res(l,2)=coords(i,2,N);
                res(l,3)=coords(i,3,N);
                l=l+1;
            end
        end
end
end