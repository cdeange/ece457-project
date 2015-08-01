function varargout = ParticleSwarmScreen(varargin)
% PARTICLESWARMSCREEN MATLAB code for ParticleSwarmScreen.fig
%      PARTICLESWARMSCREEN, by itself, creates a new PARTICLESWARMSCREEN or raises the existing
%      singleton*.
%
%      H = PARTICLESWARMSCREEN returns the handle to a new PARTICLESWARMSCREEN or the handle to
%      the existing singleton*.
%
%      PARTICLESWARMSCREEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARTICLESWARMSCREEN.M with the given input arguments.
%
%      PARTICLESWARMSCREEN('Property','Value',...) creates a new PARTICLESWARMSCREEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ParticleSwarmScreen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ParticleSwarmScreen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ParticleSwarmScreen

% Last Modified by GUIDE v2.5 30-Jul-2015 19:18:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ParticleSwarmScreen_OpeningFcn, ...
                   'gui_OutputFcn',  @ParticleSwarmScreen_OutputFcn, ...
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


% --- Executes just before ParticleSwarmScreen is made visible.
function ParticleSwarmScreen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ParticleSwarmScreen (see VARARGIN)

% Choose default command line output for ParticleSwarmScreen
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% If there is currently a schedule loaded, show that it is loaded and
% enable the start button
if (isappdata(0,'fileName') == 1 && ...
    isappdata(0,'courses') == 1 && ...
    isappdata(0,'students') == 1 && ...
    isappdata(0,'rooms') == 1 && ...
    isappdata(0,'teachers') == 1 && ...
    isappdata(0,'days') == 1 && ...
    isappdata(0,'timeslots') == 1)
    
    set(handles.FileName_Text,'String', getappdata(0,'fileName'));
    set(handles.Particle_Start,'Enable', 'on')
    
end
% UIWAIT makes ParticleSwarmScreen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ParticleSwarmScreen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% GLOBAL VARIABLES
% number of particles
function r = getNumParticles
    global numParticles
    r = numParticles;
   
% number of iterations
function r = getNumIterations
    global numIterations
    r = numIterations;
    
% probability for no change
function r = getNoChangeProb
    global noChangeProb
    r = noChangeProb;
    
% probability for random
function r = getRandomProb
    global randomProb
    r = randomProb;
    
% probability to take pbest
function r = getPbestProb
    global pbestProb
    r = pbestProb;
    
%probability to take gbest
function r = getGbestProb
    global gbestProb
    r = gbestProb;
    
% Used to load an input file into the program
function Load_File_Callback(hObject, eventdata, handles)
% hObject    handle to Load_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% show a browser with CSV files as the type
[filename, pathname] = uigetfile({'*.csv','csv files'});

% if the user did not click cancel
if ~isequal(filename,0)
    
    % set the file name and read in the file
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
   
    % allow the user to run the program if there was no error reading in
    % the file
    set(handles.Particle_Start,'Enable', 'on')
end



% Take the user back to the main screen
function Back_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Back_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% create a handle/open the main screen, and close the current screen
WS_handle = WelcomeScreen;      % open main screen
delete(get(hObject, 'parent')); % close this screen


% Executes the particle swarm algorithm with the given input parameters
function Particle_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Particle_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get the input data from appdata
courses = getappdata(0,'courses');
students = getappdata(0,'students');
rooms = getappdata(0,'rooms');
teachers = getappdata(0,'teachers');
days = getappdata(0,'days');
timeslots = getappdata(0,'timeslots');

% disable buttons while the algorithm is running
set(handles.Particle_Start,'Enable', 'off')
set(handles.Back_Button,'Enable', 'off')

% run the algorithm
[ bestSolution bestFitness fitnesses solutions ] = ParticleSwarm(getNumParticles(), days, timeslots, courses, rooms, students, getNumIterations(), getNoChangeProb(), getRandomProb(), getPbestProb(), getGbestProb(), handles);

% change the label to best fitness when the algorithm is complete
set(handles.Cur_Best_label,'String', 'Best Fitness');
% print the schedule of the best solution
PrintSchedule(bestSolution);

% plot the best fitness/iteration graph
figure
plot(fitnesses');

% reenable the buttons
set(handles.Particle_Start,'Enable', 'on')
set(handles.Back_Button,'Enable', 'on')


% updates the global number of particles
function Num_Parts_val_Callback(hObject, eventdata, handles)
% hObject    handle to Num_Parts_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global numParticles;
numParticles = str2double(get(hObject,'String'));


% initialize the global number of particles
function Num_Parts_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Num_Parts_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global numParticles;
numParticles = str2double(get(hObject,'String'));

% updates the global number of iterations
function Num_Iter_val_Callback(hObject, eventdata, handles)
% hObject    handle to Num_Iter_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global numIterations;
numIterations = str2double(get(hObject,'String'));

% initialize the global number of iterations
function Num_Iter_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Num_Iter_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global numIterations;
numIterations = str2double(get(hObject,'String'));

% updates the global probability for no change
function NoChange_Prob_val_Callback(hObject, eventdata, handles)
% hObject    handle to NoChange_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global noChangeProb;
noChangeProb = str2double(get(hObject,'String'));

% initialize the global probability for no change
function NoChange_Prob_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NoChange_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global noChangeProb;
noChangeProb = str2double(get(hObject,'String'));

% updates the global probability for taking pbest
function Pbest_Prob_val_Callback(hObject, eventdata, handles)
% hObject    handle to Pbest_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pbestProb;
pbestProb = str2double(get(hObject,'String'));


% initialize the global probability for taking pbest
function Pbest_Prob_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pbest_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global pbestProb;
pbestProb = str2double(get(hObject,'String'));

% updates the global probability for choosing random
function Random_Prob_val_Callback(hObject, eventdata, handles)
% hObject    handle to Random_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global randomProb;
randomProb = str2double(get(hObject,'String'));


% initialize the global probability for choosing random
function Random_Prob_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Random_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global randomProb;
randomProb = str2double(get(hObject,'String'));


% updates the global probability for taking gbest
function Gbest_Prob_val_Callback(hObject, eventdata, handles)
% hObject    handle to Gbest_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global gbestProb;
gbestProb = str2double(get(hObject,'String'));


% initialize the global probability for taking gbest
function Gbest_Prob_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gbest_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global gbestProb;
gbestProb = str2double(get(hObject,'String'));
