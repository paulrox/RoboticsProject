%% Initialize the toolbox
clear
%close all;
%clearvars;
%startup_rvc;

%% Robot arm configuration

% Arm links

R1 = Link('d', -0.9, 'a', 0.188, 'alpha', -pi/2);
R2 = Link('d', 0, 'a', 0.95, 'alpha', 0);
R3 = Link('d', 0, 'a', 0.225, 'alpha', -pi/2);
R4 = Link('d', -1.705, 'a', 0, 'alpha', pi/2);
R5 = Link('d', 0, 'a', 0, 'alpha', -pi/2);
R6 = Link('d', -0.2, 'a', 0, 'alpha', -pi/2);

arm = SerialLink([R1 R2 R3 R4 R5 R6], 'name', 'arm');

qn = [pi 0.7854 3.1416 0 0.7854 0];

% Platform links

P1 = Link('theta', 0, 'a', 0.5, 'alpha', -pi/2);
P2 = Link('theta',-pi/2, 'a', 1.5, 'alpha', 0);

platform = SerialLink([P1 P2], 'name', 'platform');
platform.base = trotx(pi/2);

robot = SerialLink([platform arm], 'name', 'robot');

%figure;

qn = [0 0 qn];

robot.plotopt = {'workspace' [-3 3 -3 3 -4 2] 'scale' 0.5, 'jvec'};
robot.plot(qn);

%% Task Objects

% Fruit tree object
Xtree = [-3 -3 -3 -3];
Ytree = [-3 -3 3 3];
Ztree = [-4 2 2 -4];
%fruit_tree = [3 -3 -4; 3 -3 2; -3 -3 2; -3 -3 -4];
%fruit_tree = [-3 -3 -4; -3 -3 2; -3 3 2; -3 3 -4];
fruit_tree = [Xtree; Ytree; Ztree]

% Fruit
C_fruit = [-3; 0; 0.5]
R_fruit = 0.15;

plot_poly(fruit_tree, 'fill', 'g');
plot_sphere(C_fruit, R_fruit, 'color', 'r');

%% Building a trajectory
N = 100;
dt = 2;
T0 = robot.fkine(qn);
T1 = transl(1, 0, 2) * robot.base;
TC = ctraj(T0, T1, N);
ve = [];

for i = 1: (N - 1)
    ve(i, :) = tr2delta(TC(:, :, i), TC(:, :, i+1)) / dt ;
end

J = jacob0(robot, qn);
qdot = pinv(J) * ve';

% Integration
q(1,:) = qn;
for i = 2: N
    q(i, :) = q(i-1, :) + (qdot(:, i-1)*dt)';
end
