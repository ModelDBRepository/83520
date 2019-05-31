function [s_tim,sig,wave_am,wave_pm] = blim_whnoise(carfrq,caramp,Fs,dur,cutoff,sigma,modopt,prntopt)

%
%   blim_whnoise.m
%       Generates a band-limited white noise stimulus waveform
%   SEE:
%       Wessel R, Koch C, Gabbiani F (1996) Coding of time-varying electric field amplitude modulations in a
%           wave-type electric fish. Journal of Neurophysiology 75:2280-2293.
%   USAGE:
%       [s_tim,sig,wave_am,wave_pm] = blim_whnoise(carfrq,caramp,Fs,dur,cutoff,sigma,modopt,prntopt)
%   WHERE:
%       s_tim = vector of times for the sine wave (s)
%       sig = vector of amplitudes for the sine wave (V)
%       wave_am = AM modulation waveform (ratio to mean)
%       wave_pm = PM modulation waveform (deviation in degrees)
%       carfrq = carrier frequency (Hz)
%       caramp = carrier amplitude (mV)
%       Fs = sampling rate (Hz)
%       dur = duration of waveform (sec)
%       cutoff = cutoff frequency of filter (Hz)
%       sigma = standard deviation of waveform (1 or 2 element vector for AM (1, %) and PM (2, deg))
%       modopt = option for selecting which parameters to modify (1=AM/2=PM/3=AM and PM)
%       prntopt = option for plotting data (1=yes/0=no)
%

% Create time vector
s_tim = [0:1/Fs:dur];

% Get modulation variance
if length(sigma)==1,
    if modopt==3,
        error('one value of sigma for modulation of two variables');
    else
        sigma_am = sigma/100;       % Change percentage to fraction
        sigma_pm = sigma;
    end
elseif length(sigma)==2,
    if modopt~=3,
        error('two values of sigma for modulation of only one variable');
    else
        sigma_am = sigma(1)/100;    % Change percentage to fraction
        sigma_pm = sigma(2);
    end
else
    error('sigma must be a 1- or 2-element vector');
end

% Generate band-limited white noise stimulus
if modopt==1,           % AM
    wave_am = randn(length(s_tim),1);                           % generate white noise stimulus
    [b,a] = butter(4,cutoff/(Fs/2));                            % low-pass filter the stimulus
	wave_am = filter(b,a,wave_am);
	wave_am = wave_am*(sigma_am/std(wave_am));                  % normalize to desired variance
    wave_am = wave_am-mean(wave_am)+1;                          % normalize mean amplitude to 1
    car = sin(2*pi*carfrq*s_tim);                               % carrier signal
	sig = caramp*wave_am'.*car;                                 % combine AM with carrier signal
    wave_pm = zeros(length(wave_am),1);
elseif modopt==2,       % PM
    wave_pm = randn(length(s_tim),1);                           % generate white noise stimulus
	[b,a] = butter(4,cutoff/(Fs/2));                            % low-pass filter the stimulus
	wave_pm = filter(b,a,wave_pm);
    wave_pm = wave_pm-mean(wave_pm);                            % normalize mean phase difference to 0
	wave_pm = wave_pm*(sigma_pm/std(wave_pm));                  % normalize to desired variance
	sig = caramp*(sin((2*pi*carfrq*s_tim)-(wave_pm'*pi/180)));  % create carrier signal with PM
    wave_am = ones(length(wave_pm),1);
elseif modopt==3,       % AM/PM
    wave_pm = randn(length(s_tim),1);                           % generate white noise stimulus
	[b,a] = butter(4,cutoff/(Fs/2));                            % low-pass filter the stimulus
	wave_pm = filter(b,a,wave_pm);
    wave_pm = wave_pm-mean(wave_pm);                            % normalize mean phase difference to 0
	wave_pm = wave_pm*(sigma_pm/std(wave_pm));                  % normalize to desired variance
	sig = sin((2*pi*carfrq*s_tim)-(wave_pm'*pi/180));           % create carrier signal with PM
    wave_am = randn(length(s_tim),1);                           % generate white noise stimulus with zero edges to eliminate edge effects
	[b,a] = butter(4,cutoff/(Fs/2));                            % low-pass filter the stimulus
	wave_am = filter(b,a,wave_am);
	wave_am = wave_am*(sigma_am/std(wave_am));                  % normalize to desired variance
    wave_am = wave_am-mean(wave_am)+1;                          % normalize mean amplitude to 1
	sig = caramp*wave_am'.*sig;                                 % combine AM with PM signal
else
    error('Must choose which parameters to modify... modopt = (1-AM/2-PM/3-AM and PM) ');
end

% remove last element
s_tim = s_tim(1:length(s_tim)-1);
sig = sig(1:length(sig)-1);
wave_am = wave_am(1:length(wave_am)-1);
wave_pm = wave_pm(1:length(wave_pm)-1);

% Plot stimulus data if desired
if prntopt==1,
    if modopt~=3,
		h1 = figure('Name','Stimulus Waveform', ...
			'NumberTitle','off', ...
			'Position',[700 100 500 800], ...
            'Tag','Fig1');
		a1 = axes('position', [0.15 0.75 0.75 0.23]);
        if modopt==1,
			plot(s_tim,100*wave_am,'b-');
			xlabel('Time (s)')
			ylabel('Relative Amplitude (%)')
        else
			plot(s_tim,wave_pm-mean(wave_pm),'r-');
			xlabel('Time (s)')
			ylabel('Relative Phase (deg)')
        end
		a2 = axes('position', [0.15 0.4 0.75 0.23]);
        if modopt==1,
			hist(wave_am,100)
			h = findobj(gca,'Type','patch');
			set(h,'FaceColor','b')
            xlabel('Relative Amplitude (%)')
        else,
            hist(wave_pm,100)
			h = findobj(gca,'Type','patch');
			set(h,'FaceColor','r')
            xlabel('Relative Phase (deg)')
        end
		ylabel('Count')
		a3 = axes('position', [0.15 0.05 0.75 0.23]);
        if modopt==1,
            [P_am,F_am] = psd(100*(wave_am-mean(wave_am)),5096,Fs,bartlett(5096),2048,'none');
            P_am = P_am/Fs;
            psdplot(P_am,F_am,'Hz','LINEAR');
            xlim([0 cutoff*5])
			xlabel('Frequency (Hz)')
			ylabel('Power spectral density (%^2/Hz)')
        else,
            [P_pm,F_pm] = psd(wave_pm-mean(wave_pm),5096,Fs,bartlett(5096),2048,'none');
            P_pm = P_pm/Fs;
            psdplot(P_pm,F_pm,'Hz','LINEAR');
			h = get(gca);
			set(h.Children,'color','r')
            xlim([0 cutoff*5])
			xlabel('Frequency (Hz)')
			ylabel('Power spectral density (deg^2/Hz)')
        end
        grid off
		zoom on
    else
		h1 = figure('Name','Stimulus Waveform', ...
			'NumberTitle','off', ...
			'Position',[200 100 1000 800], ...
            'Tag','Fig1');
		a1 = axes('position', [0.1 0.75 0.35 0.23]);
		plot(s_tim,100*wave_am,'b-');
		xlabel('Time (s)')
		ylabel('Relative Amplitude (%)')
        a2 = axes('position', [0.6 0.75 0.35 0.23]);
		plot(s_tim,wave_pm,'r-');
		xlabel('Time (s)')
		ylabel('Relative Phase (deg)')
		a3 = axes('position', [0.1 0.4 0.35 0.23]);
		hist(wave_am,100)
		h = findobj(gca,'Type','patch');
		set(h,'FaceColor','b')
        xlabel('Relative Amplitude (%)')
        ylabel('Count')
        a4 = axes('position', [0.6 0.4 0.35 0.23]);
        hist(wave_pm,100)
		h = findobj(gca,'Type','patch');
		set(h,'FaceColor','r')
        xlabel('Relative Phase (deg)')
		ylabel('Count')
		a5 = axes('position', [0.1 0.05 0.35 0.23]);
        [P_am,F_am] = psd(100*(wave_am-mean(wave_am)),5096,Fs,bartlett(5096),2048,'none');
        P_am = P_am/Fs;
        psdplot(P_am,F_am,'Hz','LINEAR');
        xlim([0 cutoff*5])
		xlabel('Frequency (Hz)')
		ylabel('Power spectral density (%^2/Hz)')
        grid off
        a6 = axes('position', [0.6 0.05 0.35 0.23]);
        [P_pm,F_pm] = psd(wave_pm-mean(wave_pm),5096,Fs,bartlett(5096),2048,'none');
        P_pm = P_pm/Fs;
        psdplot(P_pm,F_pm,'Hz','LINEAR');
		h = get(gca);
		set(h.Children,'color','r')
        xlim([0 cutoff*5])
		xlabel('Frequency (Hz)')
		ylabel('Power spectral density (deg^2/Hz)')
        grid off
		zoom on
    end
end