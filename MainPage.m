function MainPage()

% Get the folder this file is stored in as the base folder
folder = fileparts(which('MainPage'));

% Add algorithm folders and their dependencies
addpath(strcat(folder, '/constraints'));
addpath(strcat(folder, '/TS'));
addpath(strcat(folder, '/SA'));
addpath(strcat(folder, '/GA'));
addpath(strcat(folder, '/ACO'));
addpath(strcat(folder, '/PSO'));
addpath(strcat(folder, '/BA'));

% Add GUI folder
addpath(strcat(folder, '/GUI'));

% Start GUI
WelcomeScreen;
