%%模型估计
clear
Data_Am=20000;%Amount of output data for close-loop system
Data_G=300;%Closed loop impulse response truncated data
sim('gauss');
%%定义模型
KZQ_1=filt([2.841 -4.406 1.749],[1 -1]); 
T_1=filt([zeros(1,5) 0.2],[1 -0.8]);
N_1=filt([1 0],[1 -0.1 -0.2]);

%%选择模型
KZQ=KZQ_1;
T=T_1;
N=N_1;

%%FCOR
y_out=Fcor(KZQ,T,N,y_a);%Generate output data
g_est=fc(y_out(1:Data_Am));%Fcor
G_est=filt(g_est(1:Data_G),1);
G_theo=N/(1+T*KZQ);


%%画图
% 计算理论脉冲响应和估计脉冲响应
G_theo_i = impulse(G_theo, 50);
G_est_i = impulse(G_est, 50);

% 创建时间向量，从 0 到 99（因为 impulse 返回 100 个点）
t = (0:length(G_theo_i)-1)'; % 转置以确保 t 是列向量

% 绘制脉冲响应对比图
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


