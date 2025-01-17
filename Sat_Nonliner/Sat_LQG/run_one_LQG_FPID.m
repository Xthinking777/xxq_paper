%% 选择模型
% clear
N_thero = filt([1 0], [1 -0.8899]);


% choose_model_set=['H0','H1','H2','H3','H4','H5'];
choose_model_set=['H0','H1','H2'];
for choose_model_set_i=1:2:length(choose_model_set)-1 
%% 选择模型
choose_model = [choose_model_set(choose_model_set_i) choose_model_set(choose_model_set_i+1)];
switch choose_model
    case 'A'
        %数值算例原模型
        NN=filt([1],[1 -0.8899]);
        TT=filt(0.6299,[1 -0.8899]);
        d=3;
        N=NN;
        T=TT*filt([zeros(1,d) 1],1);
        disp('数值算例原模型');
    case 'B'
        %工业实例原模型
        NN=filt([0.045 0],[1 -0.93]);
        TT=filt(0.4866,[1 -0.5134]);
        d=6;
        N=NN;
        T=TT*filt([zeros(1,d) 1],1);
        disp('工业实例原模型');
    case 'C'
      %数值算例1(估计值)
        NN=filt([1.01 -0.0297],[1 -0.924 0.0320]);
        TT=filt([0.6282 0.1882 0.2092 -0.01687],[1 -0.5742 0.04330 -0.3020]);
        d=3;
        N=NN;
        T=TT*filt([zeros(1,d) 1],1);%加上时延
        disp('数值算例1(估计值)');
    case 'D'
       %工业实例2(估计值)
        NN=filt([0.0453 -0.00868],[1 -1.12 0.185 0 0 -0.671*1e-4 0 0 7.39*1e-4 14.3*1e-4]);
        TT=filt([0.4797 -0.04317 0.01311 -0.01832],[1 -0.6183 0.08797 -0.05961]);
        d=6;
        N=NN;
        T=TT*filt([zeros(1,d) 1],1);
        disp('工业实例3(估计值)');
    case 'E'
       %工业实例3延迟焦化炉 原模型
        NN=filt([1 4.821], [1 -0.8899]);
        TT=filt([0.2155 0],[1 -0.9418]);
        d=6;
        N=NN;
        T=TT*filt([zeros(1,d) 1],1);
        disp('工业实例3延迟焦化炉');   
     case 'F'
        % 无饱和原模型
        NN = filt([1 -0.2], [1 -0.4 -0.17 0.06]);
        TT = filt([1 0], [1 -0.8]);%去时延
        d = 4;
        N = NN;
        T = TT * filt([zeros(1, d) 1], 1);%带时延
        disp('非线性原模型');
     case 'G'
        % 无饱和原模型2
        d = 3;
        NN = filt([1 0], [1 -0.8899]);
        TT = filt([0.6299 0], [1 -0.8899]);%去时延
        N = NN;
        T = TT * filt([zeros(1, d) 1], 1);%带时延
        disp('无饱和原模型2');
     case 'H0'
        % 非线性估计模型GXT 饱和度1
        load('T_gxt_est_case3.mat');
        load('N_gxt_est_case3.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(1) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(1);%带时延
        fprintf('饱和度%d%%估计模型GXT\n', Sat_percent_3(1));
     case 'H1'
        % 非线性估计模型GXT 饱和度2
        load('T_gxt_est_case3.mat');
        load('N_gxt_est_case3.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(2) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(2);%带时延
        fprintf('饱和度%d%%估计模型GXT\n', Sat_percent_3(2));
     case 'H2'
        % 非线性估计模型GXT 饱和度3
        load('T_gxt_est_case3.mat');
        load('N_gxt_est_case3.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(3) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(3);%带时延
        fprintf('饱和度%d%%估计模型GXT\n', Sat_percent_3(3));
    case 'H3'
        % 非线性估计模型GXT 饱和度4
        load('T_gxt_est_case3.mat');
        load('N_gxt_est_case3.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(4) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(4);%带时延
        fprintf('饱和度%2d%%估计模型GXT\n', Sat_percent_3(4));
    case 'H4'
        % 非线性估计模型GXT 饱和度4
        load('T_gxt_est_case3.mat');
        load('N_gxt_est_case3.mat');
        load('Sat_percent_3.mat');
        d = 3;
        NN =N_thero;
        TT = T_gxt_est(5) * filt(1,[zeros(1, d) 1]);%去时延
        N = NN;
        T =T_gxt_est(5);%带时延
        fprintf('饱和度%2d%%估计模型GXT\n', Sat_percent_3(5));
    case 'H5'
        % 非线性估计模型GXT 饱和度4
        load('T_gxt_est_case3.mat');
        load('N_gxt_est_case3.mat');
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

