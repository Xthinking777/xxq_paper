%LQG基准的PID控制器下 饱和情况真实的LQG基准
%饱和度固定在10% T修正后 LQG基准PID控制器

% clear
Data_Am=80000;%Amount of output data for close-loop system
Data_G=1000;%Closed loop impulse response truncated data

load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\H_LQG_3D_ALL.mat');
% 提取每个传递函数的分子和分母
load('T_gxt_est_case3.mat');
for T_gxt_est_i = 1:6
    [num, den] = tfdata(T_gxt_est(T_gxt_est_i), 'v');
    T_gxt_est_fenzi{T_gxt_est_i} = num;
    T_gxt_est_fenmu{T_gxt_est_i} = den;
end

for sat_i=1:1:6%不同饱和度η
for kzq_i=1:1:7%不同的λ
%% 定义模型
%算例3-------------------------------------------------------------
lqg_kzq_fenzi=squeeze(LQG_3D_ALL(sat_i,:,4:6));
kzq_fenzi_3=lqg_kzq_fenzi(kzq_i,:);%选择不同的控制器(不同的λ)
kzq_fenmu_3=[1 -1];
% T_fenzi_3= T_gxt_est_fenzi{sat_i};
% T_fenmu_3= T_gxt_est_fenmu{sat_i};
T_fenzi_3=[zeros(1,3) 0.6299];
T_fenmu_3=[1 -0.8899];
N_fenzi_3=[1 0];
N_fenmu_3=[1 -0.8899];

KZQ_3 = filt(kzq_fenzi_3,kzq_fenmu_3 ); 
T_3 = filt(T_fenzi_3,T_fenmu_3);
N_3 = filt(N_fenzi_3,N_fenmu_3);

d_3=3;
% sat_alpha_set_3=[ 10 ];% [5 1.5 1.3 1 0.8 0.6]
if sat_i==1
    sat_alpha_set_3=[  5 ];% [5 1.5 1.3 1 0.8 0.6]
    elseif sat_i==2
    sat_alpha_set_3=[ 1.5 ];% [5 1.5 1.3 1 0.8 0.6] 
    elseif sat_i==3
    sat_alpha_set_3=[ 1.3 ];% [5 1.5 1.3 1 0.8 0.6]   
    elseif sat_i==4
    sat_alpha_set_3=[ 1   ];% [5 1.5 1.3 1 0.8 0.6]   
    elseif sat_i==5
    sat_alpha_set_3=[ 0.8 ];% [5 1.5 1.3 1 0.8 0.6] 
    elseif sat_i==6
    sat_alpha_set_3=[ 0.6 ];% [5 1.5 1.3 1 0.8 0.6]   
end
%-------------------------------------------------------------
%% 选择模型
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
G=N/(1+T*KZQ);


%% 算例* 不同饱和度 simlink仿真(_________________________________________________

%初始化
Sat_percent=zeros(1,length(sat_alpha_set));
g_est=zeros(length(sat_alpha_set),1001);
var_u    =zeros(1,length(sat_alpha_set));
var_sat_u=zeros(1,length(sat_alpha_set));
var_y    =zeros(1,length(sat_alpha_set));

for sat_alpha_i=1:1:length(sat_alpha_set)%遍历饱和度
sat_alpha=sat_alpha_set(sat_alpha_i);
sim('Sat_Nonliner_3');%传入sat_alpha  *_fenzi  *_fenmu

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
end
%% _________________________________________________
%% 采集仿真数据
sim_var_y_case_3(sat_i,kzq_i)=var_y.^0.5;
sim_var_sat_u_case_3(sat_i,kzq_i)=var_sat_u.^0.5;
sim_var_u_case_3(sat_i,kzq_i)=var_u.^0.5;
sim_percent_3(sat_i,kzq_i)=Sat_percent;

% 保存数据到.mat文件
save('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\sim_var_sat_u_case_3.mat', 'sim_var_sat_u_case_3');
save('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\sim_var_y_case_3.mat', 'sim_var_y_case_3');
save('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\sim_var_u_case_3.mat', 'sim_var_y_case_3');
end
end




% % 提取不同饱和度下的分子系数
% lqg_kzq_fenzi_1 = squeeze(LQG_3D_ALL(1,:,4:6)); % 不同饱和度
% lqg_kzq_fenzi_2 = squeeze(LQG_3D_ALL(6,:,4:6)); % 不同饱和度
% % 初始化滤波器数组
% KZQ_1 = cell(1, 7);
% KZQ_2 = cell(1, 7);
% % 创建滤波器
% for kzq_i = 1:2
%     KZQ_1{kzq_i} = filt([lqg_kzq_fenzi_1(kzq_i,:)],[1 -1]);
%     KZQ_2{kzq_i} = filt([lqg_kzq_fenzi_2(kzq_i,:)],[1 -1]);
% end
% % 绘制脉冲响应
% figure;
% colors = ['b', 'r', 'g', 'c', 'm', 'y','k'];  % 定义颜色数组
% lineWidth = 1;  % 设置线宽为2
% % 绘制 KZQ_1 的脉冲响应（实线）
% for kzq_i = 1:2
%     sys = KZQ_1{kzq_i};
%     [y, t] = impulse(sys);  % 使用默认时间向量
%     plot(t, y, ['-' colors(kzq_i)], 'LineWidth', lineWidth);  % 使用实线绘制
%     hold on;
% end
% % 绘制 KZQ_2 的脉冲响应（虚线）
% for kzq_i = 1:2
%     sys = KZQ_2{kzq_i};
%     [y, t] = impulse(sys);  % 使用默认时间向量
%     plot(t, y, ['--' colors(kzq_i)], 'LineWidth', lineWidth);  % 使用虚线绘制
%     hold on;
% end
% % 设置图例和标签
% legend( 'KZQ_1_1', 'KZQ_1_2', 'KZQ_1_3', 'KZQ_1_4', 'KZQ_1_5', 'KZQ_1_6' ,'KZQ_1_7'...
%        ,'KZQ_2_1', 'KZQ_2_2', 'KZQ_2_3', 'KZQ_2_4', 'KZQ_2_5', 'KZQ_2_6' ,'KZQ_2_7');
% xlabel('Time');
% ylabel('Impulse Response');
% title('Impulse Responses of KZQ_1 (Solid) and KZQ_2 (Dashed) for Different Saturation Percentages');
% grid on;
% hold off;