%clear all;
%clc;
%close all;


%fs=1000;

%Y=wavread('/Users/mac/Downloads/Training_GridsAtoC/Grid_A/Power_recordings/Train_Grid_A_P1.wav');

%%

Y = wavread(filename);

Y_f=filter(Bandpass_n,Y');


%%
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
   % plot(F)
 figure;  
 plot(F);
 title(filename);
   
