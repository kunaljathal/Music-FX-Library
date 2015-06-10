% Kunal Jathal
% N19194426
% DST 2 - Assignment 3
% 
% Question 2
%
% The simplest Wah Wah 'Pedal' in the world.
% ===========================================


function varargout = WahWah_v1(varargin)
% WAHWAH_V1 MATLAB code for WahWah_v1.fig
%      WAHWAH_V1, by itself, creates a new WAHWAH_V1 or raises the existing
%      singleton*.
%
%      H = WAHWAH_V1 returns the handle to a new WAHWAH_V1 or the handle to
%      the existing singleton*.
%
%      WAHWAH_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAHWAH_V1.M with the given input arguments.
%
%      WAHWAH_V1('Property','Value',...) creates a new WAHWAH_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WahWah_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WahWah_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WahWah_v1

% Last Modified by GUIDE v2.5 28-Mar-2013 16:12:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WahWah_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @WahWah_v1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before WahWah_v1 is made visible.
function WahWah_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WahWah_v1 (see VARARGIN)

% Choose default command line output for WahWah_v1
handles.output = hObject;

%Initial Values

% Set initial slider values for the central freq, Q, and Gain
set(handles.Central, 'value', 0.5);
set(handles.Q, 'value', 0.5);
set(handles.Gain, 'value', 0.5);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WahWah_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WahWah_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function Central_Callback(hObject, eventdata, handles)
% hObject    handle to Central (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Central_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Central (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Gain_Callback(hObject, eventdata, handles)
% hObject    handle to Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Q_Callback(hObject, eventdata, handles)
% hObject    handle to Q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Read in the sound file.
[inputSignal, fs] = wavread('sounds/guitarRiff.wav');

%Get the central frequency value
fc = get(handles.Central, 'value');
fc = fc*(fs/2);

%Get the Q-value
Rp = get(handles.Q, 'value');

%Get the gain value
gain = get(handles.Gain, 'value');

%Calculate the analog frequency in radians
wT = (2*pi*fc*(1/fs));

%Enter the difference equation coefficients
b = [1 0 -2];
a = [1 -2*Rp*cos(wT) Rp^2];

%Calculte the frequency and phase response.
Y = filter(b, a, inputSignal);

% Apply Gain
wah = Y*gain;

% Play the original sound file first
soundsc(inputSignal, fs);

% Wait a bit
pause (0.5);

% Play the wah wah sound file next
soundsc(wah, fs);
