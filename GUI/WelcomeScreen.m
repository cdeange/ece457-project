function varargout = WelcomeScreen(varargin)
% WELCOMESCREEN MATLAB code for WelcomeScreen.fig
%      WELCOMESCREEN, by itself, creates a new WELCOMESCREEN or raises the existing
%      singleton*.
%
%      H = WELCOMESCREEN returns the handle to a new WELCOMESCREEN or the handle to
%      the existing singleton*.
%
%      WELCOMESCREEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WELCOMESCREEN.M with the given input arguments.
%
%      WELCOMESCREEN('Property','Value',...) creates a new WELCOMESCREEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WelcomeScreen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WelcomeScreen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WelcomeScreen

% Last Modified by GUIDE v2.5 31-Jul-2015 20:17:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WelcomeScreen_OpeningFcn, ...
                   'gui_OutputFcn',  @WelcomeScreen_OutputFcn, ...
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


% --- Executes just before WelcomeScreen is made visible.
function WelcomeScreen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WelcomeScreen (see VARARGIN)

% Choose default command line output for WelcomeScreen
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if isappdata(0,'fileName') == 1
    set(handles.FileName_Text,'String', getappdata(0,'fileName'));
end

% UIWAIT makes WelcomeScreen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WelcomeScreen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load_File.
function Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.csv','csv files'});
if ~isequal(filename,0)
    set(handles.FileName_Text,'String', fullfile(pathname, filename))
    [courses students rooms teachers days timeslots] = ReadInput(fullfile(pathname, filename)); 
   
    %set appdata variables to be passed to other guis
    setappdata(0,'courses',courses);
    setappdata(0,'students',students);
    setappdata(0,'rooms',rooms);
    setappdata(0,'teachers',teachers);
    setappdata(0,'days',days);
    setappdata(0,'timeslots',timeslots);
    setappdata(0,'fileName',fullfile(pathname, filename));
end

% --- Executes on button press in Tabu_Search.
function Tabu_Search_Callback(hObject, eventdata, handles)
% hObject    handle to Tabu_Search (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TS_handle = TabuSearchScreen; %open tabu search
delete(get(hObject, 'parent')); % close this screen


% --- Executes on button press in Particle_Swarm.
function Particle_Swarm_Callback(hObject, eventdata, handles)
% hObject    handle to Particle_Swarm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PSO_handle = ParticleSwarmScreen; %open tabu search
delete(get(hObject, 'parent')); % close this screen


% --- Executes on button press in Simulated_Annealing.
function Simulated_Annealing_Callback(hObject, eventdata, handles)
% hObject    handle to Simulated_Annealing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SA_handle = SimulatedAnnealingScreen; %open tabu search
delete(get(hObject, 'parent')); % close this screen


% --- Executes on button press in Genetic_Algorithm.
function Genetic_Algorithm_Callback(hObject, eventdata, handles)
% hObject    handle to Genetic_Algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GA_handle = GeneticScreen; %open tabu search
delete(get(hObject, 'parent')); % close this screen


% --- Executes on button press in Ant_Colony.
function Ant_Colony_Callback(hObject, eventdata, handles)
% hObject    handle to Ant_Colony (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ACO_handle = AntColonyScreen; %open tabu search
delete(get(hObject, 'parent')); % close this screen


% --- Executes on button press in Bat_Algorithm.
function Bat_Algorithm_Callback(hObject, eventdata, handles)
% hObject    handle to Bat_Algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BAT_handle = BatScreen; %open tabu search
delete(get(hObject, 'parent')); % close this screen
