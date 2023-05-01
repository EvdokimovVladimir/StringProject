clear;
clc;

%% параметры
x_lim = [0 1];  % границы пространства
t_lim = [0 2];  % границы по времени
c = 1;          % скорость звука
dx = 10^-2;     % пространственный шаг

% внешняя сила
external_force = @(x, t) 0;
% начальное значение
initial_value = @(x) sin(pi * x);
% начальная скорость
initial_speed = @(x) 0;

% граничные условия
left_constrain = @(t) 0;
right_constrain = @(t) 0;

% аналитическое решение для сравнения
analytical = @(x, t) sin(pi * x) .* cos(pi * c * t);

%% расчет переменных
dt = dx / c;                % шаг по времени
x = x_lim(1):dx:x_lim(2);   % вектор значений коордитнаты
t = t_lim(1):dt:t_lim(2);   % вектор значений времени

% создание массива для решения
string = zeros(length(t), length(x));

% начальные условия
string(1, :) = initial_value(x);
string(2, :) = string(1, :) + dt * initial_speed(x);

% граничные условия
string(:, 1) = left_constrain(t);
string(:, end) = right_constrain(t);

% график начальных условий
% plot(x, String(1, :), "LineWidth", 2)

%% расчёт в цикле
tic
for i = 3:size(string, 1)
    for j = 2:(size(string, 2) - 1)
        string(i, j) = string(i - 1, j - 1) + string(i - 1, j + 1) - ...
            string(i - 2, j) + dt^2 * external_force(x(j), t(i));
    end
end
toc

%% расчёт аналитического решения
[X, T] = meshgrid(x, t);
analytical_string = analytical(X, T);

%% анимация
figure;
hold on
p = plot(x, string(1, :), ...
    "LineWidth", 2, "Color", "red", "DisplayName", "Численное решение");
pa = plot(x, analytical_string(1, :), ...
    "LineWidth", 2, "Color", "blue", "DisplayName", "Аналитическое решение");
s = subtitle("t = " + t(1));
xlabel("x");
ylabel("y");
xlim(x_lim)
ylim([min(string, [], "all") max(string, [], "all")])
legend;

% exportgraphics(gcf, "animation.gif");

% while true
    tic
    for i = 1:size(string, 1)
        p.YData = string(i, :);
        pa.YData = analytical_string(i, :);
        s.String = "t = " + t(i);
        drawnow
        pause(0.01)
%         exportgraphics(gcf, "animation.gif", Append = true);
    end
    toc;
% end
hold off

%% график всего
figure;
contour(X, T, string, "Fill", "on", "LineColor", "k", "LineWidth", 1);
xlabel("x");
ylabel("t");
c = colorbar;
c.Label.String = "y";
% saveas(gcf, "contour.png");

%% график ошибки
figure;
contour(X, T, abs(string - analytical_string), ...
    "Fill", "on", "LineColor", "k", "LineWidth", 1);
xlabel("x");
ylabel("t");
title("Отклонение численного решения от аналитического");
subtitle("max |\Deltay| = " + ...
    max(abs(string - analytical_string), [], "all"));
c = colorbar;
c.Label.String = "|\Deltay|";
% saveas(gcf, "contour.png");

max(abs(string - analytical_string), [], "all")