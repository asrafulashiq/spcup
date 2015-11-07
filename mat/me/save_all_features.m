
% save all enf features in features folder

grids = ['A','B','C','D','E','F','G','H','I'];

window = 16; % 32 window per enf

count = 11;

for Grid = grids
    
    for i = 1:count
       filename = sprintf('grid/%s%d.mat',Grid,i); 
       
       if exist(filename,'file')==2
           extract_feature_from_enf(filename,window);
           disp(filename); 
       end
    end
       
end

