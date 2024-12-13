% Step 1: 加载数据
x = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 2, 3, 4, 5, 6, 7]'; %λ
y = [1.0259, 0.8754, 0.8005, 0.7448, 0.6992, 0.6645, 0.6351, 0.6096, 0.5866, 0.5671, 0.5496, 0.4350, 0.3707, 0.3263, 0.2941, 0.2702, 0.2470]'; %var(u)
z = [1.5948, 1.5991, 1.6071, 1.6058, 1.6167, 1.6213, 1.6261, 1.6309, 1.6422, 1.6467, 1.6511, 1.7008, 1.7333, 1.7658, 1.8010, 1.8342, 1.8431]'; %var(y)
% 数据处理
x = log(1 + x); % 将z中数据取对数
y = y / 1.0259; % 将y中数据除以1.0259
z = z / 1.8431; % 将x中数据除以1.8431
% Step 2: 创建一个参数 t
t = (1:length(x))';

% 使用多项式拟合 x(t), y(t), z(t)
dim=3;
p_x = polyfit(t, x, dim);
p_y = polyfit(t, y, dim);
p_z = polyfit(t, z, dim);

% 生成插值点
t_fit = linspace(min(t), max(t), 100);
x_fit = polyval(p_x, t_fit);
y_fit = polyval(p_y, t_fit);
z_fit = polyval(p_z, t_fit);

% Step 3: 清除所有之前的图形窗口并绘制3D曲线和投影
% close all; % 关闭所有图形窗口
% clf; % 清除当前图形窗口中的内容
% figure; % 创建一个新窗口

% 3D曲线
subplot(2, 2, 1); % 创建子图1
plot3(y, x, z, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
plot3(y_fit, x_fit, z_fit, 'r-', 'LineWidth', 2);
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
title('LQG 3D Curve Fitting', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
view(3);
rotate3d on;
hold off;

% XY投影
subplot(2, 2, 2); % 创建子图2
plot(y, x, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
plot(y_fit, x_fit, 'r-', 'LineWidth', 2);
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
title('Projection on XY Plane', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
hold off;

% XZ投影
subplot(2, 2, 3); % 创建子图3
plot(z, x, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
plot(z_fit, x_fit, 'r-', 'LineWidth', 2);
xlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
title('Projection on XZ Plane', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
hold off;

% YZ投影
subplot(2, 2, 4); % 创建子图4
plot(y, z, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
plot(y_fit, z_fit, 'r-', 'LineWidth', 2);
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
title('Projection on ZY Plane', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
hold off;

% 输出拟合函数的表达式
fprintf('LQG三维曲线的数学表达式:\n');
fprintf('x(t){λ} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_x);
fprintf('y(t){u} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_y);
fprintf('z(t){y} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_z);
