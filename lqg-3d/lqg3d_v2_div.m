% Step 1: 加载数据
x = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6,       0.7, 0.8, 0.9, 1,      2, 3, 4, 5, 6, 7]'; % λ
y = [1.0259, 0.8754, 0.8005, 0.7448, 0.6992, 0.6645, 0.6351, 0.6096, 0.5866, 0.5671, 0.5496, 0.4350, 0.3707, 0.3263, 0.2941, 0.2702, 0.2470]'; % var(u)
z = [1.5948, 1.5991, 1.6071, 1.6058, 1.6167, 1.6213, 1.6261, 1.6309, 1.6422, 1.6467, 1.6511, 1.7008, 1.7333, 1.7658, 1.8010, 1.8342, 1.8431]'; % var(y)

% Step 2: 将数据分成两段
x1 = x(1:11); y1 = y(1:11); z1 = z(1:11);
x2 = x(7:end); y2 = y(7:end); z2 = z(7:end);

t1 = (1:length(x1))'; % 第一段的 t
t2 = (1:length(x2))'; % 第二段的 t

% Step 3: 使用多项式拟合两段数据
dim = 3; % 多项式阶数
p_x1 = polyfit(t1, x1, dim);
p_y1 = polyfit(t1, y1, dim);
p_z1 = polyfit(t1, z1, dim);

p_x2 = polyfit(t2, x2, dim);
p_y2 = polyfit(t2, y2, dim);
p_z2 = polyfit(t2, z2, dim);

% 生成插值点
t_fit1 = linspace(min(t1), max(t1), 100);
t_fit2 = linspace(min(t2), max(t2), 100);

x_fit1 = polyval(p_x1, t_fit1);
y_fit1 = polyval(p_y1, t_fit1);
z_fit1 = polyval(p_z1, t_fit1);

x_fit2 = polyval(p_x2, t_fit2);
y_fit2 = polyval(p_y2, t_fit2);
z_fit2 = polyval(p_z2, t_fit2);

% Step 4: 绘制3D曲线和投影
% close all;
% clf;
% figure;

% 3D曲线
subplot(2, 2, 1);
plot3(y1, x1, z1, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
plot3(y2, x2, z2, 'go', 'MarkerSize', 6, 'MarkerFaceColor', 'g');
plot3(y_fit1, x_fit1, z_fit1, 'r-', 'LineWidth', 2);
plot3(y_fit2, x_fit2, z_fit2, 'm-', 'LineWidth', 2);
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
title('LQG 3D Curve Fitting', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
view(3);
rotate3d on;
hold off;

% XY投影
subplot(2, 2, 2);
plot(y1, x1, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
plot(y2, x2, 'go', 'MarkerSize', 6, 'MarkerFaceColor', 'g');
plot(y_fit1, x_fit1, 'r-', 'LineWidth', 2);
plot(y_fit2, x_fit2, 'm-', 'LineWidth', 2);
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
title('Projection on XY Plane', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
hold off;

% XZ投影
subplot(2, 2, 3);
plot(z1, x1, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
plot(z2, x2, 'go', 'MarkerSize', 6, 'MarkerFaceColor', 'g');
plot(z_fit1, x_fit1, 'r-', 'LineWidth', 2);
plot(z_fit2, x_fit2, 'm-', 'LineWidth', 2);
xlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
title('Projection on XZ Plane', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
hold off;

% YZ投影
subplot(2, 2, 4);
plot(y1, z1, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
plot(y2, z2, 'go', 'MarkerSize', 6, 'MarkerFaceColor', 'g');
plot(y_fit1, z_fit1, 'r-', 'LineWidth', 2);
plot(y_fit2, z_fit2, 'm-', 'LineWidth', 2);
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
title('Projection on ZY Plane', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
hold off;

% Step 5: 输出两段拟合的数学表达式
fprintf('LQG曲线第一段的数学表达式:\n');
fprintf('x1(t){λ} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_x1);
fprintf('y1(t){u} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_y1);
fprintf('z1(t){y} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_z1);

fprintf('LQG曲线第二段的数学表达式:\n');
fprintf('x2(t){λ} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_x2);
fprintf('y2(t){u} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_y2);
fprintf('z2(t){y} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_z2);
