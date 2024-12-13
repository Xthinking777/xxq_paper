%%
% 初始（没用了）
% 插值回归拟合的方法
%%
% Step 1: 加载数据
y = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 2, 3, 4, 5, 6, 7]';
z = [1.5948, 1.5991, 1.6071, 1.6058, 1.6167, 1.6213, 1.6261, 1.6309, 1.6422, 1.6467, 1.6511, 1.7008, 1.7333, 1.7658, 1.8010, 1.8342, 1.8431]';
x = [1.0259, 0.8754, 0.8005, 0.7448, 0.6992, 0.6645, 0.6351, 0.6096, 0.5866, 0.5671, 0.5496, 0.4350, 0.3707, 0.3263, 0.2941, 0.2702, 0.2470]';

% Step 2: 创建一个参数 t
t = (1:length(x))';

% 使用三次样条拟合 x(t), y(t), z(t)
fit_x = fit(t, x, 'smoothingspline');
fit_y = fit(t, y, 'smoothingspline');
fit_z = fit(t, z, 'smoothingspline');

% Step 3: 绘制结果
figure;
plot3(x, y, z, 'b<'); % 绘制原始数据点
hold on;

% 生成插值点
t_fit = linspace(min(t), max(t), 100);
x_fit = feval(fit_x, t_fit);
y_fit = feval(fit_y, t_fit);
z_fit = feval(fit_z, t_fit);

plot3(x_fit, y_fit, z_fit, 'r-'); % 绘制拟合曲线
xlabel('var(u)');
ylabel('λ');
zlabel('var(y)');
title('LQG-3D Curve Fitting');
grid on;
hold off;

% 输出拟合函数的表达式
disp('x(t) = ');
disp(fit_x);
disp('y(t) = ');
disp(fit_y);
disp('z(t) = ');
disp(fit_z);


