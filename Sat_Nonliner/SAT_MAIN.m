Data_Am=80000;
%选择模型
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
% sat_alpha_set_3=[5 1.5 1.3 1 0.8 0.7];%0    5.8000   10.0000   20.3000   32.7000   40.1000
%sat_alpha_set_3=[5  1 0.78 0.67];%0   20.3  42.2	 34.3
sat_alpha_set_3_main=[5  0.67 ];%0   20.3  42.2	 34.3
%sat_alpha_set_3=[0.55 0.38 0.3];%2.05--10%  1.3--20%  1--30...0--100%  77.6	69.3	53.3
%-------------------------------------------------------------
%model_sat_n_p(P,N,KZQ,d,sat_alpha,Data_Am)

%% 仿真数据建模N 拟合P-->画拟合LQG
for sat_alpha_i=1:1:length(sat_alpha_set_3_main)
    sat_alpha=sat_alpha_set_3_main(sat_alpha_i);
    [TT3,NN3,Sat_percent_main(sat_alpha_i)]=model_sat_n_p(T_3,N_3,KZQ_3,3,sat_alpha,Data_Am);%建模
    T_temp(sat_alpha_i)=TT3;
    d=3;
    LQG_3D=LQG_FPID(NN3,TT3,d);%求LQG
    LQG_3D_ALL(sat_alpha_i,:,:)=LQG_3D;
end

%% 将拟合LQG上的的控制器放入仿真 画出仿真LQG
lqg_kzq_fenzi=squeeze(LQG_3D_ALL(2,1:7,4:6));%控制器集(分子)
for lqg_kzq_i=1:1:7
kzq_set(lqg_kzq_i) = filt(lqg_kzq_fenzi(lqg_kzq_i,1:3),kzq_fenmu_3); 
end
n=N_3;
p=T_3;
alpha=sat_alpha_set_3_main(2);
[var_u_sim_set,var_sat_u_sim_set,var_y_sim_set,sat_percent_sim_set]=sim_sat_lqg(kzq_set,n,p,alpha);
% %% 将仿真LQG的第二点再进行仿真拟合 画出拟合LQG(拟合： 伪P= P + 饱和环节)
% lqg_kzq_fenzi=squeeze(LQG_3D_ALL(2,:,4:6));%不同控制器集
% kzq_fenzi_3=lqg_kzq_fenzi(2,:);%选择不同的控制器(不同的λ)
% lqg_kzq = filt(kzq_fenzi_3,kzq_fenmu_3 ); 
% sat_alpha=0.78;%  20%
% [T_lqg_kzq,NN3,Sat_percent_lqg_kzq]=model_sat_n_p(T_3,N_3,lqg_kzq,d,sat_alpha,Data_Am);%建模
% LQG_3D=LQG_FPID(NN3,T_lqg_kzq,d);%求LQG

%取方差数据
var_y(1:2,1:7)=LQG_3D_ALL(1:2,:,2);
var_u(1:2,1:7)=LQG_3D_ALL(1:2,:,3);
var_y(3,1:7)=var_y_sim_set(1:7);
var_u(3,1:7)=var_u_sim_set(1:7);
% var_y(4,1:7)=LQG_3D(:,2);
% var_u(4,1:7)=LQG_3D(:,3);
%绘图
plot_LQG(var_u,var_y,3);

