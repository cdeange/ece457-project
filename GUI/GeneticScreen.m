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

if (isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1 && ...
    isappdata(0,'fileName') == 1)
    
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
   
    set(handles.Genetic_Start,'Enable', 'on')
end

%populationSize
function r = getPopulationSize
    global populationSize
    r = populationSize;
    
%maxGen
function r = getMaxGen
    global maxGen
    r = maxGen;
    
%crossOverProb
function r = getCrossOverProb
    global crossOverProb
    r = crossOverProb;
    
%mutationProb
function r = getMutationProb
    global mutationProb
    r = mutationProb;


% --- Executes on button press in Back_Button.
function Back_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Back_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WS_handle = WelcomeScreen; %open main search
delete(get(hObject, 'parent')); % close this screen


% --- Executes on button press in Genetic_Start.
function Genetic_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Genetic_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
courses = getappdata(0,'courses');
students = getappdata(0,'students');
rooms = getappdata(0,'rooms');
teachers = getappdata(0,'teachers');
days = getappdata(0,'days');
timeslots = getappdata(0,'timeslots');
    
set(handles.Genetic_Start,'Enable', 'off')
set(handles.Back_Button,'Enable', 'off')
[ bestFitness bestSolution fitnesses solutions ] = Genetic( courses, students, rooms, days, timeslots, getPopulationSize(), getMaxGen(), getCrossOverProb(), getMutationProb(), handles );
set(handles.Cur_Best_label,'String', 'Best Fitness');

PrintSchedule(bestSolution);

figure
plot(fitnesses');

set(handles.Genetic_Start,'Enable', 'on')
set(handles.Back_Button,'Enable', 'on')



function Popsize_val_Callback(hObject, eventdata, handles)
% hObject    handle to Popsize_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Popsize_val as text
%        str2double(get(hObject,'String')) returns contents of Popsize_val as a double
global populationSize;
populationSize = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function Popsize_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Popsize_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global populationSize;
populationSize = str2double(get(hObject,'String'));


function Max_Gen_val_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Gen_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_Gen_val as text
%        str2double(get(hObject,'String')) returns contents of Max_Gen_val as a double
global maxGen;
maxGen = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function Max_Gen_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Gen_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global maxGen;
maxGen = str2double(get(hObject,'String'));



function Cross_Prob_val_Callback(hObject, eventdata, handles)
% hObject    handle to Cross_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cross_Prob_val as text
%        str2double(get(hObject,'String')) returns contents of Cross_Prob_val as a double
global crossOverProb;
crossOverProb = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function Cross_Prob_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cross_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global crossOverProb;
crossOverProb = str2double(get(hObject,'String'));



function Mut_Prob_val_Callback(hObject, eventdata, handles)
% hObject    handle to Mut_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mut_Prob_val as text
%        str2double(get(hObject,'String')) returns contents of Mut_Prob_val as a double
global mutationProb;
mutationProb = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Mut_Prob_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mut_Prob_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global mutationProb;
mutationProb = str2double(get(hObject,'String'));
