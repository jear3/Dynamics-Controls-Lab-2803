%{
Authors:  
Creation Date: 
Inputs:
Outputs: 
Purpose: Modeling a pilot simulator
%}
clc;
clear;
close all;
%% Legend
% #0 are required track sections
% #3 are flat track sections
% #5 are transitions
% #7 are flat track sections

%% Universal constants
m = 400; %kg
g = 9.81; %m/s^2

%% Variable Design Constants
% Constant slope - #1 Track piece
Section10_SlopeAngle = pi/4; %Rad
Section10_InitialHeight = 125; %m  
Section10_FinalHeight = 100; %m

% Transition from constant slope to Flat
Section15_TransitionRadius = linspace(1,25);

%{
for s = 0:24
    Section15_TransitionRadius(s+1) = (((4 * s^2) - (4 * s) + 2)^(3/2)) / 2; % m
end

Section15_ArclengthPlot = linspace(1,25);
Section15_TransitionArcLength = linspace(35.4,60.4,25);

Section15_TransitionAngle = linspace(35.4,60.4);

for s = 0:24
    Section15_TransitionAngle(s+1) = log(((4 * s^2) - (4 * s) + 2)^(3/2) / (2 * 2^(1/2)));
end
%}
s = linspace(0,25);
Section15_TransitionRadius = (((4 * s^2) - (4 * s) + 2)^(3/2)) / 2;
Section15_TransitionAngle = log(((4 * s^2) - (4 * s) + 2)^(3/2) / (2 * 2^(1/2)));

Section15_InitialHeight = Section10_FinalHeight; %m
Section15_FinalHeight = 83.2; %m

% Flat section
Section17_ArclengthPlot = linspace(60.4,100);

% Loop - #2 Track piece
Section20_LoopRadius = 50; %m , make this iterate from the starting angle to the ending angle
Section20_LoopArcLengthPlot = linspace(100,414.16);
Section20_LoopArcLength = linspace(0,314.16);
Section20_LoopAngle = Section20_LoopArcLength ./Section20_LoopRadius; %m

% Flat Track
Section23_ArclengthPlot = linspace(414.16,515.16);


% Transition from Flat track to Zero_g parabola
Section25_TransitionRadius = zeros(1,50); % m

for s = 0:49
    Section25_TransitionRadius(s+1) = (1/2) * ((1 + (4 * s^2))^(3/2));
end

Section25_TransitionArcLengthPlot = linspace(515.16, 565.16);
Section25_TransitionArcLength = linspace(515.16,565.16,50);

Section25_TransitionAngle = zeros(1,50);

for s = 0:49
    Section25_TransitionAngle(s+1) = log((1 + (4 * s^2))^(3/2));
end

% ZeroG Parabola - #3 Track piece
Section30_ZeroGParabolaArclengthPlot = linspace(565.16 , 665.16); % Maybe check this later

% Transition from Zero_g parabola to Flat
Section35_TransitionArcLengthPlot = linspace(665.16, 715.16);
Section35_TransitionArcLength = linspace(665.16,715.16,60);

Section35_TransitionRadius = zeros(1,50); %m

for s = 0:49
    Section35_TransitionRadius(s+1) = (1 + (10000 / (1 + s)^4))^(3/2) / abs(200 / (1 + s)^3);
end

Section35_TransitionAngle = zeros(0,50);

for s = 0:49
    Section35_TransitionAngle(s+1) = log((1 + (10000 / (1 + s)^4))^(3/2) / (5000.75 * abs(200 / (1 + s)^3)));
end

% Flat track
Section37_ArclengthPlot = linspace(715.16, 775.16);

% Transition from Flat to slope
Section45_TransitionRadius = zeros(1,25);

for s = 0:24
    Section45_TransitionRadius(s+1) = (1/2) * (1 + (4 * s^2))^(3/2);
end

Section45_ArclengthPlot = linspace(775.16,800.16);
Section45_Arclength = linspace(775.16,800.16,25);

Section45_TransitionAngle = zeros(1,25);

for s = 0:24
    Section45_TransitionAngle(s+1) = log((1 + (4 * s^2))^(3/2));
end

Section45_FinalHeight = 71.7;

% Constant Slope 
Section50_SlopeAngle = pi/4;
Section50_ArclengthPlot = linspace(800.16,850.16);
Section50_FinalHeight = 36.4;

%Transition
Section55_TransitionRadius = linspace(1,25);

for s = 0:24
    Section55_TransitionRadius(s+1) = (((4 * s^2) - (4 * s) + 2)^(3/2)) / 2; % m
end

Section55_ArclengthPlot = linspace(35.4,60.4);
Section55_TransitionArcLength = linspace(35.4,60.4,25);

Section55_TransitionAngle = linspace(1,25);

for s = 0:24
    Section55_TransitionAngle(s+1) = log(((4 * s^2) - (4 * s) + 2)^(3/2) / (2 * 2^(1/2)));
end

Section55_InitialHeight = Section50_FinalHeight; %m
Section55_FinalHeight = 19.6; %m

% Banked turn
Section60_Radius = 159.16;
Section60_Arclength = linspace(0,500);


%% Equations of motion
% Constant slope G-force
Section10_Gforce = cos(Section10_SlopeAngle);
% Constant slope Exit Velocity
Section10_Velocity = sqrt(2*g*(Section10_InitialHeight - Section10_FinalHeight));

% Transition from constant slope to Flat - G Force
Section15_Gforce = sin(Section15_TransitionAngle) - (Section10_Velocity^2 ./ (g * Section15_TransitionRadius));
% Transition from constant slope to Flat - Exit Velocity
Section15_Velocity = sqrt(2*g*(Section10_InitialHeight - Section15_FinalHeight));

% Flat track from Transition to Loop - G Force
Section17_Gforce = 1;
% Flat track from Transition to Loop - Exit Velocity
Section17_Velocity = Section15_Velocity;

% Loop G-force
Section20_Gforce = (Section17_Velocity^2 / (g * Section20_LoopRadius)) - sin(Section20_LoopAngle);
% Loop Exit Velocity
Section20_Velocity = Section17_Velocity;

% Flat track from Loop to Transition - G Force
Section23_Gforce = 1;
% Flat track from Loop to Transition - Exit Velocity
Section23_Velocity = Section20_Velocity;

% Transition from flat track to Zero-G parabola - G Force
Section25_Gforce = sin(Section25_TransitionAngle) - (Section23_Velocity^2 ./ (g .* Section25_TransitionRadius));
% Transition from flat track to Zero-G parabola - Exit Velocity
Section25_Velocity = Section23_Velocity; 

% Zero-G parabola - G Force
Section30_Gforce = 0;
% Zero-G parabola - Exit Velocity
Section30_Velocity = Section25_Velocity;

% Transition from Zero-G parabola to Flat - G Force
Section35_Gforce = sin(Section35_TransitionAngle) - (Section30_Velocity^2 ./ (g .* Section35_TransitionRadius));
% Transition from Zero-G parabola to Flat - Exit Velocity
Section35_Velocity = Section30_Velocity; 

% Flat track - G Force
Section37_Gforce = 1;
Section37_Velocity = Section35_Gforce;

% Transition from flat to slope - G force
Section45_Gforce = sin(Section45_TransitionAngle) - (Section35_Velocity^2 ./ (g * Section45_TransitionRadius));
Section45_Velocity = sqrt(2*g*(Section10_InitialHeight - Section45_FinalHeight));

% Constant slope - G Force
Section50_Gforce = cos(Section50_SlopeAngle);
Section50_Velocity = sqrt(2*g*(Section10_InitialHeight - Section50_FinalHeight));

% Transition
Section55_Gforce = sin(Section55_TransitionAngle) - (Section50_Velocity^2 ./ (g .* Section55_TransitionRadius));
Section55_Velocity = sqrt(2*g*(Section10_InitialHeight - Section55_FinalHeight));

% Transition into banked turn
Section60_Gforce = 1 / cos(atan(Section55_Velocity^2 ./ g .* Section60_Radius));
Section60_Velocity = Section55_Velocity;

%{
% Banked turn
Section70_ArclengthPlot = linspace(1009.56, 1249); % Define track range
Section70_Distance = 239.44; % Braking distance

% Initial velocity at braking start
Section70_InitialVelocity = Section60_Velocity; % section before velocity=inital velocity

% find deceleration
%Section70_RequiredDeceleration = - (Section70_InitialVelocity^2) / (2 * Section70_Distance);

% does not exceed 4G
%Section70_Deceleration = max((-(Section70_InitialVelocity^2) / (2 * Section70_Distance)), -4*g); 

% Compute braking G-force
Section70_Gforce = abs((max((-(Section70_InitialVelocity^2) / (2 * Section70_Distance)), -4*g)) / g);
%}

% G-force piece wise function
x = linspace(0,1249,30000);
y = Piecewise_function(x, g, Section10_SlopeAngle, Section10_Velocity,Section15_TransitionRadius, ...
    Section15_TransitionArcLength, Section17_Velocity, Section20_LoopRadius, ...
    Section20_LoopArcLength, Section23_Velocity, Section25_TransitionRadius, ...
    Section25_TransitionArcLength, Section30_Velocity, Section35_TransitionRadius, Section35_TransitionArcLength,...
    Section35_Velocity, Section45_TransitionRadius, Section45_Arclength, Section50_SlopeAngle);

plot(x, y, 'b-', 'LineWidth', 2); % Blue line with thickness 2
xlabel('Position on coaster (m)'); % Replace with actual label
ylabel('G-force'); % Replace with actual label
title('G-force felt normal to the pilots seat');
grid on;
