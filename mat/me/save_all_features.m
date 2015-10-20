
% save all enf features in features folder

grids = ['A','B','C','D','E','F','G','H'];

window = 32; % 32 window per enf

for Grid = grids
    
    file = sprintf('grid/Grid%s_enf.mat',Grid);
    extract_feature_from_enf(file,window);

end
