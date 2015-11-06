% extract enf from filename. 
%% filename must be a wav file
function F = enf_extract(filename,window_time)
%%
    [Y,Fs] = audioread(filename);
    % Fs is the sampling frequency of the wav file
    
    Y_f= Y; %filter(bandpass,Y'); 
    
    %window_time = 2 % window time in second
    
    window_len = window_time * Fs; % number of samples per window
    
    len = ((length(Y)/window_len));
    
    %%
    F=zeros(1,len);
    for i=1:len
        
        % applying non overlapping window
        p=Y_f( window_len*(i-1)+1 : window_len*(i-1)+window_len ); %Y_f(200*(i-1)+1:200*(i-1)+400);
        p1=fft(p,2^nextpow2(window_len));
        f = (0:length(p1)-1)*1000/length(p1);
        [~,m]=max(log(abs(p1).^2));
        alpha=20*log(abs(p1(m-1)));
        beta=20*log(abs(p1(m)));
        lambda=20*log(abs(p1(m+1)));
        m1=.5*(alpha-lambda)*(f(m+1)-f(m))/(alpha-2*beta+lambda); % for quadratic interpolation
        f(m)=f(m)+m1;
        F(i)=f(m);
    end
   
   %t = (1:length(F) )*window_time;
   %figure; plot( t, F);
    

end