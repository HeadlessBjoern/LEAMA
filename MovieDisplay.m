function MovieDisplay(moviename, windowrect, whichScreen)
% 02/07/2023  Adapted for OCC LEAMA Gabor Matrices (AH)

% Check if Psychtoolbox is properly installed:
AssertOpenGL;

% moviename and windowrect are defined in GaborMatrices.m
% if nargin < 1 || isempty(moviename)
%     % No moviename given: Use our default movie:
%     moviename = [ PsychtoolboxRoot 'high.mov' ]; % hier habe ich schon mal versucht, einen Videonamen einzusetzen (Rest ist original)
% end
%
% if nargin < 2 || isempty(windowrect)
%     windowrect = [];
% end

% Wait until user releases keys on keyboard:
KbReleaseWait;

% Select screen for display of movie:
% whichScreen = max(Screen('Screens'));
% whichScreen is already defined in screenSettings.m

%% Start loop
try
    % Open 'windowrect' sized window on screen, with black [0] background color
    win = Screen('OpenWindow', whichScreen, 0, windowrect);

    % Open movie file
    movie = Screen('OpenMovie', win, moviename);

    % Start playback engine:
%     Screen('FillRect',ptbWindow,[1, 0, 0], Rec2plot); % Display red fixation cross
%     Screen('Flip', whichScreen, [], 1)
    Screen('PlayMovie', movie, 1);

    if videoSequence(thisTrial) == 1
        TRIGGER = PRESENTATION1;
    elseif videoSequence(thisTrial) == 2
        TRIGGER = PRESENTATION2;
    elseif videoSequence(thisTrial) == 3
        TRIGGER = PRESENTATION3;
    elseif videoSequence(thisTrial) == 4
        TRIGGER = PRESENTATION4;
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

    %% Playback loop

    % create keyboard monitoring queue with target buttons
    keyFlags = zeros(1,256); % an array of zeros
    keyFlags(spaceKeyCode) = 1; % monitor only spaces
    gki = GetKeyboardIndices;
    KbQueueCreate(gki, keyFlags); % initialize the Queue
    maxTime = GetSecs + 2; % Set maxTime to max. 2 seconds from start of video

    exitSignal = 0;
    % Start keyboard monitoring
    KbQueueStart;
    queueStartTime = GetSecs;
    while ~exitSignal
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', win, movie);

        % Valid texture returned? A negative value means end of movie reached:
        %         if tex<=0
        %             % We're done, break out of loop:
        %             break;
        %         end
        % Run video loop for 2 seconds, then break out of while loop

        % Run until runTime exceeds maxTime (2s)
        runTime = GetSecs;
        if runTime >= maxTime
            break;
        end

        % Draw the new texture immediately to screen:
%         Screen('DrawLines',ptbWindow,fixCoords,stimulus.fixationLineWidth,stimulus.fixationColor,[screenCentreX screenCentreY],2); % Draw fixation cross
        Screen('DrawTexture', win, tex);

        % Update display:
        % Screen('Flip', win, [], 1);
        Screen('Flip', whichScreen, [], 1)

        % Release texture:
        Screen('Close', tex);
    end
    % Stop keyboard monitoring
    KbQueueStop;
    % Get infos for key presses during KbQueue
    [~, firstPress, ~, ~, ~] = KbQueueCheck;
    % Get and save reaction time for each trial
    if firstPress > 0
        reactionTime(thisTrial) = firstPress - queueStartTime;
    elseif firstPress == 0
        reactionTime(thisTrial) = NaN;
    end
    % Remove all unprocessed events from the queue and zeros out any already scored events
    KbQueueFlush;
    % Release queue-associated resources
    KbQueueRelease;

    % Save responses (RESPONSE TIMESTAMPS ARE WRONG --> use reactionTime) and send triggers
    if firstPress > 0
        TRIGGER = RESP_CHANGE;
    elseif firstPress == 0
        TRIGGER = NO_RESP;
    end

    % send triggers
    if TRAINING == 1
        %             EThndl.sendMessage(TRIGGER,time);
        Eyelink('Message', num2str(TRIGGER));
        Eyelink('command', 'record_status_message "PRESENTATION"');
    else
        %             EThndl.sendMessage(TRIGGER,time);
        Eyelink('Message', num2str(TRIGGER));
        Eyelink('command', 'record_status_message "PRESENTATION"');
        sendtrigger(TRIGGER,port,SITE,stayup)
    end

    % Stop playback:
    Screen('PlayMovie', movie, 0);

    % Close movie:
    Screen('CloseMovie', movie);

    % Close Screen, we're done:
    sca;

catch
    sca;
    psychrethrow(psychlasterror);
end

return