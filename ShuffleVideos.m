
% Define proportions 
N1_2 = 140; % 70%
N3_4 = 60; % 30%

% create list of N1_2 * 1, N1_2 * 2, N3_4 * 3, and N3_4 * 4
videoselection = [zeros(N1_2,1) + 1; % maybe there's a simpler way to do this?
    zeros(N1_2,1) + 2;
    zeros(N3_4,1) + 3;
    zeros(N3_4,1) + 4];

% Shuffle the initial list and save it
rng(10) % 'set seed' so randperm always shuffles in the same way
videoselection_shuffled = videoselection(randperm(length(videoselection)));

% Loop for selecting the videos according to next diit in videoselection variable
for video = 1:length(videoselection_shuffled)
    if videoselection_shuffled(video) == 1
        % for checking the loop, text is displayed. This should be videos
        % later on. (like running a separate script that plays the respective video?)
        disp("high_skewed") 
    elseif videoselection_shuffled(video) == 2
        disp("low_skewed")
    elseif videoselection_shuffled(video) == 3
        disp("high_vertical")
    elseif videoselection_shuffled(video) == 4
        disp("low_vertical")
    end
end


