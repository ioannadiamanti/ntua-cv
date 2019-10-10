function [displ_x,displ_y] = displ(dx,dy)
thresh = 0.9;
energy = dx.^2+dy.^2;
energy = energy./max(energy(:));

energy = reshape(energy,1,[]);
index = find(energy > thresh);
displ_x = sum(dx(index))/length(index);

index = find(energy > thresh);
displ_y = sum(dy(index))/length(index);

end