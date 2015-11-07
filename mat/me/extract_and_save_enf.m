%% extract and save all the enf from grid data
%

grids = ['A','B','C','D','E','F','G','H','I'];

count  = 12;  % number of hour data, upto 11 hours is available

window_time = .2; % window time in second

k = 1; % just  a counter

for Grid = grids
    
F = [];
for i = 1:count
       filename = sprintf('../../data/Grid_%s/Power_recordings/Train_Grid_%s_P%d.wav',Grid,Grid,i); 
      
       if exist(filename,'file')==2
           F = enf_extract(filename ,window_time) ;
           file_to_save = sprintf('grid/%s%d.mat',Grid,i);
           save(file_to_save,'F');
       end
       
end

<<<<<<< HEAD
file_to_save = sprintf('not_all_grid/Grid%s_enf.mat',Grid);
=======
%file_to_save = sprintf('features/Grid%s.mat',Grid);
>>>>>>> recording_test

%save(file_to_save,'F');

end

%figure();
%plot(F);
%title(Grid);
