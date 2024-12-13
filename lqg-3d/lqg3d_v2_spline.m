% Step 1: 加载数据
x = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 2, 3, 4, 5, 6, 7]'; % λ
y = [1.0259, 0.8754, 0.8005, 0.7448, 0.6992, 0.6645, 0.6351, 0.6096, 0.5866, 0.5671, 0.5496, 0.4350, 0.3707, 0.3263, 0.2941, 0.2702, 0.2470]'; % var(u)
z = [1.5948, 1.5991, 1.6071, 1.6058, 1.6167, 1.6213, 1.6261, 1.6309, 1.6422, 1.6467, 1.6511, 1.7008, 1.7333, 1.7658, 1.8010, 1.8342, 1.8431]'; % var(y)

% Step 2: 创建一个参数 t
t = (1:length(x))';

% Step 3: 使用样条插值拟合 x(t), y(t), z(t)
t_fit = linspace(min(t), max(t), 100); % 生成插值点
spline_x = spline(t, x); % 样条插值 x(t)
spline_y = spline(t, y); % 样条插值 y(t)
spline_z = spline(t, z); % 样条插值 z(t)

% Step 4: 获取每一段的样条表达式
[breaks_x, coeffs_x, ~, ~, order_x] = unmkpp(spline_x); % 分解x的样条表达式
[breaks_y, coeffs_y, ~, ~, order_y] = unmkpp(spline_y); % 分解y的样条表达式
[breaks_z, coeffs_z, ~, ~, order_z] = unmkpp(spline_z); % 分解z的样条表达式

% Step 5: 绘制3D曲线和投影
close all; % 关闭所有图形窗口
clf; % 清除当前图形窗口内容
figure; % 创建一个新窗口

% 3D曲线拟合
subplot(2, 2, 1); % 创建子图1
plot3(y, x, z, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b'); % 原始数据
hold on;
x_spline_fit = ppval(spline_x, t_fit); % 样条插值曲线 x(t)
y_spline_fit = ppval(spline_y, t_fit); % 样条插值曲线 y(t)
z_spline_fit = ppval(spline_z, t_fit); % 样条插值曲线 z(t)
plot3(y_spline_fit, x_spline_fit, z_spline_fit, 'r-', 'LineWidth', 2); % 样条插值曲线
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
title('LQG 3D Spline Interpolation', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
view(3);
rotate3d on;
hold off;

% XY投影
subplot(2, 2, 2); % 创建子图2
plot(y, x, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b'); % 原始数据
hold on;
plot(y_spline_fit, x_spline_fit, 'r-', 'LineWidth', 2); % 样条插值投影
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
title('Projection on XY Plane', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
hold off;

% XZ投影
subplot(2, 2, 3); % 创建子图3
plot(z, x, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b'); % 原始数据
hold on;
plot(z_spline_fit, x_spline_fit, 'r-', 'LineWidth', 2); % 样条插值投影
xlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
title('Projection on XZ Plane', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
hold off;

% YZ投影
subplot(2, 2, 4); % 创建子图4
plot(z, y, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b'); % 原始数据
hold on;
plot(z_spline_fit, y_spline_fit, 'r-', 'LineWidth', 2); % 样条插值投影
xlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
title('Projection on YZ Plane', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
hold off;

% Step 6: 输出每一段样条函数的表达式
fprintf('x(t) 样条函数分段表达式：\n');
for i = 1:length(breaks_x)-1
    fprintf('区间 [%.4f, %.4f]: ', breaks_x(i), breaks_x(i+1));
    for j = 1:order_x
        fprintf('%.4f*t^%d ', coeffs_x(i,j), order_x-j);
        if j < order_x
            fprintf('+ ');
        end
    end
    fprintf('\n');
end

fprintf('\ny(t) 样条函数分段表达式：\n');
for i = 1:length(breaks_y)-1
    fprintf('区间 [%.4f, %.4f]: ', breaks_y(i), breaks_y(i+1));
    for j = 1:order_y
        fprintf('%.4f*t^%d ', coeffs_y(i,j), order_y-j);
        if j < order_y
            fprintf('+ ');
        end
    end
    fprintf('\n');
end

fprintf('\nz(t) 样条函数分段表达式：\n');
for i = 1:length(breaks_z)-1
    fprintf('区间 [%.4f, %.4f]: ', breaks_z(i), breaks_z(i+1));
    for j = 1:order_z
        fprintf('%.4f*t^%d ', coeffs_z(i,j), order_z-j);
        if j < order_z
            fprintf('+ ');
        end
    end
    fprintf('\n');
end
