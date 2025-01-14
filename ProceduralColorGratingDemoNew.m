function ProceduralColorGratingDemo(color1,color2,baseColor)
% ProceduralColorGratingDemo() -- demo color grating procedural shader
% stimuli
%
%
% This demo shows how to use procedural color gratings. Color gratings 
% have two color sources, rather than one. They are a useful stimulus
% class for e.g. understanding opponenet color channels. The standard PTB
% grating shader cannot generate this class of grating. The procedural
% shader can generate sinusoidal or square wave gratings, and you can set a
% radial aperture.
%
%
% Optional Inputs are:
% color1 -- the first color of the grating, default is red [1 0 0 1]
% color2 -- the second color of the grating, default is green [0 1 0 1]
% baseColor -- the base color from which color1 and color2 are blended
% depending on contrast. Normally this would be set to your background
% color in PTB; default in this demo is the background color [0.5 0.5 0.5 1].
%
% History:
% 01/03/2020 initial version (Ian Andolina)

    % Round gray to integral number, to avoid roundoff artifacts with some
    % graphics cards:

if ~exist('color1','var') || isempty(color1)
    %     color1 = [gray-change gray-change gray-change 1];
    color1 = [0.75 0.75 0.75 1];
end

if ~exist('color2','var') || isempty(color2)
    color2 = [0.25 0.25 0.25 1];
end

if ~exist('baseColor','var') || isempty(baseColor)
    baseColor = [0.5 0.5 0.5 1];
end

% Setup defaults and unit color range:
PsychDefaultSetup(2);

% Disable synctests for this quick demo:
oldSyncLevel = Screen('Preference', 'SkipSyncTests', 2);

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
ifi = Screen('GetFlipInterval', win);

% Enable alpha-blending
% Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% default x + y size
virtualSize = 512;
% radius of the disc edge
radius = floor(virtualSize / 2);

% Build a procedural texture, we also keep the shader as we will show how to
% modify it (though not as efficient as using parameters in drawtexture)
texture = CreateProceduralColorGrating(ptbWindow, virtualSize, virtualSize,...
     color1, color2, radius);

% These settings are the parameters passed in directly to DrawTexture
% angle
angle = 45;
% phase
phase = 0;
% spatial frequency
frequency = 0.05;
% contrast
contrast = 0.5;
% sigma < 0 is a sinusoid.
sigma = -1.0;

% Preperatory flip
% showTime = 3;
vbl = Screen('Flip', win);
% tstart = vbl + ifi; %start is on the next frame
start_time = GetSecs;

while (GetSecs - start_time) < timing.StimuliDuration
    % Draw a message
    Screen('DrawText', win, 'Standard Color Sinusoidal Grating', 10, 10, [1 1 1]);
    % Draw the shader texture with parameters
    Screen('DrawTexture', win, texture, [], [],...
        angle, [], [], baseColor, [], [],...
        [phase, frequency, contrast, sigma]);

    vbl = Screen('Flip', win, vbl * ifi);
%     phase = phase - 15;
end

% Close onscreen window, release all resources:
sca;

% Restore old settings for sync-tests:
Screen('Preference', 'SkipSyncTests', oldSyncLevel);

