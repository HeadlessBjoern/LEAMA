function StatGrat_high_tilt45(angle, StimuliDuration, texsize, f, ptbWindow, screenID, greyVal)
% function DriftDemo6(angle, cyclespersecond, f)
% ___________________________________________________________________
%
% Parameters:
%
% angle = Angle of the gratings with respect to the vertical direction.
% cyclespersecond = Speed of gratings in cycles per second.
% f = Frequency of gratings in cycles per pixel.
%
% _________________________________________________________________________


% HISTORY
% 3/31/09 mk Written.

if nargin < 3 || isempty(f)
    % Grating cycles/pixel
    f = 0.04;
end

if nargin < 1 || isempty(angle)
    % Angle of the grating: We default to 30 degrees.
    angle = 45;
end

if nargin < 1 || isempty(StimuliDuration)
    % Abort demo after 60 seconds.
    StimuliDuration = 2;
end

if nargin < 1 || isempty(texsize)
    % Half-Size of the grating image: We default to 250.
    texsize = 250;
end

if nargin < 1 || isempty(ptbWindow)
    % Half-Size of the grating image: We default to 250.
    ptbWindow = 10;
end

if nargin < 1 || isempty(screenID)
    % Half-Size of the grating image: We default to 250.
    screenID = 1;
end

if nargin < 1 || isempty(greyVal)
    % Half-Size of the grating image: We default to 250.
    greyVal = 0.5;
end

% whichScreen = 1;  
% screenID = whichScreen;
% equipment.greyVal = .5;
% [ptbWindow, winRect] = PsychImaging('OpenWindow', screenID, equipment.greyVal);

% ptbWindow = 1;
try
%     ptbWindow = PsychImaging('OpenWindow', screenID, greyVal);
    AssertOpenGL;

    % Get the list of screens and choose the one with the highest screen number.
%     screenNumber=max(Screen('Screens'));


    % Find the color values which correspond to white and black.
    white=WhiteIndex(screenID);
    black=BlackIndex(screenID);

    % Round gray to integral number, to avoid roundoff artifacts with some
    % graphics cards:
    gray=round((white+black)/2);

    % This makes sure that on floating point framebuffers we still get a
    % well defined gray. It isn't strictly neccessary in this demo:
    if gray == white
        gray=white / 2;
    end
    inc=white-gray;

    % Open a double buffered fullscreen window with a gray background:
    %     w = Screen('OpenWindow',screenNumber, gray);

    % Enable alpha blending for typical drawing of masked textures:
    Screen('BlendFunction', ptbWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    % Make sure this GPU supports shading at all:
    AssertGLSL;

    % Create a special texture drawing shader for masked texture drawing:
    glsl = MakeTextureDrawShader(ptbWindow, 'SeparateAlphaChannel');

    % Calculate parameters of the grating:
    p=ceil(1/f); % pixels/cycle, rounded up.
    fr=f*2*pi;
    visiblesize=2*texsize+1;

    % Create one single static grating image:
    x = meshgrid(-texsize:texsize + p, -texsize:texsize);
    grating = gray + inc*cos(fr*x);

    % Create circular aperture for the alpha-channel:
    [x,y] = meshgrid(-texsize:texsize, -texsize:texsize);
    circle = white * (x.^2 + y.^2 <= (texsize)^2);

    % Set 2nd channel (the alpha channel) of 'grating' to the aperture
    % defined in 'circle':
    grating(:,:,2) = 0;
    grating(1:2*texsize+1, 1:2*texsize+1, 2) = circle;

    % Store alpha-masked grating in texture and attach the special 'glsl'
    % texture shader to it:
    gratingtex1 = Screen('MakeTexture', ptbWindow, grating, [], [], [], [], glsl);

    % Definition of the drawn source rectangle on the screen:
    srcRect = [0 0 visiblesize visiblesize];

    % Draw Texture, flip and wait for duration the stimuli should have
    Screen('DrawTexture', ptbWindow, gratingtex1, srcRect, [], angle);
    Screen('Flip', ptbWindow);
    WaitSecs(StimuliDuration)


    % The same commands wich close onscreen and offscreen windows also close textures.
%     sca;

catch
    % This "catch" section executes in case of an error in the "try" section
    % above. Importantly, it closes the onscreen window if it is open.
%     sca;
    psychrethrow(psychlasterror);

end %try..catch..
