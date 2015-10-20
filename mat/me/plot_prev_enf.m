
%filename = sprintf('../../data/Grid_B/Power_recordings/Train_Grid_B_P9.wav') ;

%Grid = 'D';

grids = ['A','B','C','D','E','F','G','H'];
%grids = ['B','D','E','F','G','H'];
count  = 3; 
All_F = [[]];

k = 1;

for Grid = grids
    
Fx = [];
%for i = 1:count
       filename = sprintf('Grid%s_enf.mat',Grid); 
       %enf_extract_me;
       if exist(filename,'file')==2
           load(filename,'F');
           Fx = [Fx F];
           length(F)
       end
       %   file_to_save = sprintf('../feature_data/%s_P%d.mat',Grid,i);
       %   final;
       %end
%end


figure(k);
plot(Fx);
title(Grid);

if abs(mean(Fx)-50)<abs(mean(Fx)-60)
    ylim([49 52]);
else
    ylim([59.8 60.2]);
end

k = k + 1;

end
