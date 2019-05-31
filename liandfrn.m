function [spk] = liandfrn(sig,dt,thold,sigma,C,R,ref)

%
%   liandrn.m
%       Simulates a leaky integrate-and-fire neuron with noise
%   USAGE:
%       [spk] = liandfrn(sig,dt,thold,sigma,C,R,ref)
%   WHERE:
%       sig = input current signal (nA)
%       dt = samping step
%       thold = threshold (mV)
%       sigma = standard deviation of noise term (mV)
%       C = capacitance (nF)
%       R = resistance (MOhm)
%       ref = refractory period (ms)
%       spk = binned output spike train
%

% Ensure stability
if ((R*C)<dt),
    disp(' ');
    disp(' ');
    disp('Error: the time constant RC computed from the resistance');
    disp('and the capacitance of the model is smaller than the time');
    disp('step. Execution aborted.');
    error('???');
end   

% Run model
Vm = 0;                     % Initial resting potential
spk = zeros(1,length(sig)); % Initialize spike variable
i = 1;
while i<=length(spk),
    Vm = Vm*(1-dt/(R*C)) + (dt/C) * sig(i) + sigma*randn;   % Integrates the voltage
    if Vm>=thold,                                           % Above threshold
        spk(i) = 1;                                         % Generates a spike
        Vm = 0;                                             % Reset to resting potential
        i = i+(ref/dt);                                     % No spikes during refractory period
    else
        i = i+1;
    end
end