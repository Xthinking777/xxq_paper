%%模型估计
clear
Data_Am=20000;%Amount of output data for close-loop system
Data_G=200;%Closed loop impulse response truncated data

%sim('gauss');

%% 定义模型
KZQ_1 = filt([2.841 -4.406 1.749], [1 -1]); 
T_1 = filt([zeros(1,5) 0.2], [1 -0.8]);
N_1 = filt([1 0], [1 -0.1 -0.2]);

KZQ_2 = filt([0.8305 -1.396 0.607], [1 -1]); 
T_2 = filt([zeros(1,6) 1], [1 -0.8]);
N_2 = filt([1 0.6], [1 0.1 -0.67 -0.025 0.105]);

%% 选择模型
KZQ = KZQ_1;
T = T_1;
N = N_1;

sat_alpha_set=[4.8 3.31 100];
%%饱和度1
sat_alpha = sat_alpha_set(1);% 4.8--10%  3.31--20%
sim('Sat_Nonliner');
sat_num=0;
for i=1:1:50
    if(abs(u_k(i))>sat_alpha_set(1)) 
        sat_num=sat_num+1;
    end
end
Sat_percent=sat_num/50*100;
%%FCOR
y_out=y_k(1:Data_Am);
g_est_1=fc(y_out);%Fcor
%%饱和度2
sat_alpha = sat_alpha_set(2);% 4.8--10%  3.31--20%
sim('Sat_Nonliner');
sat_num2=0;
for i=1:1:50
    if(abs(u_k(i))>sat_alpha_set(2)) 
        sat_num2=sat_num2+1;
    end
end
Sat_percent2=sat_num2/50*100;
%%FCOR
y_out2=y_k(1:Data_Am);
g_est_2=fc(y_out2);%Fcor

g_est=g_est_1;%选择饱和度1
% g_est=g_est_2;%选择饱和度2

G_est=filt(g_est(1:300),1);
G_theo=N/(1+T*KZQ);

% 计算理论脉冲响应和估计脉冲响应
G_theo_i  = impulse(G_theo, 50);
G_est_i   = impulse(G_est, 50);

u_k_i     = u_k(1:51);
sat_u_k_i = sat_u_k(1:51);
y_k_i     = y_k(1:51);

G_est_ii   = impulse(G_est, Data_G);
G_theo_ii  = impulse(G_theo, Data_G);

%%求方差
%仿真测量方差
var_u=var(u_k);
var_sat_u=var(sat_u_k);
var_y_mea=var(y_k);
%模型估计方差
var_y_est=0;
var_y_theo=0;
for i=1:1:Data_G
var_y_est=var_y_est + G_est_ii(i)^2;
var_y_theo=var_y_theo + G_theo_ii(i)^2;
end




%%画图
% 创建时间向量，从 0 到 50（因为 impulse 返回 100 个点）
t = (0:length(G_theo_i)-1)'; % 转置以确保 t 是列向量
% 绘制脉冲响应对比图1
figure; % 创建一个新的图形窗口
plot(t, u_k_i, 'r--', 'LineWidth', 2); % 绘制估计脉冲响应，红色虚线
hold on; % 保持当前图形，以便在同一图上绘制
plot(t, sat_u_k_i, 'b--', 'LineWidth', 2); % 绘制估计脉冲响应，红色虚线
hold on; % 保持当前图形，以便在同一图上绘制
plot(t, y_k_i, 'g--', 'LineWidth', 2); % 绘制估计脉冲响应，红色虚线
hold off; % 不再保持图形
% 添加图例和标签
legend('u_k', 'sat_u_k','y_k');
xlabel('时间 (样本)');
ylabel('响应幅度');
title('脉冲响应对比图');
grid on; % 添加网格


% 绘制脉冲响应对比图2
figure; % 创建一个新的图形窗口
plot(t, G_theo_i, 'b', 'LineWidth', 2); % 绘制理论脉冲响应，蓝色线
hold on; % 保持当前图形，以便在同一图上绘制
plot(t, G_est_i, 'r--', 'LineWidth', 2); % 绘制估计脉冲响应，红色虚线
hold off; % 不再保持图形
% 添加图例和标签
legend('理论脉冲响应', '估计脉冲响应');
xlabel('时间 (样本)');
ylabel('响应幅度');
title('脉冲响应对比图');
grid on; % 添加网格


