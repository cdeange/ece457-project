function varargout = AntColonyScreen(varargin)
% ANTCOLONYSCREEN MATLAB code for AntColonyScreen.fig
%      ANTCOLONYSCREEN, by itself, creates a new ANTCOLONYSCREEN or raises the existing
%      singleton*.
%
%      H = ANTCOLONYSCREEN returns the handle to a new ANTCOLONYSCREEN or the handle to
%      the existing singleton*.
%
%      ANTCOLONYSCREEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANTCOLONYSCREEN.M with the given input arguments.
%
%      ANTCOLONYSCREEN('Property','Value',...) creates a new ANTCOLONYSCREEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AntColonyScreen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AntColonyScreen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AntColonyScreen

% Last Modified by GUIDE v2.5 30-Jul-2015 20:29:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AntColonyScreen_OpeningFcn, ...
                   'gui_OutputFcn',  @AntColonyScreen_OutputFcn, ...
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


% --- Executes just before AntColonyScreen is made visible.
function AntColonyScreen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AntColonyScreen (see VARARGIN)

% Choose default command line output for AntColonyScreen
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if (isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1)
    
    set(handles.FileName_Text,'String', getappdata(0,'fileName'));
    set(handles.Ant_Start,'Enable', 'on')
    
end

% UIWAIT makes AntColonyScreen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AntColonyScreen_OutputFcn(hObject, eventdata, handles) 
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
   
    set(handles.Ant_Start,'Enable', 'on')
end

%numAnts
function r = getNumAnts
    global numAnts
    r = numAnts;
    
%numIterations
function r = getNumIterations
    global numIterations
    r = numIterations;
    
%rho
function r = getRho
    global rho
    r = rho;


% --- Executes on button press in Back_Button.
function Back_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Back_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WS_handle = WelcomeScreen; %open main search
delete(get(hObject, 'parent')); % close this screen


% --- Executes on button press in Ant_Start.
function Ant_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Ant_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
courses = getappdata(0,'courses');
students = getappdata(0,'students');
rooms = getappdata(0,'rooms');
teachers = getappdata(0,'teachers');
days = getappdata(0,'days');
timeslots = getappdata(0,'timeslots');
    
set(handles.Ant_Start,'Enable', 'off')
set(handles.Back_Button,'Enable', 'off')

%TODO = Khard
Khard = 1000;
Ksoft = 1;

[bestSolution bestFitness fitnesses solutions] = AntColony(courses, rooms, days, timeslots, getNumAnts(), students, getNumIterations(), Khard, Ksoft, getRho, handles);

set(handles.Cur_Best_label,'String', 'Best Fitness');

PrintSchedule(bestSolution);

figure
plot(fitnesses');

set(handles.Ant_Start,'Enable', 'on')
set(handles.Back_Button,'Enable', 'on')




function Num_Ants_val_Callback(hObject, eventdata, handles)
% hObject    handle to Num_Ants_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Num_Ants_val as text
%        str2double(get(hObject,'String')) returns contents of Num_Ants_val as a double
global numAnts;
numAnts = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Num_Ants_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Num_Ants_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global numAnts;
numAnts = str2double(get(hObject,'String'));



function Num_Iter_val_Callback(hObject, eventdata, handles)
% hObject    handle to Num_Iter_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Num_Iter_val as text
%        str2double(get(hObject,'String')) returns contents of Num_Iter_val as a double
global numIterations;
numIterations = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Num_Iter_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Num_Iter_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global numIterations;
numIterations = str2double(get(hObject,'String'));



function Rho_val_Callback(hObject, eventdata, handles)
% hObject    handle to Rho_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rho_val as text
%        str2double(get(hObject,'String')) returns contents of Rho_val as a double
global rho;
rho = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function Rho_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rho_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global rho;
rho = str2double(get(hObject,'String'));
