% A simple script to extract all the enf signals and
% statistical features and save it to .mat files
% located in feature_data/  folder

grids = ['A' ]%,'B','C','D','E','F','G','H'];
count = 1;

for Grid = grids
   
    for i = 1:count
       filename = sprintf('../data/Grid_%s/Power_recordings/Train_Grid_%s_P%d.wav',Grid,Grid,i); 
       enf_extract_me;
       %if exist(filename,'file')==2
       %   file_to_save = sprintf('../feature_data/%s_P%d.mat',Grid,i);
       %   final;
       %end
    end
end