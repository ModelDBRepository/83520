function [s_tim,sig,am,pm] = modsine(carfrq,carphs,caramp,modrat,amdpth,pmdpth,amphas,pmphas,s_rate,dur)

%
%   modsine.m
%       creates a sinusoid stimulus with phase and amplitude modulation
%   USAGE:
%       [s_tim,sig,am,pm] = modsine(carfrq,carphs,caramp,modrat,amdpth,pmdpth,amphas,pmphas,s_rate,dur)
%   WHERE:
%       s_tim = vector of times for the sine wave (s)
%       sig = vector of amplitudes for the sine wave (V)
%       am = AM waveform (%)
%       pm = PM waveform (deg)
%       carfrq = carrier frequency (Hz)
%       carphs = carrier phase (deg)
%       caramp = carrier amplitude (mV)
%       modrat = modulation rate (Hz)
%       amdpth = depth of amplitude modulation (%)
%       pmdpth = depth of phase modulation (deg)
%       amphas = starting phase of amplitude modulation (deg)
%       pmphas = starting phase of phase modulation (deg)
%       s_rate = sampling rate (Hz)
%       dur = signal duration (s)
%

% sampling times
s_tim = [0:1/s_rate:dur];                           % creates time vector

% phase modulation
pm = (pmdpth*pi/180)*sin((2*pi*modrat*s_tim)+(pmphas*pi/180));
sig = caramp*(sin((2*pi*carfrq*s_tim)+(carphs*pi/180)-((pmdpth*pi/180)*sin((2*pi*modrat*s_tim)+(pmphas*pi/180)))));

% amplitude modulation
am = sin((2*pi*modrat*s_tim)+(amphas*pi/180));      % creates AM signal
amdpth = amdpth/100;                                % scales AM depth to a fraction
am = (am*amdpth)+1;                                 % scales AM signal
sig = sig.*am;                                      % adds AM to carrier signal

% remove last element
s_tim = s_tim(1:end-1);
sig = sig(1:end-1);
am = am(1:end-1);
pm = pm(1:end-1);