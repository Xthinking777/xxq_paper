function []= plot_LQG(var_u,var_y,Sat_percent_num)

%1.加载数据
% for Sat_percent_i=1:1:length(Sat_percent)
% var_y(Sat_percent_i,1:7)=LQG_3D_ALL(:,2);
% var_u(Sat_percent_i,1:7)=LQG_3D_ALL(:,3);
% end
%2.多项式拟合
for Sat_percent_i=1:1:Sat_percent_num
p(Sat_percent_i,:)=polyfit(var_u(Sat_percent_i,:), var_y(Sat_percent_i,:), 3); % 拟合三次多项式
var_u_fit(Sat_percent_i,:) = linspace(min(var_u(Sat_percent_i,:)), max(var_u(Sat_percent_i,:)), 100); % 生成平滑曲线的 x 点
var_y_fit(Sat_percent_i,1:100) = polyval(p(Sat_percent_i,:), var_u_fit(Sat_percent_i,:)); % 计算对应的 y 值
end
%3.绘图
colors = ['b', 'r', 'g', 'c', 'm', 'y'];  % 定义颜色数组，可以根据需要添加
figure;
%数据点
for Sat_percent_i=1:1:Sat_percent_num
    color=colors(Sat_percent_i) ;  
    scatter(var_u(Sat_percent_i,:), var_y(Sat_percent_i,:), color,'filled'); % 2.估计数据点
    hold on;
end
%拟合曲线
for Sat_percent_i=1:1:Sat_percent_num
   line_color=colors(Sat_percent_i) ;  
   plot(var_u_fit(Sat_percent_i,:), var_y_fit(Sat_percent_i,:), [line_color '--'], 'LineWidth', 2); % 拟合曲线
end
%额外补充的线
plot(var_u_fit(3,:), var_y_fit(3,:), 'g-', 'LineWidth', 2); % 拟合曲线
hold off; % 取消保持状态
legend('数据点1','数据点2','数据点3：仿真','曲线1：0%','曲线2：42.2%','曲线3：仿真');
title('LQG拟合曲线');
xlabel('var(u)');
ylabel('var(y)');
grid on;
end