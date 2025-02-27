%% 选择模型
function [LQG_3D]=LQG_FPID(N,T,d)
TT = T * filt(1,[zeros(1, d) 1]);%去时延
NN=N;
NAD=NN;
TAD=TT;
lmd_set=[0 0.1 0.4 1 3 5 50];%λ集合
LQG_3D=zeros(length(lmd_set),7);%lmd var(y) var(u) k1 k2 k3 tau
LQG_3D(:,1)=lmd_set;
for lmd_i=1:1:length(LQG_3D(:,1))
lmd=LQG_3D(lmd_i,1);%LQG参数λ
%%
J=zeros(21,4);%21*4零矩阵  21个τ
xxx=zeros(21,3);%pid的三个参数
%遍历τ
%τ：-1.0 -0.9 -0.8 ...0...0.9 1  --> 1 2 3 ...11... 20 21
aimin=11;%FPID参数τ
aimax=11;
for ai=aimin:1:aimax
aa=-1+(ai-1)*0.1;

dn=3;
NUM=dn*d; %优化长度 每过一个时延 阶数增加一
N0=NAD;
P1=TAD*filt(1,[1 -1])*filt(1,[1 -aa]);
p1=impulse(P1,2000);
p1=p1(1:1000);
n=impulse(N0,1000);
gf1=sym(zeros(1,2000));
%pid三个参数
syms a1 a2 a3
%gf(1)=g(i)输出响应
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
n2=impulse(N0*filt(1,[1 -1])*filt(1,[1 -aa]),1000);%Nu响应 乘了FPID的 F 和 分母部分
gf2=sym(zeros(1,2000));
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
gf3=sym(zeros(1,2000));
gf3(1)=a1*gf2(1);
gf3(2)=a1*gf2(2)+a2*gf2(1);
for i=3:1:2000
    gf3(i)=a1*gf2(i)+a2*gf2(i-1)+a3*gf2(i-2);
end

qq=0;
%最小方差
for i=1:1:d+NUM
    qq=qq+gf1(i)^2;
end
%LQG
for i=1:1:NUM
    qq=qq+lmd*gf3(i)^2;
end

%取出pid参数的系数 重写优化目标函数方便求解
qq=vpa(qq,4);
as=sym(zeros(1,2000));
for i=0:1:2*dn+2
    for j=0:1:2*dn-i+2
        for k=0:1:2*dn-i-j+2
            as(i*100+j*10+k+1)=expr_coeff(qq,a1^i*a2^j*a3^k);
            as(i*100+j*10+k+1)=xs(as(i*100+j*10+k+1),[a1 a2 a3]);
        end
    end
end
%%%%%%只优化到最高阶等于 9-1=8 阶
as=double(as);
f=@(x)as(9)*x(1)^0*x(2)^0*x(3)^8+as(18)*x(1)^0*x(2)^1*x(3)^7+as(27)*x(1)^0*x(2)^2*x(3)^6+as(36)*x(1)^0*x(2)^3*x(3)^5+as(45)*x(1)^0*x(2)^4*x(3)^4+as(54)*x(1)^0*x(2)^5*x(3)^3+as(63)*x(1)^0*x(2)^6*x(3)^2+as(72)*x(1)^0*x(2)^7*x(3)^1+as(81)*x(1)^0*x(2)^8*x(3)^2+...
    as(108)*x(1)^1*x(2)^0*x(3)^7+as(117)*x(1)^1*x(2)^1*x(3)^6+as(126)*x(1)^1*x(2)^2*x(3)^5+as(135)*x(1)^1*x(2)^3*x(3)^4+as(144)*x(1)^1*x(2)^4*x(3)^3+as(153)*x(1)^1*x(2)^5*x(3)^2+as(162)*x(1)^1*x(2)^6*x(3)^1+as(171)*x(1)^1*x(2)^7*x(3)^0+...
    as(207)*x(1)^2*x(2)^0*x(3)^6+as(216)*x(1)^2*x(2)^1*x(3)^5+as(225)*x(1)^2*x(2)^2*x(3)^4+as(234)*x(1)^2*x(2)^3*x(3)^3+as(243)*x(1)^2*x(2)^4*x(3)^2+as(252)*x(1)^2*x(2)^5*x(3)^1+as(261)*x(1)^2*x(2)^6*x(3)^0+...
    as(306)*x(1)^3*x(2)^0*x(3)^5+as(315)*x(1)^3*x(2)^1*x(3)^4+as(324)*x(1)^3*x(2)^2*x(3)^3+as(333)*x(1)^3*x(2)^3*x(3)^2+as(342)*x(1)^3*x(2)^4*x(3)^1+as(351)*x(1)^3*x(2)^5*x(3)^0+...
    as(405)*x(1)^4*x(2)^0*x(3)^4+as(414)*x(1)^4*x(2)^1*x(3)^3+as(423)*x(1)^4*x(2)^2*x(3)^2+as(432)*x(1)^4*x(2)^3*x(3)^1+as(441)*x(1)^4*x(2)^4*x(3)^0+...
    as(504)*x(1)^5*x(2)^0*x(3)^3+as(513)*x(1)^5*x(2)^1*x(3)^2+as(522)*x(1)^5*x(2)^2*x(3)^1+as(531)*x(1)^5*x(2)^3*x(3)^0+...
    as(603)*x(1)^6*x(2)^0*x(3)^2+as(612)*x(1)^6*x(2)^1*x(3)^1+as(621)*x(1)^6*x(2)^2*x(3)^0+...
    as(702)*x(1)^7*x(2)^0*x(3)^1+as(711)*x(1)^7*x(2)^1*x(3)^0+...
    as(801)*x(1)^8*x(2)^0*x(3)^0+...
    as(8)*x(1)^0*x(2)^0*x(3)^7+as(17)*x(1)^0*x(2)^1*x(3)^6+as(26)*x(1)^0*x(2)^2*x(3)^5+as(35)*x(1)^0*x(2)^3*x(3)^4+as(44)*x(1)^0*x(2)^4*x(3)^3+as(53)*x(1)^0*x(2)^5*x(3)^2+as(62)*x(1)^0*x(2)^6*x(3)^1+as(71)*x(1)^0*x(2)^7*x(3)^0+...
    as(107)*x(1)^1*x(2)^0*x(3)^6+as(116)*x(1)^1*x(2)^1*x(3)^5+as(125)*x(1)^1*x(2)^2*x(3)^4+as(134)*x(1)^1*x(2)^3*x(3)^3+as(143)*x(1)^1*x(2)^4*x(3)^2+as(152)*x(1)^1*x(2)^5*x(3)^1+as(161)*x(1)^1*x(2)^6*x(3)^0+...
    as(206)*x(1)^2*x(2)^0*x(3)^5+as(215)*x(1)^2*x(2)^1*x(3)^4+as(224)*x(1)^2*x(2)^2*x(3)^3+as(233)*x(1)^2*x(2)^3*x(3)^2+as(242)*x(1)^2*x(2)^4*x(3)^1+as(251)*x(1)^2*x(2)^5*x(3)^0+...
    as(305)*x(1)^3*x(2)^0*x(3)^4+as(314)*x(1)^3*x(2)^1*x(3)^3+as(323)*x(1)^3*x(2)^2*x(3)^2+as(332)*x(1)^3*x(2)^3*x(3)^1+as(341)*x(1)^3*x(2)^4*x(3)^0+...
    as(404)*x(1)^4*x(2)^0*x(3)^3+as(413)*x(1)^4*x(2)^1*x(3)^2+as(422)*x(1)^4*x(2)^2*x(3)^1+as(431)*x(1)^4*x(2)^3*x(3)^0+...
    as(503)*x(1)^5*x(2)^0*x(3)^2+as(512)*x(1)^5*x(2)^1*x(3)^1+as(521)*x(1)^5*x(2)^2*x(3)^0+...
    as(602)*x(1)^6*x(2)^0*x(3)^1+as(611)*x(1)^6*x(2)^1*x(3)^0+...
    as(701)*x(1)^7*x(2)^0*x(3)^0+...   
    as(7)*x(1)^0*x(2)^0*x(3)^6+as(16)*x(1)^0*x(2)^1*x(3)^5+as(25)*x(1)^0*x(2)^2*x(3)^4+as(34)*x(1)^0*x(2)^3*x(3)^3+as(43)*x(1)^0*x(2)^4*x(3)^2+as(52)*x(1)^0*x(2)^5*x(3)^1+as(61)*x(1)^0*x(2)^6*x(3)^0+...
    as(106)*x(1)^1*x(2)^0*x(3)^5+as(115)*x(1)^1*x(2)^1*x(3)^4+as(124)*x(1)^1*x(2)^2*x(3)^3+as(133)*x(1)^1*x(2)^3*x(3)^2+as(142)*x(1)^1*x(2)^4*x(3)^1+as(151)*x(1)^1*x(2)^5*x(3)^0+...
    as(205)*x(1)^2*x(2)^0*x(3)^4+as(214)*x(1)^2*x(2)^1*x(3)^3+as(223)*x(1)^2*x(2)^2*x(3)^2+as(232)*x(1)^2*x(2)^3*x(3)^1+as(241)*x(1)^2*x(2)^4*x(3)^0+...
    as(304)*x(1)^3*x(2)^0*x(3)^3+as(313)*x(1)^3*x(2)^1*x(3)^2+as(322)*x(1)^3*x(2)^2*x(3)^1+as(331)*x(1)^3*x(2)^3*x(3)^0+...
    as(403)*x(1)^4*x(2)^0*x(3)^2+as(412)*x(1)^4*x(2)^1*x(3)^1+as(421)*x(1)^4*x(2)^2*x(3)^0+...
    as(502)*x(1)^5*x(2)^0*x(3)^1+as(511)*x(1)^5*x(2)^1*x(3)^0+...
    as(601)*x(1)^6*x(2)^0*x(3)^0+...
    as(6)*x(1)^0*x(2)^0*x(3)^5+as(15)*x(1)^0*x(2)^1*x(3)^4+as(24)*x(1)^0*x(2)^2*x(3)^3+as(33)*x(1)^0*x(2)^3*x(3)^2+as(42)*x(1)^0*x(2)^4*x(3)^1+as(51)*x(1)^0*x(2)^5*x(3)^0+...
    as(105)*x(1)^1*x(2)^0*x(3)^4+as(114)*x(1)^1*x(2)^1*x(3)^3+as(123)*x(1)^1*x(2)^2*x(3)^2+as(132)*x(1)^1*x(2)^3*x(3)^1+as(141)*x(1)^1*x(2)^4*x(3)^0+...
    as(204)*x(1)^2*x(2)^0*x(3)^3+as(213)*x(1)^2*x(2)^1*x(3)^2+as(222)*x(1)^2*x(2)^2*x(3)^1+as(231)*x(1)^2*x(2)^3*x(3)^0+...
    as(303)*x(1)^3*x(2)^0*x(3)^2+as(312)*x(1)^3*x(2)^1*x(3)^1+as(321)*x(1)^3*x(2)^2*x(3)^0+...
    as(402)*x(1)^4*x(2)^0*x(3)^1+as(411)*x(1)^4*x(2)^1*x(3)^0+...
    as(501)*x(1)^5*x(2)^0*x(3)^0+...
    as(5)*x(1)^0*x(2)^0*x(3)^4+as(14)*x(1)^0*x(2)^1*x(3)^3+as(23)*x(1)^0*x(2)^2*x(3)^2+as(32)*x(1)^0*x(2)^3*x(3)^1+as(41)*x(1)^0*x(2)^4*x(3)^0+...
    as(104)*x(1)^1*x(2)^0*x(3)^3+as(113)*x(1)^1*x(2)^1*x(3)^2+as(122)*x(1)^1*x(2)^2*x(3)^1+as(131)*x(1)^1*x(2)^3*x(3)^0+...
    as(203)*x(1)^2*x(2)^0*x(3)^2+as(212)*x(1)^2*x(2)^1*x(3)^1+as(221)*x(1)^2*x(2)^2*x(3)^0+...
    as(302)*x(1)^3*x(2)^0*x(3)^1+as(311)*x(1)^3*x(2)^1*x(3)^0+...
    as(401)*x(1)^4*x(2)^0*x(3)^0+...
    as(4)*x(1)^0*x(2)^0*x(3)^3+as(13)*x(1)^0*x(2)^1*x(3)^2+as(22)*x(1)^0*x(2)^2*x(3)^1+as(31)*x(1)^0*x(2)^3*x(3)^0+...
    as(103)*x(1)^1*x(2)^0*x(3)^2+as(112)*x(1)^1*x(2)^1*x(3)^1+as(121)*x(1)^1*x(2)^2*x(3)^0+...
    as(202)*x(1)^2*x(2)^0*x(3)^1+as(211)*x(1)^2*x(2)^1*x(3)^0+...
    as(301)*x(1)^3*x(2)^0*x(3)^0+...
    as(3)*x(1)^0*x(2)^0*x(3)^2+as(12)*x(1)^0*x(2)^1*x(3)^1+as(21)*x(1)^0*x(2)^2*x(3)^0+...
    as(102)*x(1)^1*x(2)^0*x(3)^1+as(111)*x(1)^1*x(2)^1*x(3)^0+...
    as(201)*x(1)^2*x(2)^0*x(3)^0+...
    as(2)*x(1)^0*x(2)^0*x(3)^1+as(11)*x(1)^0*x(2)^1*x(3)^0+...
    as(101)*x(1)^1*x(2)^0*x(3)^0;
    
    x0=[0 0 0];
    A = [-1 -1 -1;0 1 2;0 0 -1];
    b = [-0.0001;-0.0001;-0.0001];
    Aeq = [];
    beq = [];
%     VLB = [0 -1000 0];
%     VUB = [10000 0 10000];
    VLB = [];
    VUB = [];
xxx(ai,:)=fmincon(f, x0, A, b, Aeq, beq, VLB, VUB);
KZQ1=filt(xxx(ai,:),[1 -1-aa aa]);
P=TAD*filt([zeros(1,d) 1],1);
GGG1=NN/(1+TT*filt([zeros(1,d) 1],1)*KZQ1);%G
ggg1=impulse(GGG1,1030);%对应g(i)
GGG2=NN*KZQ1/(1+TT*filt([zeros(1,d) 1],1)*KZQ1);%H
ggg2=impulse(GGG2,1030);%对应h(i)

GGG3=N/(1+T*KZQ1);%去时延的G
ggg3=impulse(GGG3,1030);
for i=1:1:d+1000%lqg
    J(ai,1)=J(ai,1)+ggg1(i)^2+lmd*ggg2(i)^2;
end
for i=1:1:d+NUM   %lqg
    J(ai,2)=J(ai,2)+ggg1(i)^2+lmd*ggg2(i)^2;
end
for i=1:1:d+1000%var(y)
    J(ai,3)=J(ai,3)+ggg1(i)^2;
end
for i=1:1:d+1000%var(u)
     J(ai,4)=J(ai,4)+ggg2(i)^2;
end
% figure(ai)
% plot(ggg3,'r');
end
%%
%%
%找到最优τ
Jmin=100000;
ji=11;
for i=aimin:1:aimax
    if Jmin>J(i,1)
        ji=i;%记录最优τ对应的下标
        Jmin=J(i,1);
    end
end
%%
kcs=xxx(ji,:);
acs=-1+(ji-1)*0.1;
% KZQ1=filt(kcs,[1 -1-acs acs]);
% GGG1=N/(1+T*KZQ1);
% ggg1=impulse(GGG1,100030);


fprintf('lmd lqg    lqg    var(y)    var(u):\n %f %f %f  %f  %f\n',...
        LQG_3D(lmd_i,1),J(ji,1),J(ji,2),sqrt(J(ji,3)),sqrt(J(ji,4)));
fprintf("FPID:\n %f %f %f %f",acs,kcs);
LQG_3D(lmd_i,2)=sqrt(J(ji,3));%var(y)
LQG_3D(lmd_i,3)=sqrt(J(ji,4));%var(u)
LQG_3D(lmd_i,4)=kcs(1);
LQG_3D(lmd_i,5)=kcs(2);
LQG_3D(lmd_i,6)=kcs(3);
LQG_3D(lmd_i,7)=acs;
end

end