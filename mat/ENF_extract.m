clear all;
clc;
close all;
fs=500;
Y=wavread('/Users/mac/Downloads/Training_GridsAtoC/Grid_A/Power_recordings/Train_Grid_A_P1.wav');
 Y1=decimate(Y',2);

% d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,48,49,55,56,500);/Users/mac/Downloads/Training_GridsAtoC/Grid_A/Power_recordings/Train_Grid_A_P1.wav
% d.Stopband1Constrained = true; d.Astop1 = 60;
% d.Stopband2Constrained = true; d.Astop2 = 60;
% Hd = design(d,'equiripple');

Y_f=filter(Bandpass,Y1);
%%%%%
% xlen = length(Y_f);                   % length of the signal
% wlen = 1024;                        % window length (recomended to be power of 2)
% h = wlen/4;                         % hop size (recomended to be power of 2)
% nfft = 4096;                        % number of fft points (recomended to be power of 2)
% 
% [s, f, t] = stft(Y_f, wlen, h, nfft, fs);

%%%%
% % hilbert transform
% Y_hil=hilbert(Y_f);
% instfreq = fs/(2*pi)*diff(unwrap(angle(Y_hil)));
% plot(instfreq);

%%%%%
F=[];
for i=1:900
    p=Y_f(200*(i-1)+1:200*(i-1)+1000);
%       p=Y_f(1000*(i-1)+1:1000*(i));
%     p=p.*hanning(500);
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