function varargout = PrimAff_IntFire(varargin)

%
%   PrimAff_IntFire.m
%       Runs Model Simulations of Primary Amplitude- and Time-Coding Electrosensory Afferents
%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PrimAff_IntFire_OpeningFcn, ...
                   'gui_OutputFcn',  @PrimAff_IntFire_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% Executes just before PrimAff_IntFire is made visible.
function PrimAff_IntFire_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for PrimAff_IntFire
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = PrimAff_IntFire_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Global Handles
global h
h = handles;

% Initialize Variables and Run Simulation
function pushbutton_runsim_Callback(hObject, eventdata, h);
global tstep tstop stim amdepth pmdepth freq thold sigma spk tim sig ram rpm
tstep = str2double(get(h.edit_sampper, 'String'));
tstop = 1000*str2double(get(h.edit_dur, 'String'));
stimulus = get(h.popupmenu_stim, 'String');
stim = char(stimulus(get(h.popupmenu_stim, 'Value')));
amdepth = str2double(get(h.edit_amd, 'String'));
pmdepth = str2double(get(h.edit_pmd, 'String'));
freq = str2double(get(h.edit_cutoff, 'String'));
thold = str2double(get(h.edit_thold, 'String'));
sigma = str2double(get(h.edit_noise, 'String'));
if (get(h.checkbox_view,'Value') == get(h.checkbox_view,'Max')),
    PrimAff
else
	set(hObject,'ForegroundColor',[1 0 0])
	disp(' ')
	disp('  Running Simulation...')
    genstim;
    [spk] = liandfrn(sig,tstep,thold,sigma,0.1,10,1);
    beg_dat = (100/tstep)+1;
    spk = spk(beg_dat:end);
    beep
	disp('  Simulation Complete.')
	disp(' ')
	set(hObject,'ForegroundColor',[1 1 1])
end

% Plot Simulation Results
function pushbutton_plot_Callback(hObject, eventdata, h);
global tstep tstop stim amdepth pmdepth freq thold sigma spk tim sig ram rpm
figure('Name','Primary Afferent Simulation Results','NumberTitle','off','Position',[96 300 1100 600],'Color',[1 1 1]);
a1 = subplot(211);
plot(tstep*[1:1:length(spk)],spk,'k-','LineWidth',2);
ylim(a1,[-0.1 1.1])
set(a1,'YTick', [])
set(a1,'YTickLabel', [])
xlim(a1,[0 tstop])
xlabel(a1,'Time (ms)')
set(a1,'FontName','Arial','FontSize',12,'Box','Off','TickDir','out')
a2 = subplot(212);
plot(tstep*[1:1:length(spk)],sig(length(sig)-length(spk)+1:end),'k-','LineWidth',2);
ylabel('Amplitude (mV)')
xlim(a1,[0 tstop])
xlabel(a1,'Time (ms)')
set(a2,'FontName','Arial','FontSize',12,'Box','Off','TickDir','out')
linkaxes([a1 a2],'x');
zoom on

% Option for Viewing Simulation
function checkbox_view_Callback(hObject, eventdata, h);

% Select Stimulus
function popupmenu_stim_CreateFcn(hObject, eventdata, h);
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function popupmenu_stim_Callback(hObject, eventdata, h);
global stim
stimulus = get(h.popupmenu_stim, 'String');
stim = char(stimulus(get(h.popupmenu_stim, 'Value')));

% AM Depth/Standard Deviation (%)
function edit_amd_CreateFcn(hObject, eventdata, h);
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_amd_Callback(hObject, eventdata, h);
global amdepth
amdepth = str2double(get(h.edit_amd, 'String'));

% PM Depth/Standard Deviation (deg)
function edit_pmd_CreateFcn(hObject, eventdata, h);
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_pmd_Callback(hObject, eventdata, h);
global pmdepth
pmdepth = str2double(get(h.edit_pmd, 'String'));

% Set Cutoff Frequency of Random Modulation/Modulation Rate of Sinusoidal Modulation
function edit_cutoff_CreateFcn(hObject, eventdata, h);
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_cutoff_Callback(hObject, eventdata, h);
global freq
freq = str2double(get(h.edit_cutoff, 'String'));

% Set Duration of Simulation
function edit_dur_CreateFcn(hObject, eventdata, h);
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_dur_Callback(hObject, eventdata, h);
global tstop
tstop = 1000*str2double(get(h.edit_dur, 'String'));

% Set Sampling Period of Simulation
function edit_sampper_CreateFcn(hObject, eventdata, h);
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_sampper_Callback(hObject, eventdata, h);
global tstep
tstep = str2double(get(h.edit_sampper, 'String'));

% Set Mean Threshold of Model Neuron
function edit_thold_CreateFcn(hObject, eventdata, h);
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_thold_Callback(hObject, eventdata, h);
global thold
thold = str2double(get(h.edit_thold, 'String'));

% Set Standard Deviation for Noise
function edit_noise_CreateFcn(hObject, eventdata, h);
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_noise_Callback(hObject, eventdata, h);
global sigma
sigma = str2double(get(h.edit_noise, 'String'));