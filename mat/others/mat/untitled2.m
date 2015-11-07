
tar = tar + 1;

t = zeros(8,length(targets));

for i = 1:length(targets)
    tmp = zeros(1,8);
    tmp( tar(i) ) = 1;
    
    t(:,i) = tmp;
end