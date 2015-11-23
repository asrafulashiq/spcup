
function enf = enf_extraction_from_audio(filename)

Y= audioread(filename);
info=audioinfo(filename);
% determining the nominal frequency of grid 
Fs = 1000;
Y= audioread(filename);
x=Y(1:1000000);
% x=Y;
[STFT,F,T,P] = spectrogram(x,250,200,1000,Fs);
m=10*log10(P);
%  surf(T,F,m,'edgecolor','none'); axis tight;
% view(0,90);
a=sum(m(50,:))+sum(m(100,:))+sum(m(150,:))+sum(m(200,:))+sum(m(250,:))+sum(m(300,:))+sum(m(350,:));
b=sum(m(60,:))+sum(m(120,:))+sum(m(180,:))+sum(m(240,:))+sum(m(300,:))+sum(m(360,:))+sum(m(420,:));
if a>b
    c=50
    z=sum(m(35,:))+sum(m(70,:))+sum(m(130,:))+sum(m(180,:))+sum(m(230,:))+sum(m(320,:))+sum(m(370,:));
    dec=a/z;
else 
    c=60
    z=sum(m(40,:))+sum(m(80,:))+sum(m(140,:))+sum(m(200,:))+sum(m(260,:))+sum(m(320,:))+sum(m(390,:));
    dec=b/z;
end
% abs(a-b)
if dec>=.85
    sig='audio'
else
    sig='power'
end

%extracting enf signal 
nfft=32768;
harmonic_multiples=2;
duration=info.Duration;
frame_size_secs=2;%100 samples window(50 hz)
overlap_amount_secs=0;%60 samples overlapping
width_signal=1;
width_band=1;
strip_index=1;
tol=1;
nominal=c;
enf=findenf(Y, Fs, harmonic_multiples,strip_index, duration, frame_size_secs,overlap_amount_secs, nfft, nominal, width_signal, width_band,tol );
enf=enf/2;

%plot(enf);

end


