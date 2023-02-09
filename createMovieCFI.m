%% Create movie for CFI

%% Stuff
TRAINING = 0;
whichScreen = 1;

% Set up equipment parameters
equipment.viewDist = 800;               % Viewing distance in millimetres
equipment.ppm = 3.6;                    % Pixels per millimetre !! NEEDS TO BE SET. USE THE MeasureDpi FUNCTION !!
equipment.greyVal = .5;
equipment.blackVal = 0;
equipment.whiteVal = 1;
equipment.gammaVals = [1 1 1];          % The gamma values for color calibration of the monitor

% Set up stimulus parameters Fixation
stimulus.fixationOn = 1;                % Toggle fixation on (1) or off (0)
stimulus.fixationSize_dva = 2;         % Size of fixation cross in degress of visual angle
stimulus.fixationColor = [1 0 0];       % Color of fixation cross (1 = white, 0 = black, [1 0 0] = red)
stimulus.fixationLineWidth = 1;         % Line width of fixation cross

% Location
stimulus.regionHeight_dva = 7.3;         % Height of the region
stimulus.regionWidth_dva = 4;            % Width of the region
stimulus.regionEccentricity_dva = 3;     % Eccentricity of regions from central fixation

% Set up color parameters
stimulus.nColors = 2;                   % Number of colors used in the experiment
color.white = [255, 255, 255];
color.grey = [128, 128, 128];           % CHECK IF EXACT SAME GREY LIKE BACKGROUND OF GRATINGS
color.textVal = [1 0 0];                % Color of text (0 = black, 1 0 0 = red)
 
% Set up text parameters
text.instructionFont = 'Menlo';         % Font of instruction text
text.instructionPoints = 12;            % Size of instruction text (This if overwritten by )
text.instructionStyle = 0;              % Styling of instruction text (0 = normal)
text.instructionWrap = 80;              % Number of characters at which to wrap instruction text
text.color = 0;                         % Color of text (0 = black)
 
% Set font size for instructions and stimuli
% Screen('TextSize', ptbWindow, 40);

% Imaging set up
screenID = whichScreen;
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');
Screen('Preference', 'SkipSyncTests', 0); % For linux

% Window set-up
[ptbWindow, winRect] = PsychImaging('OpenWindow', screenID, equipment.greyVal);
PsychColorCorrection('SetEncodingGamma', ptbWindow, equipment.gammaVals);
[screenWidth, screenHeight] = RectSize(winRect);
screenCentreX = round(screenWidth/2);
screenCentreY = round(screenHeight/2);
flipInterval = Screen('GetFlipInterval', ptbWindow);
Screen('BlendFunction', ptbWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
experiment.runPriority = MaxPriority(ptbWindow);

global psych_default_colormode;                     % Sets colormode to be unclamped 0-1 range.
psych_default_colormode = 1;

global ptb_drawformattedtext_disableClipping;       % Disable clipping of text
ptb_drawformattedtext_disableClipping = 1;

% Retrieve response key
spaceKeyCode = KbName('Space'); % Retrieve key code for spacebar

% Calculate equipment parameters
equipment.mpd = (equipment.viewDist/2)*tan(deg2rad(2*stimulus.regionEccentricity_dva))/stimulus.regionEccentricity_dva; % Millimetres per degree
equipment.ppd = equipment.ppm*equipment.mpd;    % Pixels per degree

% Fix coordiantes for fixation cross
stimulus.fixationSize_pix = round(stimulus.fixationSize_dva*equipment.ppd);
fixHorizontal = [round(-stimulus.fixationSize_pix/2) round(stimulus.fixationSize_pix/2) 0 0];
fixVertical = [0 0 round(-stimulus.fixationSize_pix/2) round(stimulus.fixationSize_pix/2)];
fixCoords = [fixHorizontal; fixVertical];

% Define videoSequence and save
ShuffleVideos;
data.videoSequence = videoSequence;

%% 

% For demo only
Screen('Preference', 'SkipSyncTests', 2);

% % Setup and open screen
% PsychImaging('PrepareConfiguration');
% PsychImaging('AddTask', 'General', 'UseRetinaResolution');
% PsychImaging('FinalizeConfiguration');
 
% screenid = max(Screen('Screens'));
% [ptbWindow, winRect] = PsychImaging('OpenWindow', screenid);
  
% Start the movie now if requested
moviePtr = Screen('CreateMovie', ptbWindow, 'videoCFI.mp4');


% Drawing loop
while ~KbCheck
    Screen('DrawLines',ptbWindow,fixCoords,stimulus.fixationLineWidth,stimulus.fixationColor,[screenCentreX screenCentreY],2); % Draw fixation cross
    %     Screen('FillRect',ptbWindow,[.7 .7 .7]);
    %     DrawFormattedText(ptbWindow,superText,'center','center',color.textVal);
    Screen('Flip', ptbWindow)
    Screen('AddFrameToMovie', ptbWindow, winRect, [], moviePtr);
end
 
% Clean up and leave the building
Screen('FinalizeMovie', moviePtr);
sca