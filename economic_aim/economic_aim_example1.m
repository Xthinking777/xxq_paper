%经济指标
% 创建样本数据
y = sqrt([2.5435, 2.5572, 2.5655, 2.5785, 2.6138, 2.6287, 2.6442, 2.6599, 2.6968, 2.7115, 2.7260,2.7404, 2.7544, 2.7683, ...
          2.8021, 2.8145, 2.8267, 2.8386, 2.8502, 2.8616, 2.8926, 3.0042, 3.1180, 3.2437, 3.3644, 3.3970]); % x轴上的点集
x = sqrt([1.0524, 0.7663, 0.6408, 0.5548, 0.4889, 0.4416, 0.4033, 0.3716, 0.3441, 0.3216, 0.3021, 0.2848, 0.2695, 0.2558, ...
         0.2434, 0.2323, 0.2223, 0.2130, 0.2045, 0.1966, 0.1892, 0.1374, 0.1065, 0.0865, 0.0730, 0.0610]); % y轴上对应的值
 
% 使用polyfit函数进行拟合
coefficients = polyfit(x, y, 3);
% 输出拟合结果
disp('拟合系数：');
disp(coefficients);

% 生成新的x轴上的点集
new_x = linspace(min(x)*0.9, max(x), 100);
% 根据拟合结果计算对应的y轴上的值
new_y = polyval(coefficients, new_x);
 

%求解优化问题
f=@(x)-x(1)+3*x(2)+0*x(3)+0*x(4);
x0=[0 0 0 0];
    %不等式约束
   A = [1  0 1.96 0;
        -1  0 1.96 0;
         0  1 0    3;
         0 -1 0    3];
    b = [10;
         10;
         2.5;
         2.5];
     %等式约束
    Aeq = [1 -6.0367 0 0;
%            0  0      1 0
%            0  0      0 1
           ];
    beq = [0;
%             1.7996;
%             0.8244
            ];
    VLB = [ -100; -100; 0; 0];
    VUB = [];
 zyj=fmincon(f, x0, A, b, Aeq, beq, VLB, VUB,'fitting_constraint',optimoptions('fmincon', 'Display', 'off'));%最优解 LQG拟合曲线约束
% zyj=fmincon(f, x0, A, b, Aeq, beq, VLB, VUB,'',optimoptions('fmincon', 'Display', 'off'));%最优解 固定方差约束

% 绘制原始数据点及拟合曲线
figure;
plot(x,y,'b<')
%scatter(x, y, 'filled', 'MarkerFaceColor', 'b'); 
hold on;
plot(new_x, new_y, 'r-');
% hold on;
plot(zyj(4), zyj(3), 'k.','MarkerSize', 20);%最优经济参数
legend('原始数据', '拟合曲线','LineWidth',1);
title('LQG权衡曲线');
xlabel('输入标准差','fontsize',15);
ylabel('输出标准差','fontsize',15);
grid on;
fprintf("最优经济效益：");
P=zyj(1)-3*zyj(2);
disp(P);
zyj

