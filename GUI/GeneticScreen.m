function varargout = GeneticScreen(varargin)
% GENETICSCREEN MATLAB code for GeneticScreen.fig
%      GENETICSCREEN, by itself, creates a new GENETICSCREEN or raises the existing
%      singleton*.
%
%      H = GENETICSCREEN returns the handle to a new GENETICSCREEN or the handle to
%      the existing singleton*.
%
%      GENETICSCREEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENETICSCREEN.M with the given input arguments.
%
%      GENETICSCREEN('Property','Value',...) creates a new GENETICSCREEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GeneticScreen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GeneticScreen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GeneticScreen

% Last Modified by GUIDE v2.5 30-Jul-2015 18:51:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GeneticScreen_OpeningFcn, ...
    'gui_OutputFcn',  @GeneticScreen_OutputFcn, ...
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


% --- Executes just before GeneticScreen is made visible.
function GeneticScreen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GeneticScreen (see VARARGIN)

% Choose default command line output for GeneticScreen
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
    set(handles.Genetic_Start,'Enable', 'on')
    
end

% UIWAIT makes GeneticScreen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GeneticScreen_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% GLOBAL VARIABLES
% population size
function r = getPopulationSize
global populationSize
r = populationSize;

% max generations
function r = getMaxGen
global maxGen
r = maxGen;

% crossover probability
function r = getCrossOverProb
global crossOverProb
r = crossOverProb;

% mutation probability
function r = getMutationProb
global mutationProb
r = mutationProb;

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
    set(handles.Genetic_Start,'Enable', 'on')
end


% Take the user back to the main screen
% --- Executes on button press in Back_Button.
function Back_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Back_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% create a handle/open the main screen, and close the current screen
WS_handle = WelcomeScreen;      % open main screen
delete(get(hObject, 'parent')); % close this screen


% Executes the genetic algorithm with the given inputs
function Genetic_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Genetic_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get the input data from appdata
courses = getappdata(0,'courses');
students = getappdata(0,'students');
rooms = getappdata(0,'rooms');
teachers = getappdata(0,'teachers');
days = getappdata(0,'days');
timeslots = getappdata(0,'timeslots');

[ values, valid ] = ValidateNumbers(getPopulationSize(), getMaxGen(), getCrossOverProb(), getMutationProb());
if ~valid, return; end

% disable buttons while the algorithm is running
set(handles.Genetic_Start,'Enable', 'off')
set(handles.Back_Button,'Enable', 'off')
set(handles.Cur_Best_label,'String', 'Current Best Fitness:');

% run the algorithm
[ bestFitness bestSolution fitnesses solutions ] = Genetic( ...
    courses, students, rooms, days, timeslots, ...
    values(1), values(2), values(3), values(4), handles );

% change the label to best fitness when the algorithm is complete
set(handles.Cur_Best_label,'String', 'Best Fitness:');

% print the schedule of the best solution
PrintSchedule(bestSolution);

% plot the best fitness/iteration graph
figure
plot(fitnesses');

% reenable the buttons
set(handles.Genetic_Start,'Enable', 'on')
set(handles.Back_Button,'Enable', 'on')


% updates the global population size
function Popsize_val_Callback(hObject, eventdata, handles)
% hObject    handle to Popsize_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global populationSize;
populationSize = get(hObject,'String');

% initialize the global population size
function Popsize_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Popsize_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global populationSize;
populationSize = get(hObject,'String');

% updates the global max generations
function Max_Gen_val_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Gen_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global maxGen;
maxGen = get(hObject,'String');

% initialize the global max generations
function Max_Gen_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Gen_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global maxGen;
maxGen = get(hObject,'String');


% updates the global crossover population
function Cross_Prob_val_Callback(hObject, eventdata, handles)
% hObject    handle to Cross_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global crossOverProb;
crossOverProb = get(hObject,'String');

% initialize the global corssover population
function Cross_Prob_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cross_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global crossOverProb;
crossOverProb = get(hObject,'String');


% updates the global mutation probability
function Mut_Prob_val_Callback(hObject, eventdata, handles)
% hObject    handle to Mut_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mutationProb;
mutationProb = get(hObject,'String');


% initialize the global mutation probability
function Mut_Prob_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mut_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global mutationProb;
mutationProb = get(hObject,'String');
