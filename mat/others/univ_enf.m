clear all;
clc;
close all;
fs=1000;


% Y=wavread('C:\Users\Ratul Khan\Desktop\Training_Data\Training_GridsDtoF\Grid_F\Power_recordings\Train_Grid_F_P2');
Y=wavread('C:\Users\Ratul Khan\Desktop\Training_Data\Training_GridsGtoI\Grid_I\Power_recordings\Train_Grid_I_P1');
  Y1=decimate(Y',2);
  
    q=Y1(201:1000);
    q1=fft(q,4096);
    g = (0:length(q1)-1)*500/length(q1);
    [~,m]=max(log(abs(q1).^2));
    alpha=20*log(abs(q1(m-1)));
    beta=20*log(abs(q1(m)));
    lambda=20*log(abs(q1(m+1)));
    m1=.5*(alpha-lambda)*(g(m+1)-g(m))/(alpha-2*beta+lambda);
    g(m)=g(m)+m1;
    
  if g(m)<52
      Y_f=filter(Bandpass_50,Y1);
      cc=0;
  else
      Y_f=filter(Bandpass_60,Y1);
      cc=1;
  end
      
F=[];
for i=1:(length(Y_f)/100)-1
    p = Y_f(100*(i-1)+1:100*(i-1)+200);
    cc=2
    p1=fft(p,4096);
    f = (0:length(p1)-1)*500/length(p1);
    [~,m]=max(log(abs(p1).^2));
    alpha=20*log(abs(p1(m-1)));
    beta=20*log(abs(p1(m)));
    lambda=20*log(abs(p1(m+1)));
    m1=.5*(alpha-lambda)*(f(m+1)-f(m))/(alpha-2*beta+lambda);
    f(m)=f(m)+m1;
    F=[F f(m)];
end