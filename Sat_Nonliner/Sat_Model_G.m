%经济指标数值算例 模型估计
clear
Data_Am=2000;%Amount of output data for close-loop system
Data_G=300;%Closed loop impulse response truncated data
sim('Pid_MVC_final');
%定义模型
KZQ_1=filt([2.841 -4.406 1.749],[1 -1]); 
T_1=filt([zeros(1,5) 0.2],[1 -0.8]);
N_1=filt([1 0],[1 -0.1 -0.2]);

%选择模型
KZQ=KZQ_1;
T=T_1;
N=N_1;

y_out=Fcor(KZQ,T,N,y_a);%Generate output data
g_est=fc(y_out(1:Data_Am));%Fcor
G_est=filt(g_est(1:Data_G),1);
G_theo=N/(1+T*KZQ);
% G1=G;
G_theo_i=impulse(G_theo,100);
G_est_i=impulse(G_est,100);
plot(G_theo_i,100);
plot(G_est_i,100);




