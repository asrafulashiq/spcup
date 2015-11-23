function [ ENF ] = findenf( signal, fs, harmonic_multiples,strip_index, duration, frame_size_secs, overlap_amount_secs, nfft, nominal, width_signal, width_band,tol)

harmonics=nominal*harmonic_multiples;
[ weights] = computeCombiningWeights( signal, fs, harmonics, duration, frame_size_secs, overlap_amount_secs, nfft, nominal, width_signal, width_band );
[ strips, frequency_support ] = computeSpectrogramStrips( signal, frame_size_secs, overlap_amount_secs, nfft, fs, nominal, harmonic_multiples, width_band );
[ OurStrip_Cell, initial_frequency ] = computeCombinedSpectrum( strips,weights, duration, frame_size_secs, strip_index, frequency_support );
[ENF] = computeENFfromCombinedStrip( OurStrip_Cell, initial_frequency, fs, nfft);

d=abs(diff(ENF));
di=ceil(d/min(d));
md=mode(di)*min(d);
mn=mean(ENF);
for i=1:length(ENF)
    if i>2 && i<length(ENF)-1
        t=mean([abs(ENF(i)-ENF(i-2)) abs(ENF(i)-ENF(i-1)) abs(ENF(i)-ENF(i+1)) abs(ENF(i)-ENF(i+2))]);
        if t/abs(ENF(i+1)-ENF(i-1))>tol          
            ENF(i)=ENF(i)*.02+ENF(i-1)*0.49+ENF(i+1)*0.49;
        end
    elseif i<3
        t=abs(ENF(i)-mn);
        if t/md >tol
           ENF(i)=ENF(i)*.03+ENF(i+1)*0.18+ENF(i+2)*0.19+ENF(i+3)*0.20+ENF(i+4)*0.20+ENF(i+4)*0.20;
        end
    else
        t=mean([abs(ENF(i)-ENF(i-2)) abs(ENF(i)-ENF(i-1))]);
        if t/abs(ENF(i-1)-ENF(i-2)) >tol
           ENF(i)=ENF(i)*.02+ENF(i-2)*0.49+ENF(i-1)*0.49;
        end
    end   

    
end
end


%% Spectrum Combining for ENF Signal Estimation
% Adi Hajj-Ahmad, Student Member, IEEE,RaviGarg, Student Member, IEEE,and MinWu, Fellow, IEEE

function [ weights] = computeCombiningWeights( signal0, fs, harmonics, duration, frame_size_secs, overlap_amount_secs, nfft, nominal, width_signal, width_band )
%COMPUTECOMBININGWEIGHTS Summary of this function goes here
%   This function computes the Combining Weights for the Spectrum Combining
%   approach for ENF signal estimation
%   Takes as input:
%   -> signal0: ENF-containing signal.
%   -> fs: sampling frequency of 'signal0'.
%   -> harmonics: harmonics for which we want to compute weights around.
%   -> duration: time duration for which we compute a certain weight, e.g.
%   30 min
%   -> frame_size_secs: size of time-frame for which one instantaneous ENF
%   point is estimated, e.g. 5 sec.
%   -> overlap_amount_secs: nb of seconds of overlap between time-frames
%   -> nfft: Nb of points for FFT computation, e.g. 32768 for frequency
%   resolution of ~0.03Hz when fs = 1000Hz.
%   -> nominal: nominal frequency, e.g. 60Hz for US grids.
%   -> width_signal: half the width of the band which we consider contains
%   the ENF fluctutations around the nominal value, e.g. 0.02Hz for US ENF.
%   -> width_band: half the width of the band abour the nominal value,
%   which we are considering for SNR computations, e.g. 1Hz for US ENF.
%   Gives output:
%   -> spectro_strips: a Matlab Cell of size equal to the number of
%   harmonic multiples, each component contains a spectrogram strip
%   centered at one of the harmonic multiples.
%   Gives output:
%   -> weights: combining weights computed.

% setting up the variables
nb_durations = ceil(length(signal0)/(duration*60*fs));
frame_size = floor(fs*frame_size_secs);
overlap_amount = floor(fs*overlap_amount_secs);
shift_amount = frame_size - overlap_amount;
nb_of_harmonics = length(harmonics);
harmonic_multiples = harmonics/nominal;
starting_freq = nominal - width_band;
center_freq = nominal;
init_first_value = nominal - width_signal;
init_second_value = nominal + width_signal;
weights = zeros(nb_of_harmonics,nb_durations);
inside_mean = zeros(nb_of_harmonics,nb_durations);
outside_mean = zeros(nb_of_harmonics,nb_durations);
total_nb_frames = 0;
All_Strips_Cell =  cell(nb_durations, 1);

for dur = 1:nb_durations
    
    x = signal0( (dur -1)*duration*60*fs + 1: min(end, dur*duration*60*fs + overlap_amount));
    
    %% getting the spectrogram 
    nb_of_frames = ceil((length(x) - frame_size + 1)/shift_amount);
    total_nb_frames = total_nb_frames + nb_of_frames;
    P = zeros(nfft/2 + 1, nb_of_frames);
    starting = 1;
    for frame = 1:nb_of_frames
        ending = starting + frame_size - 1;
        signal = x(starting:ending);
        [S F T P(:, frame)] = spectrogram(signal, frame_size, 0, nfft, fs);
        starting = starting + shift_amount;
    end
    
    %% getting the harmonic strips
    
    width_init = findClosest(F, center_freq) - findClosest(F, starting_freq);
    HarmonicStrips = zeros(width_init*2*sum(harmonic_multiples) , size(P, 2));
    FreqAxis = zeros(width_init*2*sum(harmonic_multiples), 1);
    resolution = F(2) - F(1);

    starting = 1;
    starting_indices = zeros(nb_of_harmonics,1);
    ending_indices = zeros(nb_of_harmonics,1);
    for k = 1:nb_of_harmonics
        starting_indices(k) = starting;
        width = width_init*harmonic_multiples(k);
        ending = starting + 2*width -1;
        ending_indices(k) = ending;
        tempFreqIndex = round(harmonics(k)/resolution);
        HarmonicStrips(starting:ending, :) = P((tempFreqIndex - width + 1):(tempFreqIndex + width), :);
        FreqAxis(starting:ending) = F((tempFreqIndex - width + 1):(tempFreqIndex + width));
        starting = ending + 1;
    end
    
    All_Strips_Cell{dur} = HarmonicStrips;
    %% getting the weights
    
    for k = 1:nb_of_harmonics
        currStrip = HarmonicStrips(starting_indices(k):ending_indices(k),:);
        freq_axis = FreqAxis(starting_indices(k):ending_indices(k));
        first_value = init_first_value*harmonic_multiples(k);
        second_value = init_second_value*harmonic_multiples(k);
        first_index = findClosest(freq_axis, first_value);
        second_index = findClosest(freq_axis, second_value);
        inside_strip = currStrip(first_index:second_index, :);
        inside_mean(k, dur) = mean(mean(inside_strip));
        outside_strip = currStrip([1:first_index-1, second_index +1:end], :);
        outside_mean(k, dur) = mean(mean(outside_strip));
        if inside_mean(k, dur) < outside_mean(k, dur)
            weights(k, dur) = 0;
        else
            weights(k, dur) = inside_mean(k, dur)/outside_mean(k, dur);
        end
        
    end
    
    %% normalizing the weights
    sum_weights = sum(weights(:, dur));
    for k = 1:nb_of_harmonics
        weights(k, dur) = 100*weights(k, dur)/sum_weights;
    end
end
end


function [ spectro_strips, frequency_support ] = computeSpectrogramStrips( signal, frame_size_secs, overlap_amount_secs, nfft, fs, nominal, harmonic_multiples, width_band )
%COMPUTESPECTROGRAMSTRIPS Summary of this function goes here
%   This function generates the spectrogram strips needed for ENF signal estimation
%   Takes as input: 
%   -> signal: ENF-containing signal.
%   -> frame_size_secs: size of time-frame for which one instantaneous ENF
%   point is estimated, e.g. 5 sec.
%   -> overlap_amount_secs: nb of seconds of overlap between time-frames
%   -> nfft: Nb of points for FFT computation, e.g. 32768 for frequency
%   resolution of ~0.03Hz when fs = 1000Hz.
%   -> fs: sampling frequency of 'signal'.
%   -> nominal: nominal frequency of ENF signal, e.g. 60Hz in US.
%   -> harmonic_multiples: harmonic multiples for which we want to compute
%   the spectrogram strips for, e.g. 1:8 for 60, 120, 180, ... , 480Hz.
%   -> width_band: half the desired width of the strips, about the nominal
%   frequency.
%   Gives output:
%   -> spectro_strips: a Matlab Cell of size equal to the number of
%   harmonic multiples, each component contains a spectrogram strip
%   centered at one of the harmonic multiples.
%   -> frequency_support: index of starting and ending frequencies of each
%   strip.

% setting up the variables
nb_harmonics = length(harmonic_multiples);
spectro_strips = cell(nb_harmonics, 1);
frame_size = frame_size_secs*fs;
overlap_amount = overlap_amount_secs*fs;
shift_amount = frame_size - overlap_amount;
len_sig = length(signal);
nb_frames = ceil((len_sig - frame_size + 1)/shift_amount);

% collecting the full spectrogram in P, and the full frequency axis in F
starting = 1;
P = zeros(nfft/2 + 1, nb_frames);
for frame = 1:nb_frames
    ending = starting + frame_size - 1;
    x = signal(starting:ending);
    [~, F, ~, P(:, frame)] = spectrogram(x, frame_size, 0, nfft, fs);
    starting = starting + shift_amount;
end


% choosing the strips that we need, and setting up 'frequency_support'.
first_index = findClosest(F, nominal - width_band);
second_index = findClosest(F, nominal + width_band);
frequency_support = zeros(nb_harmonics, 2);
for k = 1:nb_harmonics
    starting = first_index*harmonic_multiples(k);
    ending = second_index*harmonic_multiples(k);
    spectro_strips{k} = P(starting:ending, :);
    frequency_support(k, 1) = F(starting);
    frequency_support(k, 2) = F(ending);
end

end

function [ OurStrip_Cell, initial_frequency ] = computeCombinedSpectrum( strips, weights, duration, frame_size_secs, strip_index, frequency_support )
%COMPUTECOMBINEDSPECTRUM Summary of this function goes here
%   This function takes in spectrogram strips, or pseudo-spectrum strips
%   and combines them according to the combining weights.
%   Takes as input:
%   -> strips: Cell containing strips around different harmonics.
%   -> weights: combining weights.
%   -> duration: time-duration for which a certain weight is computed.
%   -> frame_size_secs: size of time-frame for which one instantaneous ENF
%   point is estimated, e.g. 5 sec.
%   -> strip_index: index of the strip in 'strips' whose width will be 
%   the width we give to all the strips when we combine them.
%   -> frequency_support: beginning and ending frequencies for each strip
%   Gives as output:
%   -> OurStrip_cell: Cell of size corresponding to the number of
%   durations, containing the combined strip for each duration.
%   -> initial_frequency: starting frequency of combined strip

% setting up the variables
nb_durations = size(weights, 2);
nb_frames = size(strips{1}, 2);
nb_frames_per_dur = duration*60/frame_size_secs;
strip_width = size(strips{strip_index}, 1);
OurStrip_Cell = cell(nb_durations, 1);
nb_signals = length(strips);
initial_frequency = frequency_support(strip_index, 1);

% combining the strips, taking each duration at a time, as each duration
% has a different set of weights.
begin = 1;
for dur = 1:nb_durations
    nb_frames_left = nb_frames - (dur-1)*nb_frames_per_dur;
    OurStrip = zeros(strip_width, min(nb_frames_per_dur, nb_frames_left));
    endit = begin + size(OurStrip,2) -1;
    for harm = 1:nb_signals
        tempStrip = strips{harm}(:, begin:endit);
        for frame = 1:size(OurStrip, 2)
            tempo = imresize(tempStrip(:, frame), [strip_width, 1], 'bilinear');
            tempo = 100*tempo/max(tempo);
            OurStrip(:, frame) = OurStrip(:, frame) + weights(harm, dur)*tempo;
        end
    end
    OurStrip_Cell{dur} = OurStrip;
    begin = endit +1 ;
end
end

function [ENF] = computeENFfromCombinedStrip( OurStrip_Cell, initial_frequency, fs, nfft  )
%COMPUTEENFFROMCOMBINEDSTRIP Summary of this function goes here
%   This function computes the ENF signal estimate from the combined strip
%   Takes as input:
%   -> OurStrip_Cell: Cell containing the combined strip for different
%   durations.
%   -> initial_frequency: the frequency to which the first column in the
%   combined strip corresponds to.
%   -> fs: sampling frequency.
%   -> nfft: Nb of points for FFT computation, e.g. 32768 for resolutoon of
%   ~0.03Hz when fs = 1000Hz.

% setting up the variables
nb_durations = length(OurStrip_Cell);
nb_frames_per_dur = size(OurStrip_Cell{1}, 2);
nb_frames = nb_frames_per_dur*(nb_durations - 1) + size(OurStrip_Cell{end},2);
ENF = zeros(nb_frames, 1);

% taking each frame at a time, and using quadratic interpolation to find
% its maximum and thus its dominant ENF frequency

starting = 1;
for dur = 1:nb_durations
    OurStrip_here = OurStrip_Cell{dur};
    nb_frames_here = size(OurStrip_here, 2);
    ending = starting + nb_frames_here - 1;
    ENF_here = zeros(nb_frames_here, 1);
    for frame = 1:nb_frames_here
        power_vector = OurStrip_here(:, frame);
        [~, index] = max(power_vector);
        k_star = QuadInterpFunction(power_vector, index);
        ENF_here(frame) = initial_frequency + fs*k_star/nfft;
    end
    ENF(starting:ending) = ENF_here;
    starting = ending + 1;
end
end

function [ signals ] = filterSignals( signal, filters, indices )
%FILTER_SIGNALS Summary of this function goes here
%   This function filters 'signal' through the filters in the cell
%   structure 'filters' indexed by the values in 'indices'. The output
%   filtered signals are stored in the cell structure 'signals'.

signal = signal(:);
nb_filters_chosen = length(indices);
signals = cell(nb_filters_chosen, 1);
for k = 1:nb_filters_chosen
    h = filters{indices(k)};
    signals{k} = filter(h.Numerator, 1, signal);
end

end

function [ index ] = findClosest( vector, value )
%FINDCLOSEST Summary of this function goes here
%   This function finds the index of closest element in 'vector' to 'value'

index = 1;
for k = 2:length(vector)
    if (abs(vector(k) - value) < abs(vector(k-1) - value))
        index = k;
    else
        break;
    end
end
end

function [ k_star ] = QuadInterpFunction( vector, index )
%QUAD_INTERP_FUNC Summary of this function goes here
%   This function finds the index 'k_star' of the maximum value in 'vector'
%   about 'index', computed using quadratic interpolation

if index == 1
    index = 2;
elseif index == length(vector)
    index = length(vector) - 1;
end
alpha = 20 * log10(abs(vector(index - 1)));
beta = 20* log10(abs(vector(index)));
gamma = 20*log10(abs(vector(index + 1)));
delta = 0.5*(alpha - gamma)/(alpha - 2*beta + gamma);
kmax = index - 1;
k_star = kmax + delta;
end





