function yy = normalize(y)
    
    % normalize between -100 and 100
     yy =  y / max(abs(y)) * 100;

end