function [y] = Fcor(Q, T, N, y_a)
    % 根据当前系统传函，返回实际输出方差，以及Fcor的估计系数

    % 定义饱和非线性的上下界
    sat_a=0.1;
    sat_upper = sat_a; % 上界
    sat_lower = -sat_a; % 下界

    % 创建饱和函数
    sat_func = @(u) max(min(u, sat_upper), sat_lower);

    % 定义系统输入输出接口
    N.u = 'un'; N.y = 'yn';
    T.u = 'ut'; T.y = 'yt';
    Q.u = 'y'; Q.y = 'yq';

    % 创建求和块
    sum1 = sumblk('ut=-yq');
    sum2 = sumblk('y=yn+yt');

    % 将饱和函数应用于Q的输出
    Q_sat = setfield(Q, 'y', [Q.y, 'sat']);

    % 连接Q、T、N和求和块形成系统G1
    G1 = connect(Q_sat, T, N, sum1, sum2, 'un', 'y');

    % 仿真参数
    NN = 500000; % 仿真点数
    t = 0:NN-1;
    e1 = y_a;

    % 使用lsim得到在白噪声输入下G1的输出
    y = lsim(G1, e1, t);
end