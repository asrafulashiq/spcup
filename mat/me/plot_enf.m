
%filename = sprintf('../../data/Grid_B/Power_recordings/Train_Grid_B_P9.wav') ;

%Grid = 'D';

grids = ['A' ,'B','C','D','E','F','G','H'];
count  = 4; 
All_F = [[]];

k = 1;

for Grid = grids
    
F = [];
for i = 1:count
       filename = sprintf('../../data/Grid_%s/Power_recordings/Train_Grid_%s_P%d.wav',Grid,Grid,i); 
       %enf_extract_me;
       if exist(filename,'file')==2
           F = [F enf_extract(filename ) ];
       end
       %   file_to_save = sprintf('../feature_data/%s_P%d.mat',Grid,i);
       %   final;
       %end
end

file_to_save = sprintf('Grid%s_enf.mat',Grid);

save(file_to_save,'F');

end

%figure();
%plot(F);
%title(Grid);
