
load('audio_enf.mat');
enf = ENF_audio;

g = ['A','B','C','D','E','F','G','H','I'];
win = 32;

for i = 1:length(g)
   
    e = [enf(2*i-1,:) enf(2*i,:)];
    extract_feature_from_array(e,win,g(i));
    
end
