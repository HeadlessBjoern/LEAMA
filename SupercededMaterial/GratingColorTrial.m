AssertOpenGL;

% Imaging set up
whichScreen = 1; 
screenID = whichScreen;
equipment.gammaVals = [1 1 1]; 
equipment.greyVal = .5;
Screen('Preference', 'SkipSyncTests', 0); % For lin.ux


PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');


[ptbWindow, winRect] = PsychImaging('OpenWindow', screenID, equipment.greyVal);
PsychColorCorrection('SetEncodingGamma', ptbWindow, equipment.gammaVals);
Screen('BlendFunction', ptbWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA')


angle = 90;

color1 = [0 0 0 1];
color2 = [1 1 1 1];
baseColor = [0.5 0.5 0.5 1];

% Setup defaults and unit color range:
PsychDefaultSetup(2);

% Disable synctests for this quick demo:
%             oldSyncLevel = Screen('Preference', 'SkipSyncTests', 2);

% Select screen with maximum id for output window:
% screenid = max(Screen('Screens'));

% Open a fullscreen, onscreen window with gray background. Enable 32bpc
% floating point framebuffer via imaging pipeline on it, if this is possible
% on your hardware while alpha-blending is enabled. Otherwise use a 16bpc
% precision framebuffer together with alpha-blending.
% PsychImaging('PrepareConfiguration');
% PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
% [win, winRect] = PsychImaging('OpenWindow', screenid, baseColor);

% Query frame duration: We use it later on to time 'Flips' properly for an
% animation with constant framerate:
ifi = Screen('GetFlipInterval', ptbWindow);

% Enable alpha-blending
% Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% default x + y size
virtualSize = 400;
% radius of the disc edge
radius = floor(virtualSize / 2);

% Build a procedural texture, we also keep the shader as we will show how to
% modify it (though not as efficient as using parameters in drawtexture)
texture = CreateProceduralColorGrating(ptbWindow, virtualSize*1.5, virtualSize,...
    color1, color2, radius);

% These settings are the parameters passed in directly to DrawTexture
%     angle = 45;
% phase
phase = 0;
% spatial frequency
frequency = 0.05;
% contrast
contrast = 0.2;
% sigma < 0 is a sinusoid.
sigma = -1.0;

% Preperatory flip
% showTime = 3;
vbl = Screen('Flip', ptbWindow);
% tstart = vbl + ifi; %start is on the next frame
start_time = GetSecs;

while (GetSecs - start_time) < 7
    % Draw a message
    %                 Screen('DrawText', ptbWindow, 'Standard Color Sinusoidal Grating', 10, 10, [1 1 1]);
    % Draw the shader texture with parameters
    Screen('DrawTexture', ptbWindow, texture, [], [],...
        angle, [], [], baseColor, [], [],...
        [phase, frequency, contrast, sigma]);

    vbl = Screen('Flip', ptbWindow, vbl * ifi);
    %     phase = phase - 15;
end


angle = 90;

color1 = [0 0 0 1];
color2 = [1 1 1 1];
baseColor = [0.5 0.5 0.5 1];

texture = CreateProceduralColorGrating(ptbWindow, virtualSize*1.5, virtualSize,...
    color1, color2, radius);
vbl = Screen('Flip', ptbWindow);
% tstart = vbl + ifi; %start is on the next frame
start_time = GetSecs;
contrast = 1;

while (GetSecs - start_time) < 7
    % Draw a message
    %                 Screen('DrawText', ptbWindow, 'Standard Color Sinusoidal Grating', 10, 10, [1 1 1]);
    % Draw the shader texture with parameters
    Screen('DrawTexture', ptbWindow, texture, [], [],...
        angle, [], [], baseColor, [], [],...
        [phase, frequency, contrast, sigma]);

    vbl = Screen('Flip', ptbWindow, vbl * ifi);
    %     phase = phase - 15;
end


% Preperatory flip
% showTime = 3;
vbl = Screen('Flip', ptbWindow);
% tstart = vbl + ifi; %start is on the next frame
start_time = GetSecs;

tex2 = CreateProceduralSineGrating(ptbWindow, 150, 100, [],[],0.5);
while (GetSecs - start_time) < 7
    % Draw a message
    %                 Screen('DrawText', ptbWindow, 'Standard Color Sinusoidal Grating', 10, 10, [1 1 1]);
    % Draw the shader texture with parameters
    Screen('DrawTexture', ptbWindow, tex2, [], [], 90, [], [], [], [], [phase+180, frequency, 0.5, 0]);

    vbl = Screen('Flip', ptbWindow, vbl * ifi);
    %     phase = phase - 15;
end



