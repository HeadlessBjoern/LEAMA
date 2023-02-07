function MovieDisplay(moviename, windowrect)
% Most simplistic demo on how to play a movie.
%
% SimpleMovieDemo(moviename [, windowrect=[]]);
%
% This bare-bones demo plays a single movie whose name has to be provided -
% including the full filesystem path to the movie - exactly once, then
% exits. This is the most minimalistic way of doing it. For a more complex
% demo see PlayMoviesDemo. The remaining demos show more advanced concepts
% like proper timing etc.
%
% The demo will play our standard DualDiscs.mov movie if the 'moviename' is
% omitted.

% History:
% 02/05/2009  Created. (MK)
% 06/17/2013  Cleaned up. (MK)
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

try
    % Open 'windowrect' sized window on screen, with black [0] background color:
    win = Screen('OpenWindow', whichScreen, 0, windowrect);
    
    % Open movie file:
    movie = Screen('OpenMovie', win, moviename);
    
    % Start playback engine:
    Screen('FillRect',ptbWindow,[1, 0, 0], Rec2plot); % Display red fixation cross
    Screen('Flip', whichScreen, [], 1)
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
    
    % Playback loop: Runs until end of movie or keypress:
    while ~KbCheck
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', win, movie);
        
        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end
        
        % Draw the new texture immediately to screen:
        Screen('DrawLines',ptbWindow,fixCoords,stimulus.fixationLineWidth,stimulus.fixationColor,[screenCentreX screenCentreY],2); % Draw fixation cross
        Screen('DrawTexture', win, tex);
        Screen('Flip', whichScreen, [], 1)

        % Update display:
%         Screen('Flip', win, [], 1);
        
        % Release texture:
        Screen('Close', tex);
    end
    
    % Stop playback:
    Screen('PlayMovie', movie, 0);
    
    % Close movie:
    Screen('CloseMovie', movie);
    
    % Close Screen, we're done:
    sca;
    
catch %#ok<CTCH>
    sca;
    psychrethrow(psychlasterror);
end

return
