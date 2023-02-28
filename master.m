        %% Master script for the OCC (Lea MA) study

% - Gabor matrices (400 trials)

%% General settings, screens and paths

% Set up MATLAB workspace
clear all;
close all;
clc;
try
    Screen('CloseAll');
end
rootFilepath = pwd; % Retrieve the present working directory

% define paths
PPDEV_PATH = '/home/methlab/Documents/MATLAB/ppdev-mex-master'; % For sending EEG triggers
TITTA_PATH = '/home/methlab/Documents/MATLAB/Titta'; % For Tobii ET
DATA_PATH = '/home/methlab/Desktop/LEAMA/data'; % Folder to save data
FUNS_PATH = '/home/methlab/Desktop/LEAMA' ; % Folder with all functions
MOV_PATH = '/home/methlab/Desktop/LEAMA'; % Folder with movie files

% make data dir, if doesn't exist yet
mkdir(DATA_PATH)
   
% add path to folder with functions
addpath(FUNS_PATH)

% manage screens
screenSettings

AssertOpenGL;

%% Collect ID and Age
dialogID;

%% Check keyboard number for GKI
dialogGKI;

%% Protect Matlab code from participant keyboard input
ListenChar(2);

%% Execute Tasks in randomized order
TRAINING = 0; % Training is set to 0 to allow the code in GaborMatrices.m to be easily adapted to a training condition.
BLOCK = 1;
TASK = 'Gratings';
StaticGratings;

%% Allow keyboard input into Matlab code
ListenChar(0);