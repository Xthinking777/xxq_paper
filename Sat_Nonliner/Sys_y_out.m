function [y] = Sys_y_out(Q, T, N, e_t)
    % ���ݵ�ǰϵͳ����������ʵ���������Լ�Fcor�Ĺ���ϵ��

    % ����ϵͳ��������ӿ�
    N.u = 'un'; N.y = 'yn';
    T.u = 'ut'; T.y = 'yt';
    Q.u = 'y'; Q.y = 'yq';

    % ������Ϳ�
    sum1 = sumblk('ut=-yq');
    sum2 = sumblk('y=yn+yt');

    % ����Q��T��N����Ϳ��γ�ϵͳG1
    G1 = connect(Q, T, N, sum1, sum2, 'un', 'y');

    % �������
    NN = 500000; % �������
    t = 0:NN-1;
    e1 = e_t;

    % ʹ��lsim�õ��ڰ�����������G1�����
    y = lsim(G1, e1, t);
end