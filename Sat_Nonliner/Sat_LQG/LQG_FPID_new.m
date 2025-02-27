%% 选择模型
choose_model = 'H0';

switch choose_model
    case 'A'
        %数值算例原模型
        NN=filtx([1],[1 -0.8899]);
        TT=filt(0.6299,[1 -0.8899]);
        d=3;
        N=NN;
        T=TT*filt([zeros(1,d) 1],1);
        disp('数值算例原模型');
    case 'B'
        %工业实例原模型
        NN=filt([0.045],[1 -0.93]);
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
        NN = filt([1 0.6], [1 0.1 -0.67 -0.025 0.105]);
        TT = filt([1 0], [1 -0.8]);%去时延
        d = 6;
        N = NN;
        T = TT * filt([zeros(1, d) 1], 1);%带时延
        disp('无饱和原模型2');
     case 'H0'
        % 非线性估计模型GXT 饱和度1
        load('T_gxt_est_case2.mat');
        load('N_gxt_est_case2.mat');
        load('Sat_percent_2.mat');
        NN = N_gxt_est(1);
        TT = T_gxt_est(1) * filt(1,[zeros(1, d) 1]);%去时延
        d = 6;
        N = NN;
        T =T_gxt_est(1);%带时延
        fprintf('饱和度%d%%估计模型GXT\n', Sat_percent_2(1));
     case 'H1'
        % 非线性估计模型GXT 饱和度2
        load('T_gxt_est_case2.mat');
        load('N_gxt_est_case2.mat');
        load('Sat_percent_2.mat');
        NN = N_gxt_est(2);
        TT = T_gxt_est(2) * filt(1,[zeros(1, d) 1]);%去时延
        d = 6;
        N = NN;
        T =T_gxt_est(2);%带时延
        fprintf('饱和度%d%%估计模型GXT\n', Sat_percent_2(2));
     case 'H2'
        % 非线性估计模型GXT 饱和度3
        load('T_gxt_est_case2.mat');
        load('N_gxt_est_case2.mat');
        load('Sat_percent_2.mat');
        NN = N_gxt_est(3);
        TT = T_gxt_est(3) * filt(1,[zeros(1, d) 1]);%去时延
        d = 6;
        N = NN;
        T =T_gxt_est(3);%带时延
        fprintf('饱和度%d%%估计模型GXT\n', Sat_percent_2(3));
    case 'H3'
        % 非线性估计模型GXT 饱和度4
        load('T_gxt_est_case2.mat');
        load('N_gxt_est_case2.mat');
        load('Sat_percent_2.mat');
        NN = N_gxt_est(4);
        TT = T_gxt_est(4) * filt(1,[zeros(1, d) 1]);%去时延
        d = 6;
        N = NN;
        T =T_gxt_est(4);%带时延
        fprintf('饱和度%d%%估计模型GXT\n', Sat_percent_2(4));
    otherwise
        disp('无效的模型');
end




%LQG_3D(:,1)=[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0  2 3 4 5 6 7 8 9 10];%λ集合 算例3
%lmd_set=[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0  2 3 4 5 6 7];%λ集合 算例2 估计值
%% 改变λ
lmd_set=[0 0.1 0.4 1 3 5 50];%λ集合

NUM_lmd = length(lmd_set);
LQG_3D=zeros(NUM_lmd,7);%lmd var(y) var(u) PID F
LQG_3D(:,1)=lmd_set;%λ集合 算例1估计值

for lmd_i=1:1:NUM_lmd%遍历λ
lmd=LQG_3D(lmd_i,1);%LQG参数λ
%% FPID参数τ
aimin = 11;  % FPID参数τ
aimax = 11;
J = zeros(21, 4);    % 21*4 零矩阵  21个τ 存储方差信息
xxx = zeros(21, 3);  % 21*3 pid的三个参数
for tau_i=aimin:1:aimax%遍历τ
tau=-1+(tau_i-1)*0.1;

% 定义优化目标函数
objective_func = @(pid_pram) calculate_qq(pid_pram, NN, TT, d, lmd,tau);
    x0=[0 0 0];
    A = [-1 -1 -1;0 1 2;0 0 -1];
    b = [-0.0001;-0.0001;-0.0001];
    Aeq = [];
    beq = [];
%     VLB = [0 -1000 0];
%     VUB = [10000 0 10000];
    VLB = [];
    VUB = [];
% 设置fmincon的选项，关闭显示
options = optimoptions('fmincon', 'Display', 'off');
% 调用fmincon函数，并将选项作为参数传递
xxx(tau_i,:) = fmincon(objective_func, x0, A, b, Aeq, beq, VLB, VUB, [], options);

KZQ1=filt(xxx(tau_i,:),[1 -1+tau -tau]);
GGG1=NN/(1+TT*filt([zeros(1,d) 1],1)*KZQ1);%G
ggg1=impulse(GGG1,1030);%对应g(i)
GGG2=NN*KZQ1/(1+TT*filt([zeros(1,d) 1],1)*KZQ1);%H
ggg2=impulse(GGG2,1030);%对应h(i)
GGG3=N/(1+TT*KZQ1);%去时延的G
ggg3=impulse(GGG3,1030);
for i=1:1:d+1000%lqg
    J(tau_i,1)=J(tau_i,1)+ggg1(i)^2+lmd*ggg2(i)^2;
end
    dn=3;
    NUM=dn*d; %优化长度 每过一个时延 阶数增加一
for i=1:1:d+NUM   %部分lqg
    J(tau_i,2)=J(tau_i,2)+ggg1(i)^2+lmd*ggg2(i)^2;
end
for i=1:1:d+1000%var(y)
    J(tau_i,3)=J(tau_i,3)+ggg1(i)^2;
end
for i=1:1:d+1000%var(u)
     J(tau_i,4)=J(tau_i,4)+ggg2(i)^2;
end

end

%%找到LQG最小的对应的最优τ
Jmin=100000;
tau_opt_i=11;%初值为0
for i=aimin:1:aimax
    if Jmin>J(i,1)
        tau_opt_i=i;%记录最优τ对应的下标
        Jmin=J(i,1);
    end
end
%%记录数据
kcs=xxx(tau_opt_i,:);
tau_opt=-1+(tau_opt_i-1)*0.1;
fprintf('\nlmd        lqg         lqg       var(y)       var(u):\n %f %f  %f  %f  %f\n',...
         lmd,J(tau_opt_i,1),J(tau_opt_i,2),sqrt(J(tau_opt_i,3)),sqrt(J(tau_opt_i,4)));
fprintf("FPID:\n %f %f %f %f",tau_opt,kcs);
LQG_3D(lmd_i,2)=sqrt(J(tau_opt_i,3));%var(y)
LQG_3D(lmd_i,3)=sqrt(J(tau_opt_i,4));%var(u)
LQG_3D(lmd_i,4)=kcs(1);%k1
LQG_3D(lmd_i,5)=kcs(2);%k2
LQG_3D(lmd_i,6)=kcs(3);%k3
LQG_3D(lmd_i,7)=tau_opt;%tau

end

% 计算qq(LQG)的函数(用FPID参数表示出LQG基准)
function qq = calculate_qq(pid_pram, NN, TT, d, lmd,aa)
    % 提取PID参数
    a1 = double(pid_pram(1));
    a2 = double(pid_pram(2));
    a3 = double(pid_pram(3));

    % 计算系统响应并更新gf1, gf2, gf3 (和你原来的代码一样)
    dn=3;
    NUM=dn*d; %优化长度 每过一个时延 阶数增加一

    P1=TT*filt(1,[1 -1])*filt(1,[1 -aa]);%去时延对象*pid分母*F
    p1=impulse(P1,100);
    n= impulse(NN,100);
    %gf(1)=g(i)输出响应
    gf1=sym(zeros(1,200));
    for i=1:1:d
        gf1(i)=n(i);
    end
    for i=1:1:NUM
        k1=0;
        k2=0;
        k3=0;
        for j=1:1:i
            k1=k1+gf1(j)*p1(i-j+1);
        end
        if i>1
            for j=1:1:i-1
                k2=k2+gf1(j)*p1(i-j);
            end
        end
        if i>2
            for j=1:1:i-2
                k3=k3+gf1(j)*p1(i-j-1);
            end
        end
        gf1(d+i)=n(d+i)-k1*a1-k2*a2-k3*a3;
    end
    %gf(2)：求输入响应h(i)的中间变量
    n2=impulse(NN*filt(1,[1 -1])*filt(1,[1 -aa]),100);%Nu响应 乘了FPID的 F 和 分母部分
    gf2=sym(zeros(1,200));
    for i=1:1:d
        gf2(i)=n2(i);
    end
    for i=1:1:NUM-d
        k1=0;
        k2=0;
        k3=0;
        for j=1:1:i
            k1=k1+gf2(j)*p1(i-j+1);
        end
        if i>1
            for j=1:1:i-1
                k2=k2+gf2(j)*p1(i-j);
            end
        end
        if i>2
            for j=1:1:i-2
                k3=k3+gf2(j)*p1(i-j-1);
            end
        end
        gf2(d+i)=n2(d+i)-k1*a1-k2*a2-k3*a3;
    end
    %gf(3)=h(i)输入响应
    gf3=sym(zeros(1,200));
    gf3(1)=a1*gf2(1);
    gf3(2)=a1*gf2(2)+a2*gf2(1);
    for i=3:1:200
        gf3(i)=a1*gf2(i)+a2*gf2(i-1)+a3*gf2(i-2);
    end
    
    qq=double(0.0);%LQG
    %最小方差
    for i=1:1:d+NUM
        qq=qq+double(gf1(i)^2);
    end
    %LQG
    for i=1:1:NUM
        qq=qq+double(lmd)*double(gf3(i)^2);
    end

end
