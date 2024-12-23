function [y] = Fcor(Q,T,N,y_a)
%根据当前系统传函，返回实际输出方差，以及Fcor的估计系数

% Q=C2;T=P_real;N=N_real;
N.u='un';N.y='yn';
T.u='ut';T.y='yt';
Q.u='y';Q.y='yq';
sum1=sumblk('ut=-yq');
sum2=sumblk('y=yn+yt');
%sys1=connect(Q,T,Gw,N,sum1,sum2,'ugw','y');
G1=connect(Q,T,N,sum1,sum2,'un','y');

NN = 500000;                 %仿真点数
%L = 50;                    %取L个Markov系数矩阵
t=0:NN-1;
e1=y_a;
y=lsim(G1,e1,t);                  %得到在白噪声输入下G1的输出
% m1=arx(y,10*ones(2));               %根据输出，建立1个10阶的AR模型
% res=resid(m1,y);                    %用上面模型的残差来代替白噪声做相关性分析
% Cov_res = cov(res);                 %求得残差的协方差矩阵
% FF=zeros(2,2,L);
% for r = 0:L-1
%    FF(:,:,r+1)=y(r+1:end,:)'*res(1:end-r,:)*inv(Cov_res)/(NN-r);
% end

end