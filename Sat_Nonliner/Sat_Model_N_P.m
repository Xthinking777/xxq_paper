%% 模型估计
clear
Data_Am=80000;%Amount of output data for close-loop system
Data_G=1000;%Closed loop impulse response truncated data

%% 定义模型
%算例1-------------------------------------------------------------
KZQ_1 = filt([0.725 -1.208 0.519], [1 -1]); 
T_1 = filt([zeros(1,4) 1], [1 -0.8]);
N_1 = filt([1 -0.2], [1 -0.4 -0.17 0.06]);
d_1=4; 
%5--0% 1.35--10%  1--20%  0.9--28%  0.8--34% 0.7--36%
sat_alpha_set_1=[5 1.6 1.1 0.9 0.8 0.7];
%算例1-2-------------------------------------------------------------

KZQ_1_2 = 0.3*filt([0.725 -1.208 0.519], [1 -1]); 
T_1_2 = filt([zeros(1,4) 1], [1 -0.8]);
N_1_2 = filt([1 -0.2], [1 -0.4 -0.17 0.06]);
d_1_2=4; 
sat_alpha_set_1_2=0.3*[5 1.62 1.35 0.902];%5--0% 1.35--10%  1--20% 
%算例2-------------------------------------------------------------

KZQ_2 = filt([0.8305 -1.396 0.607], [1 -1]); 
T_2 = filt([zeros(1,6) 1], [1 -0.8]);
N_2 = filt([1 0.6], [1 0.1 -0.67 -0.025 0.105]);
d_2=6;
sat_alpha_set_2=[5 2.05 1.75 1.3 1.08 0.9 0.55 0.41 0.287 0.15 0];%2.05--10%  1.75--20%  ...0--100%

%算例3-------------------------------------------------------------
kzq_fenzi_3=[0.7249 -1.207 0.5186];
kzq_fenmu_3=[1 -1];
T_fenzi_3=[zeros(1,3) 0.6299];
T_fenmu_3=[1 -0.8899];
N_fenzi_3=[1 0];
N_fenmu_3=[1 -0.8899];

KZQ_3 = filt(kzq_fenzi_3,kzq_fenmu_3 ); 
T_3 = filt(T_fenzi_3,T_fenmu_3);
N_3 = filt(N_fenzi_3,N_fenmu_3);

d_3=3;
sat_alpha_set_3=[5 1.5 1.3 1 0];%2.05--10%  1.75--20%  ...0--100%
%-------------------------------------------------------------


%% 选择模型
choose_model=3;

if choose_model==1
    KZQ = KZQ_1;
    T = T_1;
    N = N_1;
    d=d_1;
    sat_alpha_set=sat_alpha_set_1;
elseif choose_model==11
    KZQ = KZQ_1_2;
    T = T_1_2;
    N = N_1_2;
    d=d_1_2;
    sat_alpha_set=sat_alpha_set_1_2;
elseif choose_model==2
    KZQ = KZQ_2;
    T = T_2;
    N = N_2;
    d = d_2;
    sat_alpha_set=sat_alpha_set_2;
elseif choose_model==3
    kzq_fenzi=kzq_fenzi_3;
    kzq_fenmu=kzq_fenmu_3;
    T_fenzi=T_fenzi_3;
    T_fenmu=T_fenmu_3;
    N_fenzi=N_fenzi_3;
    N_fenmu=N_fenmu_3;
    KZQ = KZQ_3;
    T = T_3;
    N = N_3;
    d = d_3;
    sat_alpha_set=sat_alpha_set_3;
else 
   disp('choose model again');
end
G=N/(1+T*KZQ);
%% 算例* 不同饱和度 simlink仿真(_________________________________________________
choose_sim_model=3;%选择仿真模型
%初始化
Sat_percent=zeros(1,length(sat_alpha_set));
g_est=zeros(length(sat_alpha_set),1001);
var_u    =zeros(1,length(sat_alpha_set));
var_sat_u=zeros(1,length(sat_alpha_set));
var_y    =zeros(1,length(sat_alpha_set));

for sat_alpha_i=1:1:length(sat_alpha_set)
sat_alpha=sat_alpha_set(sat_alpha_i);
if choose_sim_model==1
    sim('Sat_Nonliner_N_P');
elseif choose_sim_model==2
    sim('Sat_Nonliner_2');
elseif choose_sim_model==3
    sim('Sat_Nonliner_3');%传入sat_alpha  *_fenzi  *_fenmu
elseif choose_sim_model==11
    sim('Sat_Nonliner_N_P_switchQ.mdl');
else
    disp('NO sim!');
end

sat_num=0;%计算饱和度
sat_num_all=1000;
for i=1:1:sat_num_all
    if(abs(u_k(i))>sat_alpha_set(sat_alpha_i)) 
        sat_num=sat_num+1;
    end
end
Sat_percent(sat_alpha_i)=sat_num/sat_num_all*100;
var_u(sat_alpha_i)    =var(u_k);%输入方差
var_sat_u(sat_alpha_i)=var(sat_u_k);%饱和输入方差
var_y(sat_alpha_i)=var(y_k);%输出方差
% 仿真输出数据进行FCOR
g_est(sat_alpha_i,:)=fc(y_k(1:Data_Am));%Fcor
end
%% _________________________________________________

%% 采集仿真数据
% Sat_percent_1=Sat_percent;
% g_est_1=g_est;
var_n_case_3=var(n_k).^0.5;
var_y_case_3=var_y.^0.5;
var_u_case_3=var_u.^0.5;
var_sat_u_case_3=var_sat_u.^0.5;

Sat_percent_3=Sat_percent;
g_est_3=g_est;

var_y_est_3=zeros(1,4);
for sat_percent_i=1:1:4
    for var_i=1:1:200
     var_y_est_3(sat_percent_i)=var_y_est_3(sat_percent_i)+g_est_3(sat_percent_i,var_i)^2;
    end
end

g_est_3_temp=g_est_3(:,1:100);
figure;
plot(g_est_3_temp');


% Sat_percent_switch=Sat_percent;
% g_est_switch=g_est;



% %% 联立求解 N P(脉冲响应）
% 
% lagOp_lenth=50;
% impKZQ = impulse(KZQ,lagOp_lenth)';
% % %1.饱和联立
% % impG_est_1=g_est(2,1:lagOp_lenth);
% % impG_est_2=g_est(5,1:lagOp_lenth);
% % k1 = (100 - Sat_percent(2)) * 0.01;
% % k2 = (100 - Sat_percent(5)) * 0.01;
% %2.算例一切控制器 饱和联立
% load('g_est_switch.mat');
% load('Sat_percent_switch.mat');
% impG_est_1=g_est_switch(2,1:lagOp_lenth);
% impG_est_2=g_est_switch(3,1:lagOp_lenth);
% k1 =(100 - Sat_percent_switch(2)) * 0.01;
% k2 =(100 - Sat_percent_switch(3)) * 0.01;
% 
% G1 = LagOp(impG_est_1); 
% G2 = LagOp(impG_est_2); 
% KZQ_lag = LagOp(impKZQ);  
% % 使用LagOp构建T_est的滞后算子多项式 联立求解
% T_est_lag = (G1 - G2) / (k2 * KZQ_lag * G2 - k1 * KZQ_lag * G1);
% N_est_lag = G1 * (1 + k1 * T_est_lag * KZQ_lag);
% 
% % 提取T_est_lag和N_est_lag的系数
% T_est_coeffs = toCellArray(T_est_lag);
% T_est_coeffs = cell2mat(T_est_coeffs');
% N_est_coeffs = toCellArray(N_est_lag);
% N_est_coeffs = cell2mat(N_est_coeffs');
% 
% 
% % 提取画图数据
% plot_lenth=lagOp_lenth;
% T_est_i = zeros(1,plot_lenth);
% T_est_i(d+1:plot_lenth) = T_est_coeffs(d+1:plot_lenth);
% N_est_i = N_est_coeffs(1:plot_lenth);
% T_i = impulse(T, plot_lenth-1);
% N_i = impulse(N, plot_lenth-1);
% 
% % 绘制脉冲响应对比图
% figure; % 创建一个新的图形窗口
% 
% plot(0:plot_lenth-1,T_i, 'r-*', 'LineWidth', 2); % 绘制T系统的脉冲响应，红色点划线，线宽为2
% hold on; % 保持当前图形，以便在同一图上绘制另一条线
% plot(0:plot_lenth-1,N_i, 'g-*', 'LineWidth', 2); % 绘制N系统的脉冲响应，黑色点线，线宽为2
% plot(0:plot_lenth-1,T_est_i, 'r-.>', 'LineWidth', 2); % 绘制N_est系统的脉冲响应，绿色虚线，线宽为2
% plot(0:plot_lenth-1,N_est_i, 'g-.>', 'LineWidth', 2); % 绘制T_est系统的脉冲响应，蓝色实线，线宽为2
% hold off; % 释放图形，不再绘制新线
% 
% % 添加图例
% legend('Theoretical T', 'Theoretical N ', 'Estimated T  ', 'Estimated N');
% % 添加标题和坐标轴标签
% title('Impulse Response Comparison');
% xlabel('Time step');
% ylabel('Amplitude');
% % 显示网格
% grid on;
% 
% % T_est=Tansfor(T_est_i(1:40)',d,1,20);
% % N_est=Tansfor(N_est_i(1:40),0,3,20);
% % plot(1:50,impulse(T,49),1:50,impulse(T_est,49));


%% 高鑫桐估计N
%load('g_est_switch.mat');%加载FCOR后的 饱和闭环脉冲响应g_i
load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\Sat_model\g_est_3.mat');
g_est_gxt=g_est_3;
for sat_percent_i=1:1:4
    N_order_case=3;
    % N_gxt_est(sat_percent_i)=  estimate_N_Sxt(d,g_est_gxt(sat_percent_i,1:50),N_order_case);%根据不同的N阶次修改
    % G_sat_est(sat_percent_i)=Tansfor(g_est_gxt(sat_percent_i,1:100)',0,12,50);
    T_gxt_est_temp=(N_gxt_est(sat_percent_i)-G_sat_est(sat_percent_i))/(KZQ*G_sat_est(sat_percent_i));
    imp_T_gxt_est_temp=impulse(T_gxt_est_temp);
    imp_T_gxt_est_temp(1:d)=zeros(1,d);
    T_order=1;
    T_gxt_est(sat_percent_i)=Tansfor(imp_T_gxt_est_temp(1:58),d,T_order,20);
end

for sat_percent_i=1:1:4
d_err=(1-Sat_percent_3(sat_percent_i)/100);
T_gxt_est(sat_percent_i)=T_gxt_est(sat_percent_i)/d_err;
% figure;
% plot(1:50,impulse(G_sat_est(sat_percent_i),49),'b--',1:50,impulse(G,49),'r-');%饱和估计值 无饱和理论值
% figure;
% plot(1:50,impulse(N_gxt_est(sat_percent_i),49),'b--',1:50,impulse(N,49),'r-');%饱和估计值 无饱和理论值
figure;
plot(1:50,impulse(T_gxt_est(sat_percent_i),49),'b--',1:50,impulse(T,49),'r-');%饱和估计值 无饱和理论值
end
