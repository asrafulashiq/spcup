close all;

fs=1000;
%Y=wavread('I:\SP Cup Data\Training Data\Training_GridsDtoF\Grid_F\Power_recordings\Train_Grid_F_P1');

gridName = 'A_P1';

filename = sprintf('../data/Grid_A/Power_recordings/Train_Grid_%s.wav',gridName); 

Y=wavread(filename);
% Y1=decimate(Y',2);

Y_f=filter(Bandpass_n,Y');

F=[];
for i=1:((length(Y)/400)-1)
    p=Y_f(200*(i-1)+1:200*(i-1)+400);
    p1=fft(p,4096);
    f = (0:length(p1)-1)*1000/length(p1);
    [~,m]=max(log(abs(p1).^2));
    alpha=20*log(abs(p1(m-1)));
    beta=20*log(abs(p1(m)));
    lambda=20*log(abs(p1(m+1)));
    m1=.5*(alpha-lambda)*(f(m+1)-f(m))/(alpha-2*beta+lambda); % for quadratic interpolation
    f(m)=f(m)+m1;
    F=[F f(m)];
end
plot(F)
x = F;

%% Statistical feature

global_mean = mean(x);
global_var = var(x);
var_x = [];
mean_x = [];
skew_x = [];
kurt_x = [];
diff_x = [];

for i = 1:32:(length(x)-32)        %window length 32 samples
    
    m = mean(x(i:i+31));        %taking mean of 32 samples at a time
    mean_x = [mean_x m];        %appending window mean to matrix
        
    v = var(x(i:i+31));         %taking variance of 32 samples at a time
    
    var_x = [var_x v];          %appending window variance to matrix
    
    k = kurtosis(x(i:i+31));    %kurtosis per window
    
    kurt_x = [kurt_x k];        %appending window kurtosis to matrix
    
    s = skewness(x(i:i+31));    %skewness per window
    
    skew_x = [skew_x s];        %appending window skewness to matrix

end



diff_x = [];

for i = 1:32:(length(x)-32)        %window length 32 samples 
    
    d_m = abs(diff(x(i:i+31))); %make a difference matrix
    
    d1 = max(d_m);              
    
    for j = 1:31
        
        if d_m(j) == d1         %replacing the max value in matrix with 0
            
            d_m(j) == 0;
        end
    end
    
    d2 = max(d_m);              %extracting 2nd max value
    
    for j = 1:31
        
        if d_m(j) == d2
            
            d_m(j) == 0;        %replacing 2nd max value with 0
        end
    end
    
    d3 = max(d_m);              %extracting 3rd max value
    
    d = (d1+d2+d3)/3;           %taking mean of max 3 differences
    
    diff_x = [diff_x d];
    
end


%% Wavelet based features

F1=F/max(F);                         %normalize ENF

wav_coef=[];
pp=1;
for i = 1:32:(length(F)-32)

   temp1= F(i:i+31);
   temp2=F1(i:i+31);                  % for normalized ENF
   
   [C L]=wavedec(temp1,9,'haar');
   
   [C1 L1]=wavedec(temp2,9,'haar');      % for normalized ENF
    
    wav_coef(:,pp)=C;
    wavcoef_n(:,pp)=C1;
    pp=pp+1;
   
end

%% save data to a mat file
%file_to_save = sprintf('../feature_data/%s.mat',gridName);
save(file_to_save,'F','var_x','mean_x','skew_x','kurt_x','diff_x','global_mean','global_var','wavcoef_n');



