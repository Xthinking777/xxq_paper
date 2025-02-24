%% 选择模型
% clear
N_thero = filt([1 0], [1 -0.8899]);


choose_model_set=['H0','H1','H2','H3','H4','H5'];
% choose_model_set=['H0','H1','H2'];
for choose_model_set_i=1:2:length(choose_model_set)-1 
%% 选择模型
choose_model = [choose_model_set(choose_model_set_i) choose_model_set(choose_model_set_i+1)];
switch choose_model
     case 'H0'
        % 非线性估计模型GXT 饱和度1
        load('T_gxt_est.mat');
        load('N_gxt_est.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(1) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(1);%带时延
        fprintf('饱和度%d%%估计模型GXT\n', Sat_percent_3(1));
     case 'H1'
        % 非线性估计模型GXT 饱和度2
        load('T_gxt_est.mat');
        load('N_gxt_est.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(2) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(2);%带时延
        fprintf('饱和度%d%%估计模型GXT\n', Sat_percent_3(2));
     case 'H2'
        % 非线性估计模型GXT 饱和度3
        load('T_gxt_est.mat');
        load('N_gxt_est.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(3) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(3);%带时延
        fprintf('饱和度%d%%估计模型GXT\n', Sat_percent_3(3));
    case 'H3'
        % 非线性估计模型GXT 饱和度4
        load('T_gxt_est.mat');
        load('N_gxt_est.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(4) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(4);%带时延
        fprintf('饱和度%2d%%估计模型GXT\n', Sat_percent_3(4));
    case 'H4'
        % 非线性估计模型GXT 饱和度4
        load('T_gxt_est.mat');
        load('N_gxt_est.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(5) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(5);%带时延
        fprintf('饱和度%2d%%估计模型GXT\n', Sat_percent_3(5));
    case 'H5'
        % 非线性估计模型GXT 饱和度4
        load('T_gxt_est.mat');
        load('N_gxt_est.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(6) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(6);%带时延
        fprintf('饱和度%2d%%估计模型GXT\n', Sat_percent_3(6));
   
    otherwise
        disp('无效的模型');
end


LQG_3D=LQG_FPID(N,T,d);%高

LQG_3D_ALL((choose_model_set_i+1)/2,:,:)=LQG_3D;

end
save('D:\Users\xthinking\Documents\MATLAB\xxq_code1218Git\xxq_paper\Sat_Nonliner\mat\LQG_plot\H_LQG_3D_ALL.mat');

Sat_percent=Sat_percent_3(1:3);
plot_LQG(LQG_3D_ALL,Sat_percent);