%% 模型估计
clear
Data_Am=80000;%Amount of output data for close-loop system
Data_G=1000;%Closed loop impulse response truncated data

%自定义白噪声源
% load('et1_20000.mat');
% sim_time=zeros(1,20000);
% for time_i=1:1:20000
% sim_time(time_i)=time_i*0.1;
% end
% noise1_20000=[sim_time',et1(1,:)'];
%sim('gauss');

%% 定义模型
KZQ_1 = filt([2.841 -4.406 1.749], [1 -1]); 
T_1 = filt([zeros(1,5) 0.2], [1 -0.8]);
N_1 = filt([1 0], [1 -0.1 -0.2]);
d_1=5;
%sat_alpha_set_1=[11.2 9.6 15];%自定义白噪声 15--0%  11.2--10%  9.6--20%   3.31--60%   0--100%
%sat_alpha_set_1=[10 4.7 3.31 2.6 2.2 1.8 1.1 0.91 0.5 0.1 0];% 系统白噪声 10--0%  4.7--10%  3.31--20% ...0--100% 
sat_alpha_set_1=[10 4.7 3.31];% 系统白噪声

KZQ_2 = filt([0.8305 -1.396 0.607], [1 -1]); 
T_2 = filt([zeros(1,6) 1], [1 -0.8]);
N_2 = filt([1 0.6], [1 0.1 -0.67 -0.025 0.105]);
d_2=6;
sat_alpha_set_2=[5 2.05 1.75 1.3 1.08 0.9 0.55 0.41 0.287 0.15 0];%2.05--10%  1.75--20%  ...0--100%
 
%% 选择模型
choose_model=2;
if choose_model==1
    KZQ = KZQ_1;
    T = T_1;
    N = N_1;
    d=d_1;
    sat_alpha_set=sat_alpha_set_1;%选择饱和度
elseif choose_model==2
    KZQ = KZQ_2;
    T = T_2;
    N = N_2;
    d=d_2;
    sat_alpha_set=sat_alpha_set_2;%选择饱和度
else 
   disp('choose model again');
end

%% 算例* 不同饱和度 仿真(_________________________________________________
Sat_percent=zeros(1,length(sat_alpha_set));
g_est=zeros(length(sat_alpha_set),1001);

var_u    =zeros(1,length(sat_alpha_set));
var_sat_u=zeros(1,length(sat_alpha_set));
var_y    =zeros(1,length(sat_alpha_set));
for sat_alpha_i=1:1:length(sat_alpha_set)
sat_alpha=sat_alpha_set(sat_alpha_i);%选择阈值

if choose_model==1
    sim('Sat_Nonliner');
elseif choose_model==2
    sim('Sat_Nonliner_2');
else
    disp('NO sim!');
end

sat_num=0;%计算饱和度
for i=1:1:50
    if(abs(u_k(i))>sat_alpha_set(sat_alpha_i)) 
        sat_num=sat_num+1;
    end
end
Sat_percent(sat_alpha_i)=sat_num/50*100;
%%FCOR
g_est(sat_alpha_i,:)=fc(y_k(1:Data_Am));%Fcor
% u_k_i(sat_alpha_1)     = u_k(1:51);
% sat_u_k_i(sat_alpha_1) = sat_u_k(1:51);
% y_k_i(sat_alpha_1)     = y_k(1:51);

var_u(sat_alpha_i)    =var(u_k);%输入方差
var_sat_u(sat_alpha_i)=var(sat_u_k);%饱和输入方差
var_y(sat_alpha_i)=var(y_k);%输出方差
end
%% _________________________________________________

%% 计算方差数据并绘图  实际  估计  理论
%饱和度i 估计方差
var_y_est=zeros(1,length(sat_alpha_set));
for sat_alpha_i=1:1:length(sat_alpha_set)  
    for i=1:1:Data_G
    var_y_est(sat_alpha_i)=var_y_est(sat_alpha_i) + g_est(sat_alpha_i,i)^2;
    end
end 

%理论方差
G_theo=N/(1+KZQ*T);
g_theo=impulse(G_theo,Data_G)';
var_y_theo=0; 
for i=1:1:Data_G
var_y_theo=var_y_theo + g_theo(i)^2;
end

Var_all=zeros(3,length(sat_alpha_set));
for sat_alpha_i=1:1:length(sat_alpha_set)
Var_all(1,sat_alpha_i)=var_y(sat_alpha_i);
Var_all(2,sat_alpha_i)=var_y_est(sat_alpha_i);
Var_all(3,sat_alpha_i)=var_y_theo;
end



%sat_alpha_i=(1:length(sat_alpha_set))';
% 绘制 Var_all 矩阵中的数据
figure; % 创建一个新的图形窗口
plot(Sat_percent, Var_all(1, :), 'b-', 'DisplayName', 'Actual Variance');
hold on; % 保持当前图形，以便在同一图上绘制更多数据
plot(Sat_percent, Var_all(2, :), 'r--', 'DisplayName', 'Estimated Variance');
plot(Sat_percent, Var_all(3, :), 'g-', 'DisplayName', 'Theoretical Variance');
hold off; % 释放图形

% 添加图例和标题
legend show;
title('Variance Comparison');
xlabel('Sat percent(%)');
ylabel('Variance');

%% 估计饱和度为零时的脉冲响应
% g_1=g_est(2,1:200);
% g_2=g_est(3,1:200);
% % g_00=impulse(G_theo, 200-1)';%理论值
% %(10-0)/(1.5282-x)=(20-10)/(1.4154-1.5282)
% var_y_est0=1.6410;
% 
% %遍历r （0-1）  步长0.01
% r_err=zeros(1,100);%方差最小误差
% for r_i=1:1:100
%     g_0=zeros(1,200);
%     for i = 1:200%通过比例关系求解g0
%         g_0(i) = solve_g0(r_i/100, g_1(i), g_2(i));
%     end
%     var_y_est00=0;
%     for i = 1:200%利用g0求方差
%         var_y_est00=var_y_est00+ g_0(i)^2;
%     end
%     r_err(r_i)=(var_y_est00-var_y_est0)^2;%统计方差误差
% end
% % 找到最小的 r_set(r_i)
% [min_value, min_index] = min(r_err);
% 
% % 计算对应的 r 值
% r_opt = (min_index) / 100;
% 
% % 显示最优的 r 值
% disp(r_opt);
% for i = 1:200
%      g_0(i) = solve_g0(r_opt, g_1(i), g_2(i));
% end
% var_y_est00=0;
% for i = 1:200%最优r对于g0求出的方差
%     var_y_est00=var_y_est00+ g_0(i)^2;
% end
% 
% %r=(g2-g1)(g1-g0)/(g2-g0)^2
% function g0 = solve_g0(r, g1, g2)
%     % 验证输入值是否有效
%     if g2 == g1
%         error('g2 and g1 must be distinct.');
%     end  
%     % 根据给定的 r 值解出 g0
%     a = (g2 - g1)^2 / r - 1;
%     b = 2 * g1 * (1 - (g2 - g1)^2 / r);
%     c = g1^2 - 2 * g1 * g2 * (1 - (g2 - g1)^2 / r) + g2^2;
% 
%     % 计算判别式
%     discriminant = b^2 - 4 * a * c;
% 
%     % 检查判别式是否非负
%     if discriminant < 0
%         error('No real solution for g0 exists.');
%     end
% 
%     % 使用二次公式求解 g0
%     g0 = (-b + sqrt(discriminant)) / (2 * a);
% end



%% 画图
% 创建绘图数据
G_theo_i    = impulse(G_theo, 50);
N_theo_i    = impulse(N, 50);
G_est_0_i   = g_est(1,1:51)';
G_est_1_i   = g_est(2,1:51)';
G_est_2_i   = g_est(3,1:51)';

%G_est_00_i  = g_0(1:51)';% 优化估计出来的零饱和度响应

% %% 计算r值
% r_theo=zeros(1,30);% d~2d
% for i=1:1:30
%     r_theo(i)=(g_est(3,i)-g_est(2,i))*(g_est(2,i)-g_est(1,i))/(g_est(3,i)-g_est(1,i))^2;
% end
% 
% % 创建时间向量
% t = (1:length(r_theo))'; % 转置以确保 t 是列向量
% % 绘制脉冲响应对比图2
% figure; % 创建一个新的图形窗口
% plot(t, r_theo, 'r-o', 'LineWidth', 2); % 绘制理论脉冲响应，蓝色线
% hold on; % 保持当前图形，以便在同一图上绘制
% % 添加图例和标签
% legend('理论比例r');
% xlabel('时间 (Z^-1)');
% ylabel('响应幅度');
% title('比例值变化图');
% grid on; % 添加网格


% 创建时间向量
t = (0:length(G_theo_i)-1)'; % 转置以确保 t 是列向量
% 绘制脉冲响应对比图2
figure; % 创建一个新的图形窗口
plot(t, G_theo_i, 'b', 'LineWidth', 2); % 绘制理论脉冲响应，蓝色线
hold on; % 保持当前图形，以便在同一图上绘制
 %plot(t, N_theo_i, 'm', 'LineWidth', 2); % 绘制理论脉冲响应，蓝色线
plot(t, G_est_1_i, 'r--', 'LineWidth', 2); % 绘制估计脉冲响应，红色虚线
plot(t, G_est_2_i, 'g--', 'LineWidth', 2); % 绘制估计脉冲响应，绿色虚线
%plot(t, G_est_00_i, 'c--', 'LineWidth', 2); % 绘制估计脉冲响应，黑色虚线
plot(t, G_est_0_i, 'k--', 'LineWidth', 2); % 绘制估计脉冲响应，黑色虚线
hold off; % 不再保持图形
% 添加图例和标签
legend('理论脉冲响应', '估计脉冲响应——饱和10%','估计脉冲响应——饱和20%');
xlabel('时间 (Z^-1)');
ylabel('响应幅度');
title('脉冲响应对比图');
grid on; % 添加网格


