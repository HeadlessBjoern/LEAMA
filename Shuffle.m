%% CREATE GRATING SEQUENCES

% Define proportions 
N_look = 25; % 70%
N_task = 25; % 30%

% create list of N_look * 8 and N_task * 8
gratingselection = [
    zeros(N_look + 25,1) + 1; % + 25 because need double amount of horizontal gratings
    zeros(N_look,1) + 2;
    zeros(N_look,1) + 3;
    zeros(N_look,1) + 4;
    zeros(N_look + 25,1) + 5; % + 25 because need double amount of horizontal gratings
    zeros(N_look,1) + 6;
    zeros(N_look,1) + 7;
    zeros(N_look,1) + 8;
    zeros(N_task + 25,1) + 9; % + 25 because need double amount of horizontal gratings
    zeros(N_task,1) + 10;
    zeros(N_task,1) + 11;
    zeros(N_task,1) + 12;
    zeros(N_task + 25,1) + 13; % + 25 because need double amount of horizontal gratings
    zeros(N_task,1) + 14;
    zeros(N_task,1) + 15;
    zeros(N_task,1) + 16];

% Shuffle the initial list and save it
rng(10) % 'set seed' so randperm always shuffles in the same way
gratingSelection_shuffled = gratingselection(randperm(length(gratingselection)));
gratingSeq= transpose(gratingSelection_shuffled);

% create four lists out of the one
gratingSequence1 = gratingSeq(:,1:125);
gratingSequence2 = gratingSeq(:,126:250);
gratingSequence3 = gratingSeq(:,251:375);
gratingSequence4 = gratingSeq(:,376:500);

%% CREATE CROSS SEQUENCES

% Define proportions 
N_look = 80; % 70%
N_cross = 20; % 30%

% create list of N_look * 8 and N_task * 8
crossSelection = [
    zeros(N_look,1);
    zeros(N_cross,1) + 1;];

% Shuffle the initial list and save it
rng(10) % 'set seed' so randperm always shuffles in the same way
crossSequence1 = transpose(crossSelection(randperm(length(crossSelection))));
rng(11) % 'set seed' so randperm always shuffles in the same way
crossSequence2 = transpose(crossSelection(randperm(length(crossSelection))));
rng(12) % 'set seed' so randperm always shuffles in the same way
crossSequence3 = transpose(crossSelection(randperm(length(crossSelection))));
rng(13) % 'set seed' so randperm always shuffles in the same way
crossSequence4 = transpose(crossSelection(randperm(length(crossSelection))));



