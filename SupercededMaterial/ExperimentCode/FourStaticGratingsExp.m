%% Gratings
%
% This script executes the paradigm with Gratings of Lea's MA.
%
% This code requires PsychToolbox. https://psychtoolbox.org
% This was tested with PsychToolbox version 3.0.15, and with MATLAB R2022a.

for BLOCK = 1 : 4
    % Start the actual task (EEG recording will start here, if TRAINING = 0)
    disp('GRATING TASK...');
    if BLOCK > 1
        WaitSecs(10);
    end


    %% EEG and ET
    if TRAINING == 0
        % Start recording EEG
        disp('STARTING EEG RECORDING...');
        initEEG;
        WaitSecs(10);
    end

    % Calibrate ET (Tobii Pro Fusion)
    disp('CALIBRATING ET...');
    calibrateET

    %% Task
    HideCursor(whichScreen);

    % define triggers
    TASK_START = 10;
    FIXATION0 = 15; % trigger for fixation cross
    FIXATION1 = 16; % trigger for fixation cross
    PRESENTATION1 = 21; % trigger for presentation of high horizontal
    PRESENTATION2 = 22; % trigger for presentation of high vertical
    PRESENTATION3 = 23; % trigger for presentation of high 45
    PRESENTATION4 = 24; % trigger for presentation of high 115
    PRESENTATION5 = 25; % trigger for presentation of low horizontal
    PRESENTATION6 = 26; % trigger for presentation of low vertical
    PRESENTATION7 = 27; % trigger for presentation of low 45
    PRESENTATION8 = 28; % trigger for presentation of low 115
    PRESENTATION9 = 30; 
    PRESENTATION10 = 31;
    PRESENTATION11 = 32;
    PRESENTATION12 = 33;
    PRESENTATION13 = 34;
    PRESENTATION14 = 35;
    PRESENTATION15 = 36;
    PRESENTATION16 = 37;
    STIMOFF = 29; % trigger for change of grating to cfi
    BLOCK0 = 39; % trigger for start of training block
    BLOCK1 = 40; % trigger for start of task (block)
    BLOCK2 = 41;
    BLOCK3 = 42;
    BLOCK4 = 43;
    ENDBLOCK0 = 49; % trigger for end of training block
    ENDBLOCK1 = 50; % trigger for end of task (block)
    ENDBLOCK2 = 51;
    ENDBLOCK3 = 52;
    ENDBLOCK4 = 53;
    RESP = 87; % trigger for response yes (spacebar)
    NO_RESP = 88; % trigger for response no (no input)
    RESP_WRONG = 89; % trigger for wrong keyboard input response
    TASK_END = 90;

    % Set up experiment parameters
    % Number of trials for the experiment
    if TRAINING == 1
        experiment.nGratings = 6;
        experiment.nTrials = experiment.nGratings * 2;   % for each grating video, there should be a fixation cross => hence nTrial should be nGratings times two
    else
        %  nGratings = 400; % or 100 if four blocks
        experiment.nGratings = 1;
        experiment.nTrials = experiment.nGratings * 2;   % for each grating video, there should be a fixation cross => hence nTrial should be nGratings times two
    end

    % Set up equipment parameters
    equipment.viewDist = 800;               % Viewing distance in millimetres
    equipment.ppm = 3.6;                    % Pixels per millimetre !! NEEDS TO BE SET. USE THE MeasureDpi FUNCTION !!
    equipment.greyVal = .5;
    equipment.blackVal = 0;
    equipment.whiteVal = 1;
    equipment.gammaVals = [1 1 1];          % The gamma values for color calibration of the monitor

    % Set up stimulus parameters Fixation
    stimulus.fixationOn = 1;                % Toggle fixation on (1) or off (0)
    stimulus.fixationSize_dva = .3;         % Size of fixation cross in degress of visual angle
    stimulus.fixationColor0 = [0 0 0];       % Color of fixation cross (1 = white, 0 = black, [1 0 0] = red)
    stimulus.fixationColor1 = [1 0 0];
    stimulus.fixationLineWidth = 1.3;         % Line width of fixation cross

    % Location
    stimulus.regionHeight_dva = 7.3;         % Height of the region
    stimulus.regionWidth_dva = 4;            % Width of the region
    stimulus.regionEccentricity_dva = 3;     % Eccentricity of regions from central fixation

    % Set up color parameters
    stimulus.nColors = 2;                   % Number of colors used in the experiment
    color.white = [255, 255, 255];
    color.grey = [128, 128, 128];
    color.textVal = 0;                      % Color of text (0 = black)

    % Set up text parameters
    text.instructionFont = 'Menlo';         % Font of instruction text
    text.instructionPoints = 12;            % Size of instruction text (This if overwritten by )
    text.instructionStyle = 0;              % Styling of instruction text (0 = normal)
    text.instructionWrap = 80;              % Number of characters at which to wrap instruction text
    text.color = 0;                         % Color of text (0 = black)

    % Define startExperimentText
    if TRAINING == 1
        loadingText = 'Loading training task...';
        startExperimentText = ['Training task: \n\n' ...
            'You will see a series of gratings. \n\n' ...
            'Your task is to press SPACE if you see \n\n' ...
            'a grating with a vertical orientation. \n\n' ...
            'Otherwise, do not press any button. \n\n' ...
            'Please always use your right hand.' ...
            '\n\n Don''t worry, you can do a training sequence in the beginning. \n\n' ...
            '\n\n Press any key to continue.'];
    elseif TRAINING == 0
        loadingText = 'Loading test task...';
        startExperimentText = ['Test task: \n\n' ...
            'You will see a series of gratings. \n\n' ...
            'Your task is to press SPACE if you see \n\n' ...
            'a red fixation cross. \n\n' ...
            'Otherwise, do not press any button. \n\n' ...
            'Please always use your right hand and look at the screen center.' ...
            '\n\n Press any key to continue.'];
    end

    % Set up temporal parameters (all in seconds)
    timing.blank = 1;                               % Duration of blank screen

    % Shuffle rng for random elements
    rng('default');
    rng('shuffle');                     % Use MATLAB twister for rng

    % Set up Psychtoolbox Pipeline
    AssertOpenGL;

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

    % Set font size for instructions and stimuli
    Screen('TextSize', ptbWindow, 40);

    global psych_default_colormode;                     % Sets colormode to be unclamped   0-1 range.
    psych_default_colormode = 1;

    global ptb_drawformattedtext_disableClipping;       % Disable clipping of text
    ptb_drawformattedtext_disableClipping = 1;

    % Show loading text
    DrawFormattedText(ptbWindow,loadingText,'center','center',color.textVal);
    Screen('Flip',ptbWindow);

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

    % Create data structure for preallocating data
    data = struct;
    data.trialMatch(1:experiment.nGratings) = NaN;
    data.allResponses(1:experiment.nGratings) = NaN;
    data.allCorrect(1:experiment.nGratings) = NaN;

    % Preallocate reaction time varible
    reactionTime(1:experiment.nGratings) = 0;

    % Define videoSequence and save
    Shuffle;
    if BLOCK == 1
        gratingSequence = gratingSequence1;
    elseif BLOCK == 2
        gratingSequence = gratingSequence2;
    elseif BLOCK == 3
        gratingSequence = gratingSequence3;
    elseif BLOCK == 4
        gratingSequence = gratingSequence4;
    end

    if BLOCK == 1
        crossSequence = crossSequence1;
    elseif BLOCK == 2
        crossSequence = crossSequence2;
    elseif BLOCK == 3
        crossSequence = crossSequence3;
    elseif BLOCK == 4
        crossSequence = crossSequence4;
    end

    data.GratingSequence = gratingSequence;
    data.CrossSequence = crossSequence;


    %% Show task instruction text
    DrawFormattedText(ptbWindow,startExperimentText,'center','center',color.textVal);
    % Screen('DrawDots',ptbWindow, backPos, backDiameter, backColor,[],1); % black background for photo diode
    startExperimentTime = Screen('Flip',ptbWindow);
    disp('Participant is reading the instructions.');
    waitResponse = 1;
    while waitResponse
        [time, keyCode] = KbWait(-1,2);
        waitResponse = 0;
    end

    % Send triggers: task starts. If training, send only ET triggers
    if TRAINING == 1
        %     EThndl.sendMessage(TASK_START); % ET
        Eyelink('Message', num2str(TASK_START));
        Eyelink('command', 'record_status_message "TASK_START"');
    else
        %     EThndl.sendMessage(TASK_START); % ET
        Eyelink('Message', num2str(TASK_START));
        Eyelink('command', 'record_status_message "TASK_START"');
        sendtrigger(TASK_START,port,SITE,stayup); % EEG
    end

    % Send triggers for block and output
    if TRAINING == 1 % Training condition
        TRIGGER = BLOCK0;
    elseif TRAINING == 0 && BLOCK == 1
        TRIGGER = BLOCK1;
    elseif TRAINING == 0 && BLOCK == 2
        TRIGGER = BLOCK1;
    elseif TRAINING == 0 && BLOCK == 3
        TRIGGER = BLOCK1;
    elseif TRAINING == 0 && BLOCK == 4
        TRIGGER = BLOCK1;
    end

    if TRAINING == 1
        %     EThndl.sendMessage(TRIGGER);
        Eyelink('Message', num2str(TRIGGER));
        Eyelink('command', 'record_status_message "START BLOCK"');
    else
        %     EThndl.sendMessage(TRIGGER);
        Eyelink('Message', num2str(TRIGGER));
        Eyelink('command', 'record_status_message "START BLOCK"');
        sendtrigger(TRIGGER,port,SITE,stayup);
    end

    if TRAINING == 1
        disp('Start of Training Block.');
    else
        disp(['Start of Block ' num2str(BLOCK)]);
    end
    HideCursor(whichScreen);

    %% Experiment Loop
    noFixation = 0;

    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');
    PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
    PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');


    [ptbWindow, winRect] = PsychImaging('OpenWindow', screenID, equipment.greyVal);
    PsychColorCorrection('SetEncodingGamma', ptbWindow, equipment.gammaVals);
    Screen('BlendFunction', ptbWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');




    %  ptbWindow = PsychImaging('OpenWindow', screenID, equipment.greyVal);
    for thisTrial = 1:experiment.nTrials
        %% Define thisGrating and thisCFI for usage as index
        thisGrating = thisTrial/2;
        thisCFI = round(thisTrial/2);


        %% Define stimulus or CFI trial
        moviename = '/home/methlab/Desktop/LEAMA/videoCFI.mp4';


        %% Start trial

        if mod(thisTrial,2) == 0
            disp(['Start of Trial ' num2str(thisGrating)]); % Output of current trial iteration
        end

        %     Screen('DrawDots',ptbWindow, backPos, backDiameter, backColor,[],1); % black background for photo diode
        %     Screen('Flip', ptbWindow);

        %     if thisTrial == 1
        %         Screen('DrawLines',ptbWindow,fixCoords,stimulus.fixationLineWidth,stimulus.fixationColor,[screenCentreX screenCentreY],2); % Draw fixation cross
        %         Screen('Flip', ptbWindow);
        %         TRIGGER = FIXATION;
        %
        %         if TRAINING == 1
        %             %         EThndl.sendMessage(TRIGGER);
        %             Eyelink('Message', num2str(TRIGGER));
        %             Eyelink('command', 'record_status_message "FIXATION"');
        %         else
        %             %         EThndl.sendMessage(TRIGGER);
        %             Eyelink('Message', num2str(TRIGGER));
        %             Eyelink('command', 'record_status_message "FIXATION"');
        %             sendtrigger(TRIGGER,port,SITE,stayup);
        %         end
        %     end
        %     Screen('FillRect',ptbWindow,[1, 0, 0], Rec2plot);


        %% Wait for release of possible keyboard presses
        KbReleaseWait;

        %% Play movie file with moviename

        % Select fixation cross or grid videos
        if mod(thisTrial,2) == 1
            % CFI trial
            if crossSequence(thisCFI) == 0
                TRIGGER = FIXATION0;
            elseif crossSequence(thisCFI) == 1
                TRIGGER = FIXATION1;
            end
        elseif mod(thisTrial,2) == 0
            % Stimulus trial
            if gratingSequence(thisGrating) == 1
                TRIGGER = PRESENTATION1;
            elseif gratingSequence(thisGrating) == 2
                TRIGGER = PRESENTATION2;
            elseif gratingSequence(thisGrating) == 3
                TRIGGER = PRESENTATION3;
            elseif gratingSequence(thisGrating) == 4
                TRIGGER = PRESENTATION4;
            elseif gratingSequence(thisGrating) == 5
                TRIGGER = PRESENTATION5;
            elseif gratingSequence(thisGrating) == 6
                TRIGGER = PRESENTATION6;
            elseif gratingSequence(thisGrating) == 7
                TRIGGER = PRESENTATION7;
            elseif gratingSequence(thisGrating) == 8
                TRIGGER = PRESENTATION8;
            elseif gratingSequence(thisGrating) == 9
                TRIGGER = PRESENTATION9;
            elseif gratingSequence(thisGrating) == 10
                TRIGGER = PRESENTATION10;
            elseif gratingSequence(thisGrating) == 11
                TRIGGER = PRESENTATION11;
            elseif gratingSequence(thisGrating) == 12
                TRIGGER = PRESENTATION12;
            elseif gratingSequence(thisGrating) == 13
                TRIGGER = PRESENTATION13;
            elseif gratingSequence(thisGrating) == 14
                TRIGGER = PRESENTATION14;
            elseif gratingSequence(thisGrating) == 15
                TRIGGER = PRESENTATION15;
            elseif gratingSequence(thisGrating) == 16
                TRIGGER = PRESENTATION16;
            end
        end

        if TRAINING == 1
            %         EThndl.sendMessage(TRIGGER);
            Eyelink('Message', num2str(TRIGGER));
            Eyelink('command', 'record_status_message "PRESENTATION"');
        else
            %         EThndl.sendMessage(TRIGGER);
            Eyelink('Message', num2str(TRIGGER));
            Eyelink('command', 'record_status_message "PRESENTATION"');
            sendtrigger(TRIGGER,port,SITE,stayup);
        end

        % Create keyboard monitoring queue with target buttons
        keyFlags = zeros(1,256); % An array of zeros
        keyFlags(spaceKeyCode) = 1; % Monitor only spaces
        % GetKeyboardIndices; % For checking keyboard number
        %  gki = 10; % has to be checked every time,that's why we created a dialog window now
        KbQueueCreate(gki, keyFlags); % Initialize the Queue

        % Set video duration
        if mod(thisTrial,2) == 1
            % CFI trial
            timing.cfi = (randsample(2000:6000, 1))/1000; % Randomize the jittered central fixation interval on trial
            maxTime = GetSecs + timing.cfi;
        elseif mod(thisTrial,2) == 0
            % Stimulus trial
            StimuliDuration = 2.5;
            maxTime = GetSecs + StimuliDuration; % Set maxTime to max. 2 seconds from start of video
        end

        % Start keyboard monitoring
        KbQueueStart(gki);
        queueStartTime = GetSecs;

        %% Display image of grating or movie of fixation cross
        %     ptbWindow = PsychImaging('OpenWindow', screenID, equipment.greyVal);
        if mod(thisTrial,2) == 1

            %% Present fixation cross

            start_time = GetSecs;

            while (GetSecs - start_time) < timing.cfi

                if crossSequence(thisCFI) == 0 % No task condition
                    Screen('DrawLines', ptbWindow, fixCoords,stimulus.fixationLineWidth,stimulus.fixationColor0,[screenCentreX screenCentreY],2);
                    Screen('Flip', ptbWindow)
                    WaitSecs(timing.cfi)
                elseif crossSequence(thisCFI) == 1 % Task condition
                    Screen('DrawLines', ptbWindow, fixCoords,stimulus.fixationLineWidth,stimulus.fixationColor1,[screenCentreX screenCentreY],2);
                    Screen('Flip', ptbWindow)
                    WaitSecs(timing.cfi)
                end

            end

        else

            %% Present grating depending on sequence number


            if gratingSequence(thisGrating) == 1
                angle = 90;
            elseif gratingSequence(thisGrating) == 2
                angle = 0;     % 35 times
            elseif gratingSequence(thisGrating) == 3
                angle = 45;       % 35 times
            elseif gratingSequence(thisGrating) == 4
                angle = 115;     % 35 times
            elseif gratingSequence(thisGrating) == 5
                angle = 90;    % 35 times
            elseif gratingSequence(thisGrating) == 6
                angle = 0;      % 35 times
            elseif gratingSequence(thisGrating) == 7
                angle = 45;        % 35 times
            elseif gratingSequence(thisGrating) == 8
                angle = 115;       % 35 times
            elseif gratingSequence(thisGrating) == 9
                angle = 90;   % 15 times
            elseif gratingSequence(thisGrating) == 10
                angle = 0;     % 15 times
            elseif gratingSequence(thisGrating) == 11
                angle = 45;       % 15 times
            elseif gratingSequence(thisGrating) == 12
                angle = 115;      % 15 times
            elseif gratingSequence(thisGrating) == 13
                angle = 90;    % 15 times
            elseif gratingSequence(thisGrating) == 14
                angle = 0;     % 15 times
            elseif gratingSequence(thisGrating) == 15
                angle = 45;       % 15 times
            elseif gratingSequence(thisGrating) == 16
                angle = 115;       % 15 times
            end

            StimuliDuration = 2;
            texsize = 200;
            greyVal = 0.5;
            f = 0.05;

            AssertOpenGL;

            % Find the color values which correspond to white and black.
            white = WhiteIndex(screenID);
            black = BlackIndex(screenID);

            % Round gray to integral number, to avoid roundoff artifacts with some graphics cards:
            gray = round((white+black)/2);

            % This makes sure that on floating point framebuffers we still get a
            % well defined gray. It isn't strictly neccessary in this demo:
            if gray == white
                gray = white / 2;
            end
            inc = white-gray;

            % Make sure this GPU supports shading at all:
            AssertGLSL;

            % Calculate parameters of the grating:
            p = ceil(1/f); % pixels/cycle, rounded up.
            fr = f*2*pi;
            visiblesize = 2*texsize+1;

            % Create one single static grating image:
            x = meshgrid(-texsize:texsize + p, -texsize:texsize);
            grating = gray + inc*cos(fr*x);

            % Create circular aperture for the alpha-channel:
            [x,y] = meshgrid(-texsize:texsize, -texsize:texsize);

            if gratingSequence(thisGrating) == 1 || gratingSequence(thisGrating) == 2 || gratingSequence(thisGrating) == 3 || gratingSequence(thisGrating) == 4 || gratingSequence(thisGrating) == 9|| gratingSequence(thisGrating) == 10 || gratingSequence(thisGrating) == 11|| gratingSequence(thisGrating) == 12
                circle = white * (x.^2 + y.^2 <= (texsize)^2);
            elseif gratingSequence(thisGrating) == 5 || gratingSequence(thisGrating) == 6 || gratingSequence(thisGrating) == 7 || gratingSequence(thisGrating) == 8 || gratingSequence(thisGrating) == 13 || gratingSequence(thisGrating) == 14 || gratingSequence(thisGrating) == 15 || gratingSequence(thisGrating) == 16
                circle = gray * (x.^2 + y.^2 <= (texsize)^2);
            end


            % Set 2nd channel (the alpha channel) of 'grating' to the aperture
            % defined in 'circle':
            grating(:,:,2) = 0;
            grating(1:2*texsize+1, 1:2*texsize+1, 2) = circle;

            % Store alpha-masked grating in texture:
            gratingtex1 = Screen('MakeTexture', ptbWindow, grating, [], [], [], []);

            % Definition of the drawn source rectangle on the screen:
            srcRect = [0 0 visiblesize visiblesize];

            start_time = GetSecs;

            while (GetSecs - start_time) < StimuliDuration
                % Draw Texture, flip and wait for duration the stimuli should have
                Screen('DrawTexture', ptbWindow, gratingtex1, srcRect, [], angle);
                Screen('Flip', ptbWindow);
                %             WaitSecs(StimuliDuration)
            end

        end



        % Stop keyboard monitoring
        KbQueueStop(gki);

        % Get infos for key presses during KbQueue (only for Gratings)
        [pressed, firstPress, ~, ~, ~] = KbQueueCheck(gki);

        if mod(thisTrial,2) == 1
            % Get and save reaction time for each trial
            if firstPress(spaceKeyCode) > 0
                reactionTime(thisCFI) = firstPress(spaceKeyCode) - queueStartTime;
            elseif firstPress(spaceKeyCode) == 0
                reactionTime(thisCFI) = NaN;
            end
        end

        % Remove all unprocessed events from the queue and zeros out any already scored events
        KbQueueFlush(gki);

        % Release queue-associated resources
        KbQueueRelease(gki);


        % Save responses as triggers (only for Gratings, always sent out after video is stopped)
        if mod(thisTrial,2) == 1
            % Save responses (RESPONSE TIMESTAMPS ARE WRONG --> use reactionTime) and send triggers
            if pressed > 0
                data.allResponses(thisCFI) = spaceKeyCode;
                TRIGGER = RESP;
            elseif pressed == 0
                data.allResponses(thisCFI) = 0;
                TRIGGER = NO_RESP;
            end
        end

        %     if TRAINING == 1
        %         %     EThndl.sendMessage(TRIGGER);
        %         Eyelink('Message', num2str(TRIGGER));
        %         Eyelink('command', 'record_status_message "END BLOCK"');
        %         disp('End of Training Block.');
        %     else
        %         %     EThndl.sendMessage(TRIGGER);
        %         Eyelink('Message', num2str(TRIGGER));
        %         Eyelink('command', 'record_status_message "END BLOCK"');
        %         sendtrigger(TRIGGER,port,SITE,stayup);
        %         disp(['End of Block ' num2str(BLOCK)]);
        %     end
        %     if mod(thisTrial,2) == 0
        %         % Stop playback:
        %         Screen('PlayMovie', movie, 0);
        %         % Close movie:
        %         Screen('CloseMovie', movie);

        %     end

        % Make photodiode area black again
        %     Screen('DrawDots',ptbWindow, backPos, backDiameter, backColor,[],1); % black background for photo diode
        %     Screen('Flip', ptbWindow);



        if mod(thisTrial,2) == 1
            % Check if response was correct (only for Gratings)
            if crossSequence(thisCFI) == 0 && data.allResponses(thisCFI) == 0 % Skewed + NO button press = correct answer
                data.allCorrect(thisCFI) = 1;
            elseif crossSequence(thisCFI) == 1 && data.allResponses(thisCFI) == spaceKeyCode % Vert + button press
                data.allCorrect(thisCFI) = 1;
            else
                data.allCorrect(thisCFI) = 0; % Wrong response
            end

            % Display (in-)correct response in CW (only for Gratings)
            if data.allCorrect(thisCFI) == 1
                feedbackText = 'Correct!';
            elseif data.allCorrect(thisCFI) == 0
                feedbackText = 'Incorrect!';
            end
            disp(['Response to Trial ' num2str(thisCFI) ' is ' feedbackText]);
        end



        %% Fixation Check

        %     % Check if subject fixate at center, give warning if not
        %     checkFixation;
        %     if noFixation > 2
        %         disp('Insufficient fixation!')
        %         noFixation = 0; % reset
        %     end

        %     Screen('DrawLines',ptbWindow,fixCoords,stimulus.fixationLineWidth,stimulus.fixationColor,[screenCentreX screenCentreY],2); % Draw fixation cross
        %     Screen('Flip', ptbWindow, [], 1);

        %% End for loop over all videos
    end

    % Wait a few seconds before continuing in order to record the last stimuli presentation
    WaitSecs(4)


    %% End task, save data and inform participant about accuracy and extra cash

    % Send triggers to end task
    endT = Screen('Flip',ptbWindow);
    if TRAINING == 1
        %     EThndl.sendMessage(TASK_END,endT);
        Eyelink('Message', num2str(TASK_END));
        Eyelink('command', 'record_status_message "TASK_END"');
    else
        %     EThndl.sendMessage(TASK_END,endT);
        Eyelink('Message', num2str(TASK_END));
        Eyelink('command', 'record_status_message "TASK_END"');
        sendtrigger(TASK_END,port,SITE,stayup)
    end

    % Send triggers for block and output
    if BLOCK == 1 && TRAINING == 0
        TRIGGER = ENDBLOCK1;
    elseif BLOCK == 1 && TRAINING == 1
        TRIGGER = ENDBLOCK0; % Training block
    end

    if TRAINING == 1
        %     EThndl.sendMessage(TRIGGER);
        Eyelink('Message', num2str(TRIGGER));
        Eyelink('command', 'record_status_message "END BLOCK"');
        disp('End of Training Block.');
    else
        %     EThndl.sendMessage(TRIGGER);
        Eyelink('Message', num2str(TRIGGER));
        Eyelink('command', 'record_status_message "END BLOCK"');
        sendtrigger(TRIGGER,port,SITE,stayup);
        disp(['End of Block ' num2str(BLOCK)]);
    end

    % Save data
    subjectID = num2str(subject.ID);
    filePath = fullfile(DATA_PATH, subjectID);
    mkdir(filePath)
    if TRAINING == 1
        fileName = [subjectID '_', TASK, num2str(BLOCK), '_training.mat'];
    elseif TRAINING == 0
        fileName = [subjectID '_', TASK, '_block' num2str(BLOCK), '_task.mat'];
    end

    % % Compute accuracy and report after each block (no additional cash for training task)
    % if TRAINING == 1
    %     % Get sum of correct responses, but ignore first and last data point
    %     totalCorrect = sum(data.allCorrect(1, 2:end-1));
    %     totalTrials = thisTrial-2;
    %     percentTotalCorrect = totalCorrect / totalTrials * 100;
    %     format bank % Change format for display
    %     feedbackBlockText = ['Your accuracy in the training task was ' num2str(percentTotalCorrect) ' %. '];
    %     disp(['Participant ' subjectID ' had an accuracy of ' num2str(percentTotalCorrect) ' % in the training task.'])
    %     DrawFormattedText(ptbWindow,feedbackBlockText,'center','center',color.textVal);
    %     format default % Change format back to default
    %     Screen('Flip',ptbWindow);
    %     WaitSecs(5);
    % elseif BLOCK == 1
    %     % Get sum of correct responses, but ignore first and last data point
    %     totalCorrect = sum(data.allCorrect(1, 2:end-1));
    %     totalTrials = thisTrial-2;
    %     percentTotalCorrect(BLOCK) = totalCorrect / totalTrials * 100;
    %     format bank % Change format for display
    %     if percentTotalCorrect(BLOCK) > 80
    %         amountCHFextra(BLOCK) = percentTotalCorrect(BLOCK)*0.02;
    %         feedbackBlockText = ['Your accuracy was ' num2str(percentTotalCorrect(BLOCK)) ' %. ' ...
    %             '\n\n Because of your accuracy you have been awarded an additional ' num2str(amountCHFextra(BLOCK)) ' CHF.' ...
    %             '\n\n Keep it up!'];
    %     elseif percentTotalCorrect(BLOCK) < 80 && BLOCK == 1
    %         amountCHFextra(BLOCK) = 0;
    %         feedbackBlockText = ['Your accuracy was ' num2str(percentTotalCorrect(BLOCK)) ' %. ' ...
    %             '\n\n Your accuracy was very low in this block. Please stay focused!'];
    %         disp(['Low accuracy in Block ' num2str(BLOCK) '.']);
    %     end
    %     DrawFormattedText(ptbWindow,feedbackBlockText,'center','center',color.textVal);
    %     disp(['Participant ' subjectID ' was awarded CHF ' num2str(amountCHFextra(BLOCK)) ' for an accuracy of ' num2str(percentTotalCorrect(BLOCK)) ' % in Block ' num2str(BLOCK) '.'])
    %     format default % Change format back to default
    %     Screen('Flip',ptbWindow);
    %     WaitSecs(5);
    % end

    % Save data
    saves = struct;
    saves.data = data;
    saves.data.spaceKeyCode = spaceKeyCode;
    saves.experiment = experiment;
    saves.screenWidth = screenWidth;
    saves.screenHeight = screenHeight;
    saves.screenCentreX = screenCentreX;
    saves.screenCentreY = screenCentreY;
    saves.startExperimentTime = startExperimentTime;
    saves.startExperimentText = startExperimentText;
    saves.stimulus = stimulus;
    saves.subjectID = subjectID;
    saves.subject = subject;
    saves.text = text;
    saves.timing = timing;
    saves.waitResponse = waitResponse;
    saves.flipInterval = flipInterval;
    saves.reactionTime = reactionTime;

    % Save triggers
    trigger = struct;
    trigger.TASK_START = TASK_START;
    trigger.FIXATION0 = FIXATION0;
    trigger.FIXATION1 = FIXATION1;
    trigger.PRESENTATION1 = PRESENTATION1;
    trigger.PRESENTATION2 = PRESENTATION2;
    trigger.PRESENTATION3 = PRESENTATION3;
    trigger.PRESENTATION4 = PRESENTATION4;
    trigger.STIMOFF = STIMOFF;
    trigger.BLOCK0 = BLOCK0;
    trigger.BLOCK1 = BLOCK1;
    trigger.BLOCK2 = BLOCK2;
    trigger.BLOCK3 = BLOCK3;
    trigger.BLOCK4 = BLOCK4;
    trigger.ENDBLOCK0 = ENDBLOCK0;
    trigger.ENDBLOCK1 = ENDBLOCK1;
    trigger.ENDBLOCK2 = ENDBLOCK2;
    trigger.ENDBLOCK3 = ENDBLOCK3;
    trigger.ENDBLOCK4 = ENDBLOCK4;
    trigger.RESP_YES = RESP;
    trigger.RESP_NO = NO_RESP;
    trigger.RESP_WRONG = RESP_WRONG;
    trigger.TASK_END = TASK_END;

    % stop and close EEG and ET recordings
    if TRAINING == 1
        disp('TRAINING FINISHED...');
    else
        disp(['BLOCK ' num2str(BLOCK) ' FINISHED...']);
    end
    disp('SAVING DATA...');
    save(fullfile(filePath, fileName), 'saves', 'trigger');
    closeEEGandET;

    try
        PsychPortAudio('Close');
    catch
    end

    % Show break instruction text
    if TRAINING == 1
        if percentTotalCorrect >= THRESH
            breakInstructionText = 'Well done! \n\n Press any key to start the actual task.';
        else
            breakInstructionText = ['Score too low! ' num2str(percentTotalCorrect) ' % correct. ' ...
                '\n\n Press any key to repeat the training task.'];
        end
    elseif BLOCK == 4 && TRAINING == 0
        breakInstructionText = ['End of the Task! ' ...
            '\n\n Thank you very much for your participation.'...
            '\n\n Please press any key to finalize the experiment.'];
    else
        breakInstructionText = ['Break! Rest for a while... ' ...
            '\n\n Press any key to start the mandatory break of at least 30 seconds.'];
    end

    DrawFormattedText(ptbWindow,breakInstructionText,'center','center',color.textVal);
    Screen('Flip',ptbWindow);
    waitResponse = 1;
    while waitResponse
        [time, keyCode] = KbWait(-1,2);
        waitResponse = 0;
    end

    % Create final screen
    if BLOCK == 4 && TRAINING == 0
        FinalText = ['You are done.' ...
            '\n\n Have a great day!'];
        DrawFormattedText(ptbWindow,FinalText,'center','center',color.textVal);
    Screen('Flip',ptbWindow);
    end

    % Wait at least 30 Seconds between Blocks (only after Block 1 has finished, not after Block 2)
    % if TRAINING == 1 && percentTotalCorrect < THRESH
    %     waitTime = 30;
    %     intervalTime = 1;
    %     timePassed = 0;
    %     printTime = 30;
    %
    %     waitTimeText = ['Please wait for ' num2str(printTime) ' seconds...' ...
    %         ' \n\n ' ...
    %         ' \n\n You can repeat the training task afterwards.'];
    %
    %     DrawFormattedText(ptbWindow,waitTimeText,'center','center',color.textVal);
    %     Screen('Flip',ptbWindow);
    %
    %     while timePassed < waitTime
    %         pause(intervalTime);
    %         timePassed = timePassed + intervalTime;
    %         printTime = waitTime - timePassed;
    %         waitTimeText = ['Please wait for ' num2str(printTime) ' seconds...' ...
    %             ' \n\n ' ...
    %             ' \n\n You can repeat the training task afterwards.'];
    %         DrawFormattedText(ptbWindow,waitTimeText,'center','center',color.textVal);
    %         Screen('Flip',ptbWindow);
    %     end
    % elseif BLOCK == 1 && TRAINING == 1
    %     waitTime = 30;
    %     intervalTime = 1;
    %     timePassed = 0;
    %     printTime = 30;
    %
    %     waitTimeText = ['Please wait for ' num2str(printTime) ' seconds...' ...
    %         ' \n\n ' ...
    %         ' \n\n The Grating task will start afterwards.'];
    %
    %     DrawFormattedText(ptbWindow,waitTimeText,'center','center',color.textVal);
    %     Screen('Flip',ptbWindow);
    %
    %     while timePassed < waitTime
    %         pause(intervalTime);
    %         timePassed = timePassed + intervalTime;
    %         printTime = waitTime - timePassed;
    %         waitTimeText = ['Please wait for ' num2str(printTime) ' seconds...' ...
    %             ' \n\n ' ...
    %             ' \n\n The Grating task will start afterwards.'];
    %         DrawFormattedText(ptbWindow,waitTimeText,'center','center',color.textVal);
    %         Screen('Flip',ptbWindow);
    %     end
    % end

    % Save total amount earned and display
    % if BLOCK == 1 && TRAINING == 0
    %     amountCHFextraTotal = sum(amountCHFextra);
    %     saves.amountCHFextraTotal = amountCHFextraTotal;
    %     format bank % Change format for display
    %     endTextCash = ['Well done! You have completed the task.' ...
    %         ' \n\n Because of your accuracy you have been awarded an additional ' num2str(amountCHFextraTotal) ' CHF in total.' ...
    %         ' \n\n ' ...
    %         ' \n\n ' num2str(percentTotalCorrect(1)) ' % accuracy earned you ' num2str(amountCHFextra(1)) ' CHF.' ...
    %         ' \n\n ' ...
    %         ' \n\n ' ...
    %         ' \n\n Press any key to end the task.'];
    %     DrawFormattedText(ptbWindow,endTextCash,'center','center',color.textVal); % Display output for participant
    %     disp(['End of Block ' num2str(BLOCK) '. Participant ' num2str(subjectID) ' has earned CHF ' num2str(amountCHFextraTotal) ' extra in total.']);
    %     statsCW = ['Participant' num2str(subjectID) ' earned ' num2str(amountCHFextra(1)) ' CHF for an accuracy of ' num2str(percentTotalCorrect(1)) '%'];
    %     disp(statsCW)
    %     format default % Change format back to default
    %     Screen('Flip',ptbWindow);
    %     waitResponse = 1;
    %     while waitResponse
    %         [time, keyCode] = KbWait(-1,2);
    %         waitResponse = 0;
    %     end
    % end
end



%% Close Psychtoolbox window
Screen('CloseAll');