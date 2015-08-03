function varargout = SimulatedAnnealingScreen(varargin)
% SIMULATEDANNEALINGSCREEN MATLAB code for SimulatedAnnealingScreen.fig
%      SIMULATEDANNEALINGSCREEN, by itself, creates a new SIMULATEDANNEALINGSCREEN or raises the existing
%      singleton*.
%
%      H = SIMULATEDANNEALINGSCREEN returns the handle to a new SIMULATEDANNEALINGSCREEN or the handle to
%      the existing singleton*.
%
%      SIMULATEDANNEALINGSCREEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATEDANNEALINGSCREEN.M with the given input arguments.
%
%      SIMULATEDANNEALINGSCREEN('Property','Value',...) creates a new SIMULATEDANNEALINGSCREEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SimulatedAnnealingScreen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SimulatedAnnealingScreen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SimulatedAnnealingScreen

% Last Modified by GUIDE v2.5 30-Jul-2015 15:34:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SimulatedAnnealingScreen_OpeningFcn, ...
                   'gui_OutputFcn',  @SimulatedAnnealingScreen_OutputFcn, ...
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


% --- Executes just before SimulatedAnnealingScreen is made visible.
function SimulatedAnnealingScreen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SimulatedAnnealingScreen (see VARARGIN)

% Choose default command line output for SimulatedAnnealingScreen
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
    set(handles.SimulatedAnnealing_Start,'Enable', 'on')
    
end

% UIWAIT makes SimulatedAnnealingScreen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SimulatedAnnealingScreen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% GLOBAL VARIABLES
% max rejectoins
function r = getMaxRejections
    global maxRejections
    r = maxRejections;
    
% max runs
function r = getMaxRuns
    global maxRuns
    r = maxRuns;
    
% max accepts
function r = getMaxAccepts
    global maxAccepts
    r = maxAccepts;
    
% alpha
function r = getAlpha
    global alpha
    r = alpha;

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
    set(handles.SimulatedAnnealing_Start,'Enable', 'on')
end


% Take the user back to the main screen
function Back_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Back_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% create a handle/open the main screen, and close the current screen
WS_handle = WelcomeScreen;      % open main screen
delete(get(hObject, 'parent')); % close this screen


% Executes the simulated annealing with the given input parameters
function SimulatedAnnealing_Start_Callback(hObject, eventdata, handles)
% hObject    handle to SimulatedAnnealing_Start (see GCBO)
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
set(handles.SimulatedAnnealing_Start,'Enable', 'off')
set(handles.Back_Button,'Enable', 'off')
set(handles.Cur_Best_label,'String', 'Current Best Fitness:');

% generate initial solution and run the algorithm
[ schedule ] = GenerateInitialSolution(days, timeslots, courses, rooms);
[ bestFitness bestSolution fitnesses solutions ] = SimulatedAnnealing(schedule, rooms, students, getMaxRejections(), getMaxRuns(), getMaxAccepts(), getAlpha(), handles);

% change the label to best fitness when the algorithm is complete
set(handles.Cur_Best_label,'String', 'Best Fitness:');

% print the schedule of the best solution
PrintSchedule(bestSolution);

% plot the best fitness/iteration graph
figure
plot(fitnesses');

% reenable the buttons
set(handles.SimulatedAnnealing_Start,'Enable', 'on')
set(handles.Back_Button,'Enable', 'on')

% updates the global max number of rejections
function Max_Rejections_val_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Rejections_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global maxRejections;
maxRejections = str2double(get(hObject,'String'));


% initialize the global max number of rejections
function Max_Rejections_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Rejections_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global maxRejections;
maxRejections = str2double(get(hObject,'String'));


% updates the global number of max runs
function Max_Runs_val_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Runs_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global maxRuns;
maxRuns = str2double(get(hObject,'String'));


% initialize the global number of max runs
function Max_Runs_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Runs_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global maxRuns;
maxRuns = str2double(get(hObject,'String'));


% updates the global number of max accepts
function Max_Accepts_val_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Accepts_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global maxAccepts;
maxAccepts = str2double(get(hObject,'String'));


% initialize the global number of max accepts
function Max_Accepts_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Accepts_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global maxAccepts;
maxAccepts = str2double(get(hObject,'String'));

% updates the global alpha
function Alpha_val_Callback(hObject, eventdata, handles)
% hObject    handle to Alpha_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global alpha;
alpha = str2double(get(hObject,'String'));


% initialize the global alpha
function Alpha_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Alpha_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global alpha;
alpha = str2double(get(hObject,'String'));
