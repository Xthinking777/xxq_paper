%LQG基准FPID
%经济指标测试

choose_model = 'C';

switch choose_model
    case 'A'
        % 数值算例原模型
        NN = filt([1], [1 -0.8899]);
        TT = filt(0.6299, [1 -0.8899]);
        d = 3;
        N = NN;
        T = TT * filt([zeros(1, d) 1], 1);
        disp('数值算例原模型');
    case 'B'
        % 工业实例原模型
        NN = filt([0.045], [1 -0.93]);
        TT = filt(0.4866, [1 -0.5134]);
        d = 6;
        N = NN;
        T = TT * filt([zeros(1, d) 1], 1);
        disp('工业实例原模型');
    case 'C'
        % 数值算例1(估计值)
        NN = filt([1.01 -0.0297], [1 -0.924 0.0320]);
        TT = filt([0.6282 0.1882 0.2092 -0.01687], [1 -0.5742 0.04330 -0.3020]);
        d = 3;
        N = NN;
        T = TT * filt([zeros(1, d) 1], 1); % 加上时延
        disp('数值算例1(估计值)');
    case 'D'
        % 工业实例2(估计值)
        NN = filt([0.0453 -0.00868], [1 -1.12 0.185 0 0 -0.671 * 1e-4 0 0 7.39 * 1e-4 14.3 * 1e-4]);
        TT = filt([0.4797 -0.04317 0.01311 -0.01832], [1 -0.6183 0.08797 -0.05961]);
        d = 6;
        N = NN;
        T = TT * filt([zeros(1, d) 1], 1);
        disp('工业实例3(估计值)');
    case 'E'
        % 工业实例3延迟焦化炉 原模型
        NN = filt([1 4.821], [1 -0.8899]);
        TT = filt([0.2155 0], [1 -0.9418]);
        d = 6;
        N = NN;
        T = TT * filt([zeros(1, d) 1], 1);
        disp('工业实例3延迟焦化炉');
    otherwise
        disp('无效的模型');
end

J = zeros(21, 4);  % 21*4零矩阵  21个τ 存储方差信息
xxx = zeros(21, 3);  % pid的三个参数
aimin = 11;  % FPID参数τ
aimax = 11;
lmd = 0.8;  % LQG参数λ
for ai=aimin:1:aimax
aa=-1+(ai-1)*0.1;
NAD = NN;
TAD = TT;
% 定义优化目标函数
objective_func = @(pid_pram) calculate_qq(pid_pram, NAD, TAD, d, 50, lmd,aa);
% 设置初始值，假设为 [0 0 0]0.4984   -0.7212    0.2241
initial_guess = [0.4984   -0.7212    0.2241];
% 使用fminsearch优化目标函数
optimal_pid_pram = fminsearch(objective_func, initial_guess);
% 输出优化结果
xxx(ai,:)=optimal_pid_pram;

KZQ1=filt(xxx(ai,:),[1 -1-aa aa]);
GGG1=NN/(1+TT*filt([zeros(1,d) 1],1)*KZQ1);%G
ggg1=impulse(GGG1,100030);%对应g(i)
GGG2=NN*KZQ1/(1+TT*filt([zeros(1,d) 1],1)*KZQ1);%H
ggg2=impulse(GGG2,100030);%对应h(i)
GGG3=N/(1+T*KZQ1);%去时延的G
ggg3=impulse(GGG3,100030);
for i=1:1:d+100000%lqg
    J(ai,1)=J(ai,1)+ggg1(i)^2+lmd*ggg2(i)^2;
end
for i=1:1:d+NUM   %lqg
    J(ai,2)=J(ai,2)+ggg1(i)^2+lmd*ggg2(i)^2;
end
for i=1:1:d+100000%var(y)
    J(ai,3)=J(ai,3)+ggg1(i)^2;
end
for i=1:1:d+100000%var(u)
     J(ai,4)=J(ai,4)+ggg2(i)^2;
end
figure(ai)
plot(ggg3,'r');%去时延脉冲响应


end

%%
%找到LQG最小的对应的最优τ
Jmin=100000;
ji=11;
% for i=aimin:1:aimax
%     if Jmin>J(i,1)
%         ji=i;%记录最优τ对应的下标
%         Jmin=J(i,1);
%     end
% end
%%
kcs=xxx(ji,:);
acs=-1+(ji-1)*0.1;
fprintf(' lqg    lqg    var(y)    var(u):\n %f  %f  %f  %f\n',...
         J(ji,1),J(ji,2),sqrt(J(ji,3)),sqrt(J(ji,4)));
fprintf("FPID:\n %f %f %f %f",acs,kcs);








% 计算qq(LQG)的函数(用FPID参数表示出LQG基准)
function qq = calculate_qq(pid_pram, NN, TT, d, NUM, lmd,aa)
    % 提取PID参数
    a1 = pid_pram(1);
    a2 = pid_pram(2);
    a3 = pid_pram(3);

    % 计算系统响应并更新gf1, gf2, gf3 (和你原来的代码一样)
    P1=TT*filt(1,[1 -1])*filt(1,[1 -aa]);%去时延对象*pid分母*F
    p1=impulse(P1,100);
    n=impulse(NN,100);
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
    
    qq=0;%LQG
    %最小方差
    for i=1:1:d+NUM
        qq=qq+gf1(i)^2;
    end
    %LQG
    for i=1:1:NUM
        qq=qq+lmd*gf3(i)^2;
    end
end
