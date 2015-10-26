%% extract and save all the enf from grid data
%

grids = ['A','B','C','D','E','F','G','H'];

count  = 12;  % number of hour data, upto 11 hours is available

window_time = 2; % window time in second

k = 1; % just  a counter

for Grid = grids
    
F = [];
for i = 1:count
       filename = sprintf('../../data/Grid_%s/Power_recordings/Train_Grid_%s_P%d.wav',Grid,Grid,i); 
      
       if exist(filename,'file')==2
           F = [F enf_extract(filename ,window_time) ];
       end
       
end

file_to_save = sprintf('not_all_grid/Grid%s_enf.mat',Grid);

save(file_to_save,'F');

end

%figure();
%plot(F);
%title(Grid);
