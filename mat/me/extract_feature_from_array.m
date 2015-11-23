%% extract statistical features from 
%  enf signal in filename

function  extract_feature_from_array(F,window_sample,grid_name)
    
    
    x = F ;
    F1=F/max(F); % normalized enf
    
    %% global mean
    %global_mean = mean(F);
    
    %% global variance
    %global_var = log(var(F));
    
    
    %% statistical features
   
    
    windows = (window_sample+1):window_sample:(length(F)-window_sample); % skip initial window_samples
    
    len = length(windows);
    
    mean_x = zeros(1,len);
    var_x = zeros(1,len);
    range_x = zeros(1,len); % difference between max and min value
    diff_x = zeros(1,len); % mean of maximum 3 differences
    wav_coef = [];
    wav_mean = zeros(1,len);
    wav_var = zeros(1,len);
    d1 = zeros(1,len);
    d2 = zeros(1,len);
    d3 = zeros(1,len);
    d4 = zeros(1,len);
    d5 = zeros(1,len);

    d1_m = zeros(1,len);
    d2_m = zeros(1,len);
    d3_m = zeros(1,len);
    d4_m = zeros(1,len);
    d5_m = zeros(1,len);
    %var_wav = zeros(1,len); % variance of wavlet coefficient
    
    % AR2 model parameters
    ar1_x = zeros(1,len);
    ar2_x = zeros(1,len);
    D = [];
    
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

       [C ,L]=wavedec(temp1,5,'haar');

       [C1 , L1]=wavedec(temp2,5,'haar');      % for normalized ENF

        wav_coef(:,counter)=C;
        %wavcoef_n(:,counter)=C1;
        
        A5= wrcoef('a',C,L,'haar',5);  
        
        
        D(:,1)=wrcoef('d',C,L,'haar',1);          % detail_signal_1
        D(:,2)=wrcoef('d',C,L,'haar',2);          % detail_signal_2
        D(:,3)=wrcoef('d',C,L,'haar',3);          %detail_signal_3
        D(:,4)=wrcoef('d',C,L,'haar',4);          % detail_signal_4
        D(:,5)=wrcoef('d',C,L,'haar',5);          % detail_signal_5
        wav_mean(counter) = mean(A5);                        % mean of approximation
        wav_var(counter) = (var(A5));%variance of approximation
        
        d1(counter) = log(var(D(:,1)));
        d2(counter) = log(var(D(:,2)));
        d3(counter) = log(var(D(:,3)));
        d4(counter) = log(var(D(:,4)));
        d5(counter) = log(var(D(:,5)));
        
        d1_m(counter) = mean(D(:,1));
        d2_m(counter) = mean(D(:,2));
        d3_m(counter) = mean(D(:,3));
        d4_m(counter) = mean(D(:,4));
        d5_m(counter) = mean(D(:,5));
        
        %for i=1:5
        %    wav_mean=[wav_mean mean(D(:,i))];     % mean of detail
        %    wav_var=[wav_var var(D(:,i))];        % variance of detail
        %end
        wavcoef_n(:,counter)=C1;
        
        
        %var_wav(counter) = log(var(C));
        
        %feature_per_rcrd = feature_per_rcrd + 1;
        
        %% estimating AR2 model parameters
        arr = arburg( x(i:(i+window_sample-1)),2 );
        ar1_x(counter) = arr(1);
        ar2_x(counter) = arr(2);
        
        

        %% increment counter
        counter = counter + 1;
        
    end
    
  

    %% save features
    
    file_to_save = sprintf('audio_features/%s',grid_name);
    save(file_to_save,'mean_x','var_x','range_x','diff_x','wav_mean','wav_var','ar2_x'...
        ,'d1','d2','d3','d4','d5','wav_coef','wavcoef_n');
        
end