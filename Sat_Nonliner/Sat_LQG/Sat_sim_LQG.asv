%LQG基准的PID控制器下 饱和情况真实的LQG基准
%饱和度固定在10% T修正后 LQG基准PID控制器

clear
Data_Am=80000;%Amount of output data for close-loop system
Data_G=1000;%Closed loop impulse response truncated data

load('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\H_2_LQG_3D.mat');
% var_y_2 =LQG_3D(:,2);
% var_u_2 =LQG_3D(:,3);

lqg_kzq_fenzi=LQG_3D(:,4:6);


for kzq_i=1:1:7

%% 定义模型
%算例3-------------------------------------------------------------
kzq_fenzi_3=lqg_kzq_fenzi(kzq_i,:);%选择不同的控制器
%kzq_fenzi_3=[0.7249 -1.207 0.5186];
kzq_fenmu_3=[1 -1];

T_fenzi_3=[zeros(1,3) 0.6299];
T_fenmu_3=[1 -0.8899];
N_fenzi_3=[1 0];
N_fenmu_3=[1 -0.8899];

KZQ_3 = filt(kzq_fenzi_3,kzq_fenmu_3 ); 
T_3 = filt(T_fenzi_3,T_fenmu_3);
N_3 = filt(N_fenzi_3,N_fenmu_3);

d_3=3;
sat_alpha_set_3=[ 1.3 ];%1.3--10% 
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

for sat_alpha_i=1:1:length(sat_alpha_set)
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
sim_var_y_case_3(kzq_i)=var_y.^0.5;
sim_var_sat_u_case_3(kzq_i)=var_sat_u.^0.5;

end

