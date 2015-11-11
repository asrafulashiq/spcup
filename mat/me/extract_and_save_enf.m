%% extract and save all the enf from grid data
%

grids = ['A','B','C','E','F','G','H','I'];

grids = ['D']

count  = 12;  % number of hour data, upto 11 hours is available

window_time = 2; % window time in second

k = 1; % just  a counter

for Grid = grids
filter = false;

if Grid=='D'
    filter = true;
end

Ff = [];
for i = 1:count
       filename = sprintf('../../data/Grid_%s/Power_recordings/Train_Grid_%s_P%d.wav',Grid,Grid,i) 
        
       
       if exist(filename,'file')==2
           F = enf_extract(filename ,window_time,filter) ;
           file_to_save = sprintf('grid2000/%s%d.mat',Grid,i);
           save(file_to_save,'F');
           disp(filename);
           Ff = [Ff F];
       else
           disp('file not exist');
       end
       
end

%file_to_save = sprintf('features/Grid%s.mat',Grid);

plot(Ff);

end

%figure();
%plot(F);
%title(Grid);
