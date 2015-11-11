
%% plot enf signal specified by grids name

grids = ['A','B','C','D','E','F','G','H','I'];

grids  = ['C'];

k = 2; % simple counter

for Grid = grids
    
Fx = [];

for i=1:k
    
       filename = sprintf('grid2000/%s%d.mat',Grid,i); % filename of the enf signal
       
       if exist(filename,'file')==2
           load(filename,'F');
           Fx = [Fx F];
           %length(F)
       end
       
end
      
figure;
plot(Fx);
title(Grid);

if abs(mean(Fx)-50)<abs(mean(Fx)-60)
    ylim([49 52]);
else
    ylim([59.8 60.2]);
end

%k = k + 1;
title(Grid);
%filename = sprintf('figure/%s.fig',Grid);
%savefig(filename);

end
