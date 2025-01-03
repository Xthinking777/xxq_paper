g_1=g_est_1(1:200);
g_2=g_est_2(1:200);
g_00=impulse(G_theo, 200-1)';%理论值
%(10-0)/(1.5282-x)=(20-10)/(1.4154-1.5282)
var_y_est0=1.6410;

%遍历r
r_err=zeros(1,100);
for r_i=1:1:100
    g_0=zeros(1,200);
    for i = 1:200
        g_0(i) = solve_g0(r_i/100, g_1(i), g_2(i));
    end
    var_y_est00=0;
    for i = 1:200
        var_y_est00=var_y_est00+ g_0(i)^2;
    end
    r_err(r_i)=(var_y_est00-var_y_est0)^2;
end
% 找到最小的 r_set(r_i)
[min_value, min_index] = min(r_err);

% 计算对应的 r 值
r_opt = (min_index) / 100;

% 显示最优的 r 值
disp(r_opt);
for i = 1:200
     g_0(i) = solve_g0(r_opt, g_1(i), g_2(i));
end
var_y_est000=0;
for i = 1:200
    var_y_est000=var_y_est000+ g_0(i)^2;
end

% 绘制脉冲响应折线图
figure;
plot(1:200, g_0, 'g-', 'DisplayName', 'g_0'); % 使用绿色实线绘制g_0
hold on;
plot(1:200, g_1, 'b-', 'DisplayName', 'g_1'); % 使用蓝色实线绘制g_1
plot(1:200, g_2, 'r-', 'DisplayName', 'g_2'); % 使用红色实线绘制g_2
plot(1:200, g_00, 'k-', 'DisplayName', 'g_00'); % 使用绿色实线绘制g_0
hold off;

% 添加图例和标题
legend show;
title('Pulse Response of g_0, g_1, and g_2 and g00');
xlabel('Sample Index');
ylabel('Amplitude');

%r=(g2-g1)(g1-g0)/(g2-g0)^2
function g0 = solve_g0(r, g1, g2)
    % 验证输入值是否有效
    if g2 == g1
        error('g2 and g1 must be distinct.');
    end
    
    % 根据给定的 r 值解出 g0
    a = (g2 - g1)^2 / r - 1;
    b = 2 * g1 * (1 - (g2 - g1)^2 / r);
    c = g1^2 - 2 * g1 * g2 * (1 - (g2 - g1)^2 / r) + g2^2;

    % 计算判别式
    discriminant = b^2 - 4 * a * c;
    
    % 检查判别式是否非负
    if discriminant < 0
        error('No real solution for g0 exists.');
    end
    
    % 使用二次公式求解 g0
    g0 = (-b + sqrt(discriminant)) / (2 * a);
end