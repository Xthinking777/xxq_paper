%1.创建数据
% 定义数据点
%理论值
% clear
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\Sat_model\Sat_percent_3.mat');
% Sat_percent_3=[53.4 69.1 77 20 30 50];
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\G_LQG_3D.mat');
var_y_00 =LQG_3D(:,2);
var_u_00 =LQG_3D(:,3);
%不同饱和度估计值
%load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\H_LQG_3D_ALL.mat');
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\H_LQG_3D_ALL111.mat');
for Sat_percent_3_i=1:1:length(Sat_percent_3)
var_y(Sat_percent_3_i,1:7)=LQG_3D_ALL(Sat_percent_3_i,:,2);
var_u(Sat_percent_3_i,1:7)=LQG_3D_ALL(Sat_percent_3_i,:,3);
end
%饱和度1时 最优PID控制器 仿真方差值
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\sim_var_sat_u_case_3.mat');
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\sim_var_u_case_3.mat');
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\sim_var_y_case_3.mat');
sim_sat_percent_case_3=6;
sim_var_y_2 =sim_var_y_case_3(sim_sat_percent_case_3,:);
sim_var_u_2 =sim_var_sat_u_case_3(sim_sat_percent_case_3,:);
% 2.多项式拟合 
p_00 = polyfit(var_u_00, var_y_00, 3); % 拟合三次多项式
var_u_fit_00 = linspace(min(var_u_00), max(var_u_00), 100); % 生成平滑曲线的 x 点
var_y_fit_00 = polyval(p_00, var_u_fit_00); % 计算对应的 y 值

for Sat_percent_3_i=1:1:length(Sat_percent_3)
p(Sat_percent_3_i,:)=polyfit(var_u(Sat_percent_3_i,:), var_y(Sat_percent_3_i,:), 3); % 拟合三次多项式
var_u_fit(Sat_percent_3_i,:) = linspace(min(var_u(Sat_percent_3_i,:)), max(var_u(Sat_percent_3_i,:)), 100); % 生成平滑曲线的 x 点
var_y_fit(Sat_percent_3_i,1:100) = polyval(p(Sat_percent_3_i,:), var_u_fit(Sat_percent_3_i,:)); % 计算对应的 y 值
end

sim_p_2 = polyfit(sim_var_u_2, sim_var_y_2, 3); % 拟合三次多项式
sim_var_u_fit_2 = linspace(min(sim_var_u_2), max(sim_var_u_2), 100); % 生成平滑曲线的 x 点
sim_var_y_fit_2 = polyval(sim_p_2, sim_var_u_fit_2); % 计算对应的 y 值

% 3.绘制结果
colors = ['b', 'r', 'g', 'c', 'm', 'y'];  % 定义颜色数组，可以根据需要添加
figure;
%数据点
scatter(var_u_00, var_y_00, 'k', 'filled'); % 1.理论数据点
hold on;
for Sat_percent_3_i=1:1:length(Sat_percent_3)
    color=colors(Sat_percent_3_i) ;  
    scatter(var_u(Sat_percent_3_i,:), var_y(Sat_percent_3_i,:), color, 'filled'); % 2.估计数据点
end
scatter(sim_var_u_2, sim_var_y_2, 'r>', 'filled'); % 3.仿真数据点
%曲线
plot(var_u_fit_00, var_y_fit_00, 'k-', 'LineWidth', 2); % 拟合曲线
for Sat_percent_3_i=1:1:length(Sat_percent_3)
   line_color=colors(Sat_percent_3_i) ;  
   plot(var_u_fit(Sat_percent_3_i,:), var_y_fit(Sat_percent_3_i,:), [line_color '--'], 'LineWidth', 2); % 拟合曲线
end
plot(sim_var_u_fit_2, sim_var_y_fit_2, 'r-', 'LineWidth', 2); % 仿真拟合曲线

hold off; % 取消保持状态
Sat_percent_3=[53.4 69.1 77 20 30 50];
sat_percent_1=num2str(Sat_percent_3(1));
sat_percent_2=num2str(Sat_percent_3(2));
sat_percent_3=num2str(Sat_percent_3(3));
sat_percent_4=num2str(Sat_percent_3(4));
sat_percent_5=num2str(Sat_percent_3(5));
sat_percent_6=num2str(Sat_percent_3(6));
legend('理论数据点00',...
       [sat_percent_1 '%数据点'],[sat_percent_2 '%数据点'],[sat_percent_3 '%数据点'],[sat_percent_4 '%数据点'],[sat_percent_5 '%数据点'],[sat_percent_6 '%数据点'],...
       [num2str(Sat_percent_3(sim_sat_percent_case_3)) '%仿真数据点'],...
       '曲线00','曲线0','曲线1','曲线2','曲线3','曲线4','曲线5','曲线2sim');

title('LQG拟合曲线');
xlabel('var(u)');
ylabel('var(y)');
grid on;
