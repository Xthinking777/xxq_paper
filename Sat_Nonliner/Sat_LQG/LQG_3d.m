%1.创建数据
% 定义数据点
clear
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\Sat_model\Sat_percent_3.mat');
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\G_LQG_3D.mat');
var_y_00 =LQG_3D(:,2);
var_u_00 =LQG_3D(:,3);
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\H_0_LQG_3D.mat');
var_y_0 =LQG_3D(:,2);
var_u_0 =LQG_3D(:,3);
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\H_1_LQG_3D.mat');
var_y_1 =LQG_3D(:,2);
var_u_1 =LQG_3D(:,3);
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\H_2_LQG_3D.mat');
var_y_2 =LQG_3D(:,2);
var_u_2 =LQG_3D(:,3);
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\H_3_LQG_3D.mat');
var_y_3 =LQG_3D(:,2);
var_u_3 =LQG_3D(:,3);
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\sim_var_sat_u_case_3.mat');
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\sim_var_y_case_3.mat');
sim_var_y_2 =sim_var_y_case_3;
sim_var_u_2 =sim_var_sat_u_case_3;
% 多项式拟合
p_00 = polyfit(var_u_00, var_y_00, 3); % 拟合三次多项式
var_u_fit_00 = linspace(min(var_u_00), max(var_u_00), 100); % 生成平滑曲线的 x 点
var_y_fit_00 = polyval(p_00, var_u_fit_00); % 计算对应的 y 值
p_0 = polyfit(var_u_0, var_y_0, 3); % 拟合三次多项式
var_u_fit_0 = linspace(min(var_u_0), max(var_u_0), 100); % 生成平滑曲线的 x 点
var_y_fit_0 = polyval(p_0, var_u_fit_0); % 计算对应的 y 值
p_1 = polyfit(var_u_1, var_y_1, 3); % 拟合三次多项式
var_u_fit_1 = linspace(min(var_u_1), max(var_u_1), 100); % 生成平滑曲线的 x 点
var_y_fit_1 = polyval(p_1, var_u_fit_1); % 计算对应的 y 值
p_2 = polyfit(var_u_2, var_y_2, 3); % 拟合三次多项式
var_u_fit_2 = linspace(min(var_u_2), max(var_u_2), 100); % 生成平滑曲线的 x 点
var_y_fit_2 = polyval(p_2, var_u_fit_2); % 计算对应的 y 值

sim_p_2 = polyfit(sim_var_u_2, sim_var_y_2, 3); % 拟合三次多项式
sim_var_u_fit_2 = linspace(min(sim_var_u_2), max(sim_var_u_2), 100); % 生成平滑曲线的 x 点
sim_var_y_fit_2 = polyval(sim_p_2, sim_var_u_fit_2); % 计算对应的 y 值

p_3 = polyfit(var_u_3, var_y_3, 3); % 拟合三次多项式
var_u_fit_3 = linspace(min(var_u_3), max(var_u_3), 100); % 生成平滑曲线的 x 点
var_y_fit_3 = polyval(p_3, var_u_fit_3); % 计算对应的 y 值
% 绘制结果
figure;
scatter(var_u_00, var_y_00, 'k', 'filled'); % 数据点
hold on;
scatter(var_u_0, var_y_0, 'b', 'filled'); % 数据点
scatter(var_u_1, var_y_1, 'c', 'filled'); % 数据点
scatter(var_u_2, var_y_2, 'r', 'filled'); % 数据点
scatter(sim_var_u_2, sim_var_y_2, 'r>', 'filled'); % 数据点
scatter(var_u_3, var_y_3, 'g', 'filled'); % 数据点
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\var_y_case_3.mat');
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\var_sat_u_case_3.mat');
scatter(var_sat_u_case_3(1), var_y_case_3(1), 'b<', 'filled'); % 数据点
scatter(var_sat_u_case_3(2), var_y_case_3(2), 'c<', 'filled'); % 数据点
scatter(var_sat_u_case_3(3), var_y_case_3(3), 'r<', 'filled'); % 数据点
scatter(var_sat_u_case_3(4), var_y_case_3(4), 'g<', 'filled'); % 数据点

plot(var_u_fit_00, var_y_fit_00, 'k-', 'LineWidth', 2); % 拟合曲线
plot(var_u_fit_0, var_y_fit_0, 'b--', 'LineWidth', 2); % 拟合曲线
plot(var_u_fit_1, var_y_fit_1, 'c--', 'LineWidth', 2); % 拟合曲线
plot(var_u_fit_2, var_y_fit_2, 'r--', 'LineWidth', 2); % 拟合曲线
plot(sim_var_u_fit_2, sim_var_y_fit_2, 'r-', 'LineWidth', 2); % 拟合曲线
plot(var_u_fit_3, var_y_fit_3, 'g--', 'LineWidth', 2); % 拟合曲线
hold off; % 取消保持状态
sat_percent_1=num2str(Sat_percent_3(1));
sat_percent_2=num2str(Sat_percent_3(2));
sat_percent_3=num2str(Sat_percent_3(3));
sat_percent_4=num2str(Sat_percent_3(4));
legend('理论数据点00',[sat_percent_1 '%数据点'],[sat_percent_2 '%数据点'],[sat_percent_3 '%sim数据点'],[sat_percent_3 '%数据点'],[sat_percent_4 '%数据点'],...
                      [sat_percent_1 '%初始控制器数据点'],[sat_percent_2 '%数据点'],[sat_percent_3 '%数据点'],[sat_percent_4 '%数据点'],...
                       '曲线00','曲线0','曲线1','曲线2','曲线2sim','曲线3');
% legend('理论原始数据点','估计原始数据点高鑫桐','理论曲线','估计曲线高鑫桐');
title('LQG拟合曲线');
xlabel('var(u)');
ylabel('var(y)');
grid on;

%2.拟合曲线方程 
% 输出拟合结果
% disp('拟合系数理论：');
% disp(p_1);
% 输出拟合结果
% disp('拟合系数估计：');
% disp(p_2);
% 输出拟合结果
% disp('拟合系数估计：');
% disp(p_3);