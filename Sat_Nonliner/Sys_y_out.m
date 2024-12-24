function [y] = Sys_y_out(Q, T, N, e_t)
    % 根据当前系统传函，返回实际输出方差，以及Fcor的估计系数

    % 定义系统输入输出接口
    N.u = 'un'; N.y = 'yn';
    T.u = 'ut'; T.y = 'yt';
    Q.u = 'y'; Q.y = 'yq';

    % 创建求和块
    sum1 = sumblk('ut=-yq');
    sum2 = sumblk('y=yn+yt');

    % 连接Q、T、N和求和块形成系统G1
    G1 = connect(Q, T, N, sum1, sum2, 'un', 'y');

    % 仿真参数
    NN = 500000; % 仿真点数
    t = 0:NN-1;
    e1 = e_t;

    % 使用lsim得到在白噪声输入下G1的输出
    y = lsim(G1, e1, t);
end