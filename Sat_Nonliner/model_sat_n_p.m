function [T_gxt_est , N_gxt_est,Sat_percent] =model_sat_n_p(P,N,KZQ,d,sat_alpha_1,Data_Am)
    % 提取分子和分母
    [kzq_fenzi, kzq_fenmu] = tfdata(KZQ, 'v');
    [T_fenzi, T_fenmu] = tfdata(P, 'v');%包含时延
    [N_fenzi, N_fenmu] = tfdata(N, 'v');
    sat_alpha=sat_alpha_1;
    % 确保仿真模型已加载
    assignin('base', 'kzq_fenzi', kzq_fenzi);
    assignin('base', 'kzq_fenmu', kzq_fenmu);
    assignin('base', 'T_fenzi', T_fenzi);
    assignin('base', 'T_fenmu', T_fenmu);
    assignin('base', 'N_fenzi', N_fenzi);
    assignin('base', 'N_fenmu', N_fenmu);
    assignin('base', 'sat_alpha', sat_alpha);
    sim('Sat_Nonliner_3');   
    %计算饱和度
    sat_num=0;
    sat_num_all=1000;
    for i=1:1:sat_num_all
        if(abs(u_k(i))>sat_alpha) 
            sat_num=sat_num+1;
        end
    end
    Sat_percent=sat_num/sat_num_all*100;
    % 仿真输出数据进行FCOR
    g_est=fc(y_k(1:Data_Am));%Fcor
    %% 高鑫桐估计N
    N_order_case=3;%根据不同的N阶次修改
    N_gxt_est=estimate_N_Sxt(d,g_est(1:50),N_order_case);
    G_sat_est=Tansfor(g_est(1:100)',0,12,50);
    T_gxt_est_temp=(N_gxt_est-G_sat_est)/(KZQ*G_sat_est);
    imp_T_gxt_est_temp=impulse(T_gxt_est_temp);
    imp_T_gxt_est_temp(1:d)=zeros(1,d);
    T_order=1;%根据不同的T阶次修改
    T_gxt_est=Tansfor(imp_T_gxt_est_temp(1:58),d,T_order,20);
end