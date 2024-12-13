% Step 1: 加载数据
z = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 2, 3, 4, 5, 6, 7]'; % λ
y = [1.0259, 0.8754, 0.8005, 0.7448, 0.6992, 0.6645, 0.6351, 0.6096, 0.5866, 0.5671, 0.5496, 0.4350, 0.3707, 0.3263, 0.2941, 0.2702, 0.2470]'; % var(u)
x = [1.5948, 1.5991, 1.6071, 1.6058, 1.6167, 1.6213, 1.6261, 1.6309, 1.6422, 1.6467, 1.6511, 1.7008, 1.7333, 1.7658, 1.8010, 1.8342, 1.8431]'; % var(y)
% 数据处理
z = log(1 + z); % 将z中数据取对数
y = y / 1.0259; % 将y中数据除以1.0259
x = x / 1.8431; % 将x中数据除以1.8431
% Step 2: 拟合三次多项式曲面
ft = fittype('poly33');
[curve, gof] = fit([x, y], z, ft);

% Step 3: 获取拟合系数
coeffs = coeffvalues(curve);
a = coeffs(1);
b = coeffs(2);
c = coeffs(3);
d = coeffs(4);
e = coeffs(5);
f = coeffs(6);
g = coeffs(7);
h = coeffs(8);
i = coeffs(9);
j = coeffs(10);

% 输出拟合后的表达式
fprintf('拟合后的表达式: z = %.4f*x^3 + %.4f*y^3 + %.4f*x^2*y + %.4f*x*y^2 + %.4f*x^2 + %.4f*y^2 + %.4f*x*y + %.4f*x + %.4f*y + %.4f\n', ...
    a, b, c, d, e, f, g, h, i, j);

% Step 4: 绘制三维曲面
figure;
plot3(x, y, z, 'ro'); % 绘制原始数据点
hold on;

% 生成用于绘制曲面的网格点
[xGrid, yGrid] = meshgrid(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100));
zGrid = a*xGrid.^3 + b*yGrid.^3 + c*xGrid.^2.*yGrid + d*xGrid.*yGrid.^2 + e*xGrid.^2 + f*yGrid.^2 + g*xGrid.*yGrid + h*xGrid + i*yGrid + j;

% 绘制拟合曲面
mesh(xGrid, yGrid, zGrid);
grid on;
xlabel('x【y】');
ylabel('y【u】');
zlabel('z【λ】');
title('3D Curve Fit of Given Data');
hold off;



