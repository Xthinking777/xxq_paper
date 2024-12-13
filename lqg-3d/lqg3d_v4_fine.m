%%
% 区间细化版本 λ：1-2
%%
%%
% Step 1: 加载数据
% x = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2, 3, 4, 5, 6, 7]';%λ
% y = [1.0259, 0.8754, 0.8005, 0.7448, 0.6992, 0.6645, 0.6351, 0.6096, 0.5866,0.5671, 0.5496,...
%     0.5337,0.5191,0.5058,0.4934,0.4820,0.4715,0.4615,0.4522,0.4434,0.4350, 0.3707, 0.3263, 0.2941, 0.2702, 0.2470]';%var(u)
% z = [1.5948, 1.5991, 1.6071, 1.6058, 1.6167, 1.6213, 1.6261, 1.6309, 1.6422,1.6467, 1.6511,...
%     1.6554,1.6596,1.6628,1.6739,1.6776,1.6813,1.6848,1.6883,1.6916,1.7008, 1.7333, 1.7658, 1.8010, 1.8342, 1.8431]';%var(y)
x = [1, 1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2]';%λ
y = [0.5496,0.5337,0.5191,0.5058,0.4934,0.4820,0.4715,0.4615,0.4522,0.4434,0.4350]';%var(u)
z = [1.6511,1.6554,1.6596,1.6628,1.6739,1.6776,1.6813,1.6848,1.6883,1.6916,1.7008]';%var(y)
% 数据处理
% x = log(1 + x); % 将z中数据取对数
% y = y / 1.0259; % 将y中数据除以1.0259
% z = z / 1.8431; % 将x中数据除以1.8431

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

% Step 3: 绘制结果
%%
% 创建图形窗口
figure;
% 绘制原始数据点
plot3(y, x, z, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
hold on;
% 绘制拟合曲线
plot3(y_fit, x_fit, z_fit, 'r-', 'LineWidth', 2);
% 设置轴标签
xlabel('var(u)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('λ', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('var(y)', 'FontSize', 12, 'FontWeight', 'bold');
% 设置标题
title('LQG 3D Curve Fitting', 'FontSize', 14, 'FontWeight', 'bold');
% 添加网格
grid on;
ax = gca;
ax.GridLineStyle = '--'; % 设置网格线为虚线
ax.GridColor = [0.5, 0.5, 0.5]; % 设置网格线颜色为灰色
ax.GridAlpha = 0.8; % 设置网格线的透明度
% 设置轴范围和比例
axis tight;
axis vis3d;
% 添加图例
legend('原始数据点', '拟合曲线', 'Location', 'best');
% 设置视角
view(3);
% 开启旋转3D图像
rotate3d on;
% 设置背景颜色
set(gcf, 'Color', 'w');
% 保持并关闭
hold off;
%%

% 输出拟合函数的表达式
fprintf('LQG三维曲线的数学表达式:\n');
fprintf('x(t){λ} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_x);
fprintf('y(t){u} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_y);
fprintf('z(t){y} = %.4f*t^3 + %.4f*t^2 + %.4f*t + %.4f\n', p_z);




