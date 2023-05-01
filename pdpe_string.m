clear
clc

%%
x = linspace(0, 1, 101);
t = linspace(0, 1, 101);
m = 0;
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

sol = pdepe(m, @pdefun, @pdeic, @pdebc, x, t, options);

%%
[X, T] = meshgrid(x, t);
figure;
contour(X, T, sol(:, :, 1), "Fill", "on", "LineColor", "k", "LineWidth", 1);
xlabel("x, м");
ylabel("t, c");
c = colorbar;
c.Label.String = "y, м";


%% анимация
figure;
p = plot(x, sol(1, :, 1), "LineWidth", 2);
s = subtitle("t = " + t(1));
xlabel("x, м");
ylabel("y, м");
xlim([0 1])
ylim([-1 1])

while true
    tic
    for i = 1:length(t)
        p.YData = sol(i, :, 1);
        s.String = "t = " + t(i);
        drawnow
        pause(0.01)
    end
    toc;
end


%%
% function f = external_force(x, t) 
%     f = 0;
% end
% % начальное значение
% function val = initial_value(x) 
%     val = sin(pi * x);
% end
% % начальная скорость
% function speed = initial_speed(x) 
%     speed = 0;
% end
% 
% 
% % граничные условия
% function pos = left_position(t) 
%     pos = 0;
% end
% function pos = right_position(t) 
%     pos = 0;
% end

function [c, f, s] = pdefun(x, t, u, dudx) % Equation to solve
    c = [1; 1];
    f = [0; dudx(1)];
    s = [u(2); 0];
%     s = [u(2); external_force(x, t)];
end
% ---------------------------------------------
function u0 = pdeic(x) % Initial Conditions
    u0 = [sin(pi * x); 0];
%     u0 = [initial_value(x); initial_speed(x)];
end
% ---------------------------------------------
function [pl, ql, pr, qr] = pdebc(xl, ul, xr, ur, t) % Boundary Conditions
    pl = [0 - ul(1); 0];
%     pl = [left_position(xl) - ul(1); 0];
    ql = [0; 1];
    
    pr = [0 - ur(1); 0];
%     pr = [right_position(xr) - ur(1); 0];
    qr = [0; 1];
end
% ---------------------------------------------