%
%   genstim.m
%       Creates stimulus waveform for PrimAff_IntFire.m
%

global tim sig ram rpm

% Initialize time variables
s_rate = 1000/tstep;
dur = tstop/1000;

% Set the EOD frequency
EODfrq = 400;

% Prepare pre-stimulus to avoid edge effects
[pre_tim,pre_sig] = modsine(EODfrq,0,10,0,0,0,0,0,s_rate,0.1);

% Prepare stimulus
if stim=='No Modulation ',
    [tim,sig] = modsine(EODfrq,0,10,0,0,0,0,0,s_rate,dur);
elseif stim=='Sinusoidal AM ',
    [tim,sig] = modsine(EODfrq,0,10,freq,amdepth,0,0,0,s_rate,dur);
elseif stim=='Sinusoidal PM ',
    [tim,sig] = modsine(EODfrq,0,10,freq,0,pmdepth,0,0,s_rate,dur);
elseif stim=='+DF           ',
    [tim,sig] = modsine(EODfrq,0,10,freq,amdepth,pmdepth,0,90,s_rate,dur);
elseif stim=='-DF           ',
    [tim,sig] = modsine(EODfrq,0,10,freq,amdepth,pmdepth,0,-90,s_rate,dur);
elseif stim=='Random AM     ',
    [tim,sig,ram,rpm] = blim_whnoise(EODfrq,10,s_rate,dur,freq,amdepth,1,0);
elseif stim=='Random PM     ',
    [tim,sig,ram,rpm] = blim_whnoise(EODfrq,10,s_rate,dur,freq,pmdepth,2,0);
elseif stim=='Random AM + PM',
    [tim,sig,ram,rpm] = blim_whnoise(EODfrq,10,s_rate,dur,freq,[amdepth pmdepth],3,0);
end
tim = [1000*pre_tim'; 1000*(tim+0.1)'];
sig = [pre_sig'; sig'];