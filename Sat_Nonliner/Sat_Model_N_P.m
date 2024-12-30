%% 模型估计
clear
Data_Am=80000;%Amount of output data for close-loop system
Data_G=1000;%Closed loop impulse response truncated data

%% 定义模型
KZQ_1 = filt([0.725 -1.208 0.519], [1 -1]); 
T_1 = filt([zeros(1,4) 1], [1 -0.8]);
N_1 = filt([1 -0.2], [1 -0.4 -0.17 0.06]);
d_1=4; 
sat_alpha_set_1=[5 1.35 1];%5--0% 1.35--10%  1--20% 

KZQ_2 = filt([0.8305 -1.396 0.607], [1 -1]); 
T_2 = filt([zeros(1,6) 1], [1 -0.8]);
N_2 = filt([1 0.6], [1 0.1 -0.67 -0.025 0.105]);
d_2=6;
sat_alpha_set_2=[5 0.05 0.1];%2.05--10%  1.75--20%  ...0--100%
 
%% 选择模型
choose_model=1;
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
G=N/(1+T*KZQ);
%% 算例* 不同饱和度 仿真(_________________________________________________
Sat_percent=zeros(1,length(sat_alpha_set));
g_est=zeros(length(sat_alpha_set),1001);
var_u    =zeros(1,length(sat_alpha_set));
var_sat_u=zeros(1,length(sat_alpha_set));
var_y    =zeros(1,length(sat_alpha_set));
for sat_alpha_i=1:1:length(sat_alpha_set)
sat_alpha=sat_alpha_set(sat_alpha_i);%选择阈值
if choose_model==1
    sim('Sat_Nonliner_N_P');
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
var_u(sat_alpha_i)    =var(u_k);%输入方差
var_sat_u(sat_alpha_i)=var(sat_u_k);%饱和输入方差
var_y(sat_alpha_i)=var(y_k);%输出方差
end
%% _________________________________________________

%脉冲响应求传递函数
G_est_1=Tansfor(g_est(2,1:200)',0);
G_est_2=Tansfor(g_est(3,1:200)',0);
g1=impulse(G_est_1,50);
g2=impulse(G_est_2,50);
g0=impulse(G,50);
figure;
plot(0:49,g0(1:50),'r-', 'LineWidth', 2);
hold on;
% plot(g1,'g-', 'LineWidth', 2);
% plot(g2,'b-', 'LineWidth', 2);
plot(0:49,g_est(2,1:50), 'g-.<', 'LineWidth', 2); 
plot(0:49,g_est(3,1:50), 'b-.<', 'LineWidth', 2);
hold off;
legend('理论（线性）','饱和度10%', '饱和度20%');
title('FCOR估计输出脉冲响应');
xlabel('Time step');
ylabel('Amplitude');
grid on;
%% 联立求解

% 计算脉冲响应
% 定义滞后算子多项式
impKZQ = impulse(KZQ, 49)';
impG_est_1=g_est(2,1:50);
impG_est_2=g_est(3,1:50);

G1 = LagOp(impG_est_1);  % 假设 G_est_1 可以简化为 1 (仅为示例)
G2 = LagOp(impG_est_2);  % 假设 G_est_2 可以简化为 1 (仅为示例)
KZQ_lag = LagOp(impKZQ);  % 

% 计算k1和k2
k1 = (100 - Sat_percent(2)) * 0.01;
k2 = (100 - Sat_percent(3)) * 0.01;

% 使用LagOp构建T_est的滞后算子多项式
T_est_lag = (G1 - G2) / (k2 * KZQ_lag * G2 - k1 * KZQ_lag * G1);
% 使用LagOp构建N_est的滞后算子多项式
N_est_lag = G1 * (1 + k1 * T_est_lag * KZQ_lag);

% 提取T_est_lag和N_est_lag的系数
T_est_coeffs = toCellArray(T_est_lag);
T_est_coeffs = cell2mat(T_est_coeffs');
N_est_coeffs = toCellArray(N_est_lag);
N_est_coeffs = cell2mat(N_est_coeffs');

% 绘制T_est_lag的脉冲响应
figure;
impz(T_est_coeffs, 1, 200); % 绘制200个点的脉冲响应
title('T_est_lag 脉冲响应');
xlabel('时间步');
ylabel('幅度');

% 绘制N_est_lag的脉冲响应
figure;
impz(N_est_coeffs, 1, 200); % 绘制200个点的脉冲响应
title('N_est_lag 脉冲响应');
xlabel('时间步');
ylabel('幅度');


% 计算四个系统的脉冲响应
T_est_i = T_est_coeffs(1:50)';
N_est_i = N_est_coeffs(1:50)';
T_i = impulse(T, 49);
N_i = impulse(N, 49);

% 绘制脉冲响应对比图
figure; % 创建一个新的图形窗口

plot(0:49,T_i, 'r-', 'LineWidth', 2); % 绘制T系统的脉冲响应，红色点划线，线宽为2
hold on; % 保持当前图形，以便在同一图上绘制另一条线
plot(0:49,N_i, 'g-', 'LineWidth', 2); % 绘制N系统的脉冲响应，黑色点线，线宽为2
plot(0:49,T_est_i, 'r--', 'LineWidth', 2); % 绘制N_est系统的脉冲响应，绿色虚线，线宽为2
plot(0:49,N_est_i, 'g--', 'LineWidth', 2); % 绘制T_est系统的脉冲响应，蓝色实线，线宽为2
hold off; % 释放图形，不再绘制新线

% 添加图例
legend('T  System', 'N  System', 'T est System', 'N est System');
% 添加标题和坐标轴标签
title('Impulse Response Comparison');
xlabel('Time step');
ylabel('Amplitude');
% 显示网格
grid on;









