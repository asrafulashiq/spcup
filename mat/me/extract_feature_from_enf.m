%% extract statistical features from 
%  enf signal in filename

function r = extract_feature_from_enf(file,window_sample)
    
    load(file,'F'); % load enf signal from matfile
    
    x = F ;
    F1=F/max(F); % normalized enf
    
    %% global mean
    global_mean = mean(F);
    
    %% global variance
    global_var = log(var(F));
    
    
    %% statistical features
   
    
    windows = (window_sample+1):window_sample:(length(F)-window_sample); % skip initial window_samples
    
    len = length(windows);
    
    mean_x = zeros(1,len);
    var_x = zeros(1,len);
    range_x = zeros(1,len); % difference between max and min value
    diff_x = zeros(1,len); % mean of maximum 3 differences
    wav_coef = [];
    
    var_wav = zeros(1,len); % variance of wavlet coefficient
    
    % AR2 model parameters
    ar1_x = zeros(1,len);
    ar2_x = zeros(1,len);
    
    counter = 1; % simple counter for the loop 
    
    for i = windows
        
        mean_x(counter) = mean( x(i:(i+window_sample-1)) );
        
        var_x(counter) = log( var( x(i:(i+window_sample-1)) ) );
        
        range_x(counter) = log(abs( max(x(i:(i+window_sample-1))) - min(x(i:(i+window_sample-1)))) );
        
        % diff
        d_m = abs(diff(x(i:(i+window_sample-1)))); %make a difference matrix

        d1 = sort(d_m,'descend');
        
        d = (d1(1)+d1(2)+d1(3))/3;           %taking mean of max 3 differences

        diff_x(counter) = log(d);
        
        %% wavelet analysis
        
       temp1= x(i:(i+window_sample-1));
       temp2=F1(i:(i+window_sample-1));                  % for normalized ENF

       [C ,L]=wavedec(temp1,9,'haar');

       [C1 , L1]=wavedec(temp2,9,'haar');      % for normalized ENF

        wav_coef(:,counter)=C;
        wavcoef_n(:,counter)=C1;
        
        var_wav(counter) = log(var(C));
        
        %feature_per_rcrd = feature_per_rcrd + 1;
        
        %% estimating AR2 model parameters
        arr = arburg( x(i:(i+window_sample-1)),2 );
        ar1_x(counter) = arr(1);
        ar2_x(counter) = arr(2);
        
        

        %% increment counter
        counter = counter + 1;
        
    end
    
  

    %% save features
    grid_name = strsplit(file,'/')
    grid_name(2)
    g = strsplit(char(grid_name(2)),'_')
    
    file_to_save = sprintf('features/%s',char(g(1)));
    save(file_to_save,'mean_x','var_x','range_x','diff_x','var_wav','ar2_x');
        
end