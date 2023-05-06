clear;
clc;

%% параметры

x_lim = [0 1];  % границы пространства
y_lim = [0 1];  % границы пространства
t_lim = [0 2];  % границы по времени
c = 1;          % скорость звука
dx = 10^-2;     % размер ячейки
dt = 10^-2;     % шаг по времени

% location.x
% location.y
% location.z
% state.time
% внешняя сила
external_force = @(location, state) 0 .* location.x;
% начальное значение
initial_value = @(location) 0 .* location.x;
% начальная скорость
initial_speed = @(location) sin(2*pi * location.x) .* sin(2*pi * location.y);

% граничные условия
up_constrain = @(location, state) 0 .* location.x;
right_constrain = @(location, state) 0 .* location.x;
down_constrain = @(location, state) 0 .* location.x;
left_constrain = @(location, state) 0 .* location.x;

%% создание модели и задание геометрии

numberOfPDE = 1;
model = createpde(numberOfPDE);

% 4 линии в виде прямоугольника
gd = [2 2 2 2;
      x_lim(1) x_lim(2) x_lim(2) x_lim(1);
      x_lim(2) x_lim(2) x_lim(1) x_lim(1);
      y_lim(2) y_lim(2) y_lim(1) y_lim(1);
      y_lim(2) y_lim(1) y_lim(1) y_lim(2);
      0 0 0 0;
      1 1 1 1];

geometryFromEdges(model, gd);
specifyCoefficients(model, "m", 1, "d", 0, "c", c, "a", 0, "f", external_force);

%% задание начальных и граничных условий

setInitialConditions(model, initial_value, initial_speed);

applyBoundaryCondition(model, "dirichlet", ...
                             "Edge", 1, "u", up_constrain);
applyBoundaryCondition(model, "dirichlet", ...
                             "Edge", 2, "u", right_constrain);
applyBoundaryCondition(model, "dirichlet", ...
                             "Edge", 3, "u", down_constrain);
applyBoundaryCondition(model, "dirichlet", ...
                             "Edge", 4, "u", left_constrain);

%% график геометрии задачи
% pdegplot(model, "EdgeLabels", "on"); 
% ylim(y_lim);
% xlim(x_lim);
% title("Geometry With Edge Labels Displayed");
% xlabel("x");
% ylabel("y");

%% создание сетки
generateMesh(model, "Hmax", dx);

% figure
% pdemesh(model);
% ylim(y_lim);
% xlim(x_lim);
% xlabel("x");
% ylabel("y");

%% решение задачи

t = t_lim(1):dt:t_lim(2);
model.SolverOptions.ReportStatistics = 'on';

tic
result = solvepde(model, t);
toc

u = result.NodalSolution;

%%
figure
umax = max(max(u));
umin = min(min(u));



for i = 1:length(t)
    pdeplot(model, "XYData", u(:, i), "ZData", u(:, i), ...
                  "ZStyle", "continuous", "Mesh", "off", ...
                  "ColorMap", "default");
    axis([x_lim y_lim umin umax]); 
    caxis([umin umax]);
    ylim(y_lim);
    xlim(x_lim);
    xlabel("x");
    ylabel("y");
    zlabel("u");
    view(2)

    title("t = " + t(i))

    M(i) = getframe;
end












