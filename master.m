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
DATA_PATH  = [rootFilepath, '/data']; % Folder to save data
FUNS_PATH  = rootFilepath; % Folder with all functions
MOV_PATH  = rootFilepath; % Folder with movie files

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
% BLOCK = 1;
% TASK = 'G';
%T RAINING = 1; % After training, set to 0 here

if ~isfile([DATA_PATH, '/', num2str(subject.ID), '/', [num2str(subject.ID), '_Resting.mat']])
    restingEEG
end

if ~isfile([DATA_PATH, '/', num2str(subject.ID), '/', [num2str(subject.ID), '_training.mat']])
    TRAINING = 1;
    TASK = 'G';
    fourStaticGratingsWithTask;
end

if ~isfile([DATA_PATH, '/', num2str(subject.ID), '/', [num2str(subject.ID), '_G_block4.mat']])
    TRAINING = 0;
    TASK = 'G';
    fourStaticGratingsWithTask;
end

%% Don't forget to turn on the power again...
PowerOn;

%% Allow keyboard input into Matlab code
ListenChar(0);