%1.创建数据
% 定义数据点
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\F_LQG_3D.mat');
var_y_1 =LQG_3D(:,2);
var_u_1 =LQG_3D(:,3);
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\G_LQG_3D.mat');
var_y_2 =LQG_3D(:,2);
var_u_2 =LQG_3D(:,3);

% 多项式拟合
p_1 = polyfit(var_u_1, var_y_1, 3); % 拟合三次多项式
var_u_fit_1 = linspace(min(var_u_1), max(var_u_1), 100); % 生成平滑曲线的 x 点
var_y_fit_1 = polyval(p_1, var_u_fit_1); % 计算对应的 y 值
p_2 = polyfit(var_u_2, var_y_2, 3); % 拟合三次多项式
var_u_fit_2 = linspace(min(var_u_2), max(var_u_2), 100); % 生成平滑曲线的 x 点
var_y_fit_2 = polyval(p_2, var_u_fit_2); % 计算对应的 y 值
% 绘制结果
figure;
scatter(var_u_1, var_y_1, 'b', 'filled'); % 数据点
hold on;
scatter(var_u_2, var_y_2, 'r', 'filled'); % 数据点
plot(var_u_fit_1, var_y_fit_1, 'b--', 'LineWidth', 2); % 拟合曲线
plot(var_u_fit_2, var_y_fit_2, 'r--', 'LineWidth', 2); % 拟合曲线
hold off; % 取消保持状态
legend('理论原始数据','估计原始数据','理论曲线','估计曲线');
title('LQG拟合曲线');
xlabel('var(u)');
ylabel('var(y)');
grid on;

%2.拟合曲线方程 
% 输出拟合结果
disp('拟合系数理论：');
disp(p_1);
% 输出拟合结果
disp('拟合系数估计：');
disp(p_2);