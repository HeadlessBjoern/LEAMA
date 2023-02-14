%% Running 

% Imaging set up
    screenNumber=max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');
    PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
    PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');
%     Screen('Preference', 'SkipSyncTests', 0); % For linux


    % Window set-up
    [ptbWindow, winRect] = PsychImaging('OpenWindow', screenNumber);
    PsychColorCorrection('SetEncodingGamma', ptbWindow, equipment.gammaVals);
    [screenWidth, screenHeight] = RectSize(winRect);
    screenCentreX = round(screenWidth/2);
    screenCentreY = round(screenHeight/2);
    flipInterval = Screen('GetFlipInterval', ptbWindow);
    Screen('BlendFunction', ptbWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    experiment.runPriority = MaxPriority(ptbWindow);

    % Fix coordiantes for fixation cross
    stimulus.fixationSize_pix = round(stimulus.fixationSize_dva*equipment.ppm); % CHANGED PPD TO PPM HERE
    fixHorizontal = [round(-stimulus.fixationSize_pix/2) round(stimulus.fixationSize_pix/2) 0 0];
    fixVertical = [0 0 round(-stimulus.fixationSize_pix/2) round(stimulus.fixationSize_pix/2)];
    fixCoords = [fixHorizontal; fixVertical];

    % Set up stimulus parameters Fixation
    stimulus.fixationOn = 1;                % Toggle fixation on (1) or off (0)
    stimulus.fixationSize_dva = 2;         % Size of fixation cross in degress of visual angle
    stimulus.fixationColor = [1 0 0];       % Color of fixation cross (1 = white, 0 = black, [1 0 0] = red)
    stimulus.fixationLineWidth = 1;         % Line width of fixation cross




    