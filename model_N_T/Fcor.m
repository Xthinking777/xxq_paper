function [y] = Fcor(Q,T,N,y_a)
%���ݵ�ǰϵͳ����������ʵ���������Լ�Fcor�Ĺ���ϵ��

% Q=C2;T=P_real;N=N_real;
N.u='un';N.y='yn';
T.u='ut';T.y='yt';
Q.u='y';Q.y='yq';
sum1=sumblk('ut=-yq');
sum2=sumblk('y=yn+yt');
%sys1=connect(Q,T,Gw,N,sum1,sum2,'ugw','y');
G1=connect(Q,T,N,sum1,sum2,'un','y');

NN = 500000;                 %�������
%L = 50;                    %ȡL��Markovϵ������
t=0:NN-1;
e1=y_a;
y=lsim(G1,e1,t);                  %�õ��ڰ�����������G1�����
% m1=arx(y,10*ones(2));               %�������������1��10�׵�ARģ��
% res=resid(m1,y);                    %������ģ�͵Ĳв������������������Է���
% Cov_res = cov(res);                 %��òв��Э�������
% FF=zeros(2,2,L);
% for r = 0:L-1
%    FF(:,:,r+1)=y(r+1:end,:)'*res(1:end-r,:)*inv(Cov_res)/(NN-r);
% end

end