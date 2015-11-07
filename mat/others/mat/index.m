% a matlab script to determine the last index of grids

ind = ones(1,8);
current = 0;

for i = 1:8
    while true
        current = current + 1;
        if responsevar(current)>i
           ind(i) = current-1;
           break;
        end
    end
end

disp(ind)
