function varargout = MainPage(varargin)
    % MAINPAGE MATLAB code for MainPage.fig
    %      MAINPAGE, by itself, creates a new MAINPAGE or raises the existing
    %      singleton*.
    %
    %      H = MAINPAGE returns the handle to a new MAINPAGE or the handle to
    %      the existing singleton*.
    %
    %      MAINPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in MAINPAGE.M with the given input arguments.
    %
    %      MAINPAGE('Property','Value',...) creates a new MAINPAGE or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before MainPage_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to MainPage_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help MainPage

    % Last Modified by GUIDE v2.5 22-Jul-2015 17:51:25

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @MainPage_OpeningFcn, ...
                       'gui_OutputFcn',  @MainPage_OutputFcn, ...
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
end

% --- Executes just before MainPage is made visible.
function MainPage_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to MainPage (see VARARGIN)

    % Choose default command line output for MainPage
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    %set default globals
    global numDays;
    global numTimeSlots;
    global numCourses;
    global numStudents;
    global numRooms;
    global numFeatures;
    global numTeachers;
    global numEvents;
    
    numDays = 5;
    numTimeSlots = 5;
    numCourses = 1;
    numStudents = 1;
    numRooms = 1;
    numFeatures = 1;
    numTeachers = 1;
    numEvents = 1;
    

    % UIWAIT makes MainPage wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
end

%Global variables:
%numCourses
function r = getNumCourses
    global numCourses
    r = numCourses;
end

%numStudents
function r = getNumStudents
    global numStudents
    r = numStudents;
end

%numRooms
function r = getNumRooms
    global numRooms
    r = numRooms;
end

%numFeatures
function r = getNumFeatures
    global numFeatures
    r = numFeatures;
end

%numTeachers
function r = getNumTeachers
    global numTeachers
    r = numTeachers;
end

%numEvents
function r = getNumEvents
    global numEvents
    r = numEvents;
end

%numDays
function r = getNumDays
    global numDays
    r = numDays;
end

%numTimeSlots
function r = getNumTimeSlots
    global numTimeSlots
    r = numTimeSlots;
end

% --- Outputs from this function are returned to the command line.
function varargout = MainPage_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes on button press in TS.
function TS_Callback(hObject, eventdata, handles)
    % hObject    handle to TS (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    disable_Buttons(handles)
    [courses students rooms teachers events] = GenerateInput(getNumDays(),getNumTimeSlots(),getNumCourses(),getNumStudents(),getNumRooms(),getNumTeachers(),getNumEvents(), getNumFeatures());
    % call generate initial solution with these
    [initialSchedule] = GenerateInitialSolution(getNumDays(),getNumTimeSlots(),courses, students, rooms, teachers, events);
    % call TS with initial solution
    
    %printSchedule
    PrintSchedule(initialSchedule);
   
    %printCourses/rooms
    PrintCoursesRooms(initialSchedule, students);
    enable_Buttons(handles)
end

% --- Executes on button press in SA.
function SA_Callback(hObject, eventdata, handles)
    % hObject    handle to SA (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    disable_Buttons(handles)
    [courses students rooms teachers events] = GenerateInput(getNumDays(),getNumTimeSlots(),getNumCourses(),getNumStudents(),getNumRooms(),getNumTeachers(),getNumEvents(), getNumFeatures());
    % call generate initial solution with these
    [initialSchedule] = GenerateInitialSolution(getNumDays(),getNumTimeSlots(),courses, students, rooms, teachers, events);
    % call SA with initial solution
    enable_Buttons(handles)
end

% --- Executes on button press in GA.
function GA_Callback(hObject, eventdata, handles)
    % hObject    handle to GA (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    disable_Buttons(handles)
    [courses students rooms teachers events] = GenerateInput(getNumDays(),getNumTimeSlots(),getNumCourses(),getNumStudents(),getNumRooms(),getNumTeachers(),getNumEvents(), getNumFeatures());
    % call generate initial solution with these
    [initialSchedule] = GenerateInitialSolution(getNumDays(),getNumTimeSlots(),courses, students, rooms, teachers, events);
    % call GA with initial solution
    enable_Buttons(handles)
end

% --- Executes on button press in PSO.
function PSO_Callback(hObject, eventdata, handles)
    % hObject    handle to PSO (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    disable_Buttons(handles)
    [courses students rooms teachers events] = GenerateInput(getNumDays(),getNumTimeSlots(),getNumCourses(),getNumStudents(),getNumRooms(),getNumTeachers(),getNumEvents(), getNumFeatures());
    % call generate initial solution with these
    [initialSchedule] = GenerateInitialSolution(getNumDays(),getNumTimeSlots(),courses, students, rooms, teachers, events);
    % call PSO with initial solution
    enable_Buttons(handles)
end

% --- Executes on button press in ACO.
function ACO_Callback(hObject, eventdata, handles)
    % hObject    handle to ACO (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    disable_Buttons(handles)
    [courses students rooms teachers events] = GenerateInput(getNumDays(),getNumTimeSlots(),getNumCourses(),getNumStudents(),getNumRooms(),getNumTeachers(),getNumEvents(), getNumFeatures());
    % call generate initial solution with these
    [initialSchedule] = GenerateInitialSolution(getNumDays(),getNumTimeSlots(),courses, students, rooms, teachers, events);
    % call ACO with initial solution
    enable_Buttons(handles)
end

function disable_Buttons(handles)
    set(handles.TS,'Enable', 'off')
    set(handles.SA,'Enable', 'off')
    set(handles.GA,'Enable', 'off')
    set(handles.PSO,'Enable', 'off')
    set(handles.ACO,'Enable', 'off')
end

function enable_Buttons(handles)
    set(handles.TS,'Enable', 'on')
    set(handles.SA,'Enable', 'on')
    set(handles.GA,'Enable', 'on')
    set(handles.PSO,'Enable', 'on')
    set(handles.ACO,'Enable', 'on')
end



function numCourses_Callback(hObject, eventdata, handles)
    % hObject    handle to numCourses (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of numCourses as text
    %        str2double(get(hObject,'String')) returns contents of numCourses as a double
    global numCourses;
    numCourses = str2double(get(hObject,'String'));
    
    disp(getNumCourses());
end

% --- Executes during object creation, after setting all properties.
function numCourses_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to numCourses (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function numDays_Callback(hObject, eventdata, handles)
    % hObject    handle to numDays (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of numDays as text
    %        str2double(get(hObject,'String')) returns contents of numDays as a double
    global numDays;
    numDays = str2double(get(hObject,'String'));
    disp(getNumDays());
end

% --- Executes during object creation, after setting all properties.
function numDays_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to numDays (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function numEvents_Callback(hObject, eventdata, handles)
    % hObject    handle to numEvents (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of numEvents as text
    %        str2double(get(hObject,'String')) returns contents of numEvents as a double
    global numEvents;
    numEvents = str2double(get(hObject,'String'));
    disp(getNumEvents());
end

% --- Executes during object creation, after setting all properties.
function numEvents_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to numEvents (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function numTeachers_Callback(hObject, eventdata, handles)
    % hObject    handle to numTeachers (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of numTeachers as text
    %        str2double(get(hObject,'String')) returns contents of numTeachers as a double
    global numTeachers;
    numTeachers = str2double(get(hObject,'String'));
    disp(getNumTeachers());
end

% --- Executes during object creation, after setting all properties.
function numTeachers_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to numTeachers (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function numRooms_Callback(hObject, eventdata, handles)
    % hObject    handle to numRooms (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of numRooms as text
    %        str2double(get(hObject,'String')) returns contents of numRooms as a double
    global numRooms;
    numRooms = str2double(get(hObject,'String'));
    disp(getNumRooms());
end

% --- Executes during object creation, after setting all properties.
function numRooms_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to numRooms (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function numStudents_Callback(hObject, eventdata, handles)
    % hObject    handle to numStudents (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of numStudents as text
    %        str2double(get(hObject,'String')) returns contents of numStudents as a double
    global numStudents;
    numStudents = str2double(get(hObject,'String'));
    disp(getNumStudents());
end

% --- Executes during object creation, after setting all properties.
function numStudents_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to numStudents (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function numTimeSlots_Callback(hObject, eventdata, handles)
    % hObject    handle to numTimeSlots (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of numTimeSlots as text
    %        str2double(get(hObject,'String')) returns contents of numTimeSlots as a double
    global numTimeSlots;
    numTimeSlots = str2double(get(hObject,'String'));
    disp(getNumTimeSlots());
end

% --- Executes during object creation, after setting all properties.
function numTimeSlots_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to numTimeSlots (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function numFeatures_Callback(hObject, eventdata, handles)
    % hObject    handle to numFeatures (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of numFeatures as text
    %        str2double(get(hObject,'String')) returns contents of numFeatures as a double
    global numFeatures;
    numFeatures = str2double(get(hObject,'String'));
    disp(getNumFeatures());
end

% --- Executes during object creation, after setting all properties.
function numFeatures_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to numFeatures (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
