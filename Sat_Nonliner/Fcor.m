function [y] = Fcor(Q, T, N, y_a)
    % ���ݵ�ǰϵͳ����������ʵ���������Լ�Fcor�Ĺ���ϵ��

    % ���履�ͷ����Ե����½�
    sat_a=0.1;
    sat_upper = sat_a; % �Ͻ�
    sat_lower = -sat_a; % �½�

    % �������ͺ���
    sat_func = @(u) max(min(u, sat_upper), sat_lower);

    % ����ϵͳ��������ӿ�
    N.u = 'un'; N.y = 'yn';
    T.u = 'ut'; T.y = 'yt';
    Q.u = 'y'; Q.y = 'yq';

    % ������Ϳ�
    sum1 = sumblk('ut=-yq');
    sum2 = sumblk('y=yn+yt');

    % �����ͺ���Ӧ����Q�����
    Q_sat = setfield(Q, 'y', [Q.y, 'sat']);

    % ����Q��T��N����Ϳ��γ�ϵͳG1
    G1 = connect(Q_sat, T, N, sum1, sum2, 'un', 'y');

    % �������
    NN = 500000; % �������
    t = 0:NN-1;
    e1 = y_a;

    % ʹ��lsim�õ��ڰ�����������G1�����
    y = lsim(G1, e1, t);
end