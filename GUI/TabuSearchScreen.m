function varargout = TabuSearchScreen(varargin)
% TABUSEARCHSCREEN MATLAB code for TabuSearchScreen.fig
%      TABUSEARCHSCREEN, by itself, creates a new TABUSEARCHSCREEN or raises the existing
%      singleton*.
%
%      H = TABUSEARCHSCREEN returns the handle to a new TABUSEARCHSCREEN or the handle to
%      the existing singleton*.
%
%      TABUSEARCHSCREEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABUSEARCHSCREEN.M with the given input arguments.
%
%      TABUSEARCHSCREEN('Property','Value',...) creates a new TABUSEARCHSCREEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TabuSearchScreen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TabuSearchScreen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TabuSearchScreen

% Last Modified by GUIDE v2.5 30-Jul-2015 12:15:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TabuSearchScreen_OpeningFcn, ...
                   'gui_OutputFcn',  @TabuSearchScreen_OutputFcn, ...
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


% --- Executes just before TabuSearchScreen is made visible.
function TabuSearchScreen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TabuSearchScreen (see VARARGIN)

% Choose default command line output for TabuSearchScreen
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
    set(handles.Tabu_Start,'Enable', 'on')
    
end

% UIWAIT makes TabuSearchScreen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TabuSearchScreen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Back_Button.
function Back_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Back_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WS_handle = WelcomeScreen; %open main search
delete(get(hObject, 'parent')); % close this screen
    
%tabuListLength
function r = getTabuListLength
    global tabuListLength
    r = tabuListLength;
    
%iterations
function r = getNumIterations
    global numIterations
    r = numIterations;


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
   
    set(handles.Tabu_Start,'Enable', 'on')
end


% --- Executes on button press in Tabu_Start.
function Tabu_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Tabu_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
courses = getappdata(0,'courses');
students = getappdata(0,'students');
rooms = getappdata(0,'rooms');
teachers = getappdata(0,'teachers');
days = getappdata(0,'days');
timeslots = getappdata(0,'timeslots');
    
set(handles.Tabu_Start,'Enable', 'off')
set(handles.Back_Button,'Enable', 'off')
[ schedule ] = GenerateInitialSolution(days, timeslots, courses, rooms);
[ bestFitness bestSolution fitnesses solutions ] = TabuSearch(schedule, rooms, getTabuListLength(), students, getNumIterations(), handles);
set(handles.Cur_Best_label,'String', 'Best Fitness');

PrintSchedule(bestSolution);
set(handles.Tabu_Start,'Enable', 'on')
set(handles.Back_Button,'Enable', 'on')



function Tabu_ListLength_Callback(hObject, eventdata, handles)
% hObject    handle to Tabu_ListLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tabu_ListLength as text
%        str2double(get(hObject,'String')) returns contents of Tabu_ListLength as a double
global tabuListLength;
tabuListLength = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Tabu_ListLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tabu_ListLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global tabuListLength;
tabuListLength = str2double(get(hObject,'String'));



function Tabu_Iterations_Callback(hObject, eventdata, handles)
% hObject    handle to Tabu_Iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tabu_Iterations as text
%        str2double(get(hObject,'String')) returns contents of Tabu_Iterations as a double
global numIterations;
numIterations = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Tabu_Iterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tabu_Iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global numIterations;
numIterations = str2double(get(hObject,'String'));
