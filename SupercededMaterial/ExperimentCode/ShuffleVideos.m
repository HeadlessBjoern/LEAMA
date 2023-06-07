% Define proportions 
N_look = 35; % 70%
N_task = 15; % 30%

% create list of N_look * 8 and N_task * 8
videoselection = [
    zeros(N_look,1) + 1; 
    zeros(N_look,1) + 2;
    zeros(N_look,1) + 3;
    zeros(N_look,1) + 4;
    zeros(N_look,1) + 5;
    zeros(N_look,1) + 6;
    zeros(N_look,1) + 7;
    zeros(N_look,1) + 8;
    zeros(N_task,1) + 9;
    zeros(N_task,1) + 10;
    zeros(N_task,1) + 11;
    zeros(N_task,1) + 12;
    zeros(N_task,1) + 13;
    zeros(N_task,1) + 14;
    zeros(N_task,1) + 15;
    zeros(N_task,1) + 16];

% Shuffle the initial list and save it
rng(10) % 'set seed' so randperm always shuffles in the same way
videoSelection_shuffled = videoselection(randperm(length(videoselection)));
videoSequence = transpose(videoSelection_shuffled);
% 
% % Loop for selecting the videos according to next digit in videoselection variable
% for video = 1:length(videoSelection_shuffled)
%     if videoSelection_shuffled(video) == 1
%         % for checking the loop, text is displayed. This should be videos
%         % later on. (like running a separate script that plays the respective video?)
%         disp("high_skewed") 
%     elseif videoSelection_shuffled(video) == 2
%         disp("low_skewed")
%     elseif videoSelection_shuffled(video) == 3
%         disp("high_vertical")
%     elseif videoSelection_shuffled(video) == 4
%         disp("low_vertical")
%     end
% end
% 

