% Step 1: 加载数据
x = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 2, 3, 4, 5, 6, 7]'; % λ
y = [1.0259, 0.8754, 0.8005, 0.7448, 0.6992, 0.6645, 0.6351, 0.6096, 0.5866, 0.5671, 0.5496, 0.4350, 0.3707, 0.3263, 0.2941, 0.2702, 0.2470]'; % var(u)
z = [1.5948, 1.5991, 1.6071, 1.6058, 1.6167, 1.6213, 1.6261, 1.6309, 1.6422, 1.6467, 1.6511, 1.7008, 1.7333, 1.7658, 1.8010, 1.8342, 1.8431]'; % var(y)

% Step 2: 创建拟合模型
% 使用多项式曲面拟合
[surf_fit, gof] = fit([y, x], z, 'poly23'); % 二次多项式曲面拟合

% Step 3: 生成插值数据
[y_grid, x_grid] = meshgrid(linspace(min(y), max(y), 100), linspace(min(x), max(x), 100));
z_grid = feval(surf_fit, y_grid, x_grid);

% Step 4: 绘制三维拟合曲面
figure;
mesh(y_grid, x_grid, z_grid); % 绘制拟合曲面
hold on;
plot3(y, x, z, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b'); % 绘制原始数据点
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
title('LQG 3D Surface Fitting', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
view(3);
rotate3d on;
hold off;

% Step 5: 输出拟合函数的表达式
disp('LQG三维曲面的最小二乘拟合函数表达式:');
disp(surf_fit);

% Step 6: 绘制三维曲线在二维三个方向的投影
figure;
subplot(2, 2, 1); % 创建子图1：y-x 平面投影
plot(y, x, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b'); 
hold on;
z_proj = feval(surf_fit, y, x); % 计算 z 的投影
plot(y, x, 'r-', 'LineWidth', 2); % 绘制拟合曲线
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
title('y-x 平面投影');
grid on;
hold off;

subplot(2, 2, 2); % 创建子图2：z-x 平面投影
plot(z, x, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
% 绘制 z-x 投影
plot(z_grid(:), x_grid(:), 'r-', 'LineWidth', 2);
xlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
title('z-x 平面投影');
grid on;
hold off;

subplot(2, 2, 3); % 创建子图3：z-y 平面投影
plot(z, y, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
% 绘制 z-y 投影
plot(z_grid(:), y_grid(:), 'r-', 'LineWidth', 2);
xlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
title('z-y 平面投影');
grid on;
hold off;
