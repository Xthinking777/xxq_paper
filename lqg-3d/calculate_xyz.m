% 定义LQG参数方程的系数
% 原始
lqg3d_v2;
coeffs.x = p_x;%λ
coeffs.y = p_y;%var(u)
coeffs.z = p_z;%var(y)
%分段第二段
% lqg3d_v2_div;
% coeffs.x = p_x2;%λ
% coeffs.y = p_y2;%var(u)
% coeffs.z = p_z2;%var(y)
% %归一化
% lqg3d_v2_normal;
% coeffs.x = p_x;%λ
% coeffs.y = p_y;%var(u)
% coeffs.z = p_z;%var(y)


% 调用函数示例
%x_val = log(1+1.7);%给定值                                猜测值t
x_val = 0.8;
[t_val, other_vals] = solve_for_variable(x_val, 1, 11      ,coeffs);
fprintf('Given x(t) = %f, |  t = %f, |y(t) = %f, z(t) = %f\n', x_val, t_val, other_vals.y, other_vals.z);

%y_val = 0.4615/1.0259;
y_val = 0.0484;
[t_val, other_vals] = solve_for_variable(y_val, 2, 10, coeffs);
fprintf('Given y(t) = %f, |  t = %f, |x(t) = %f, z(t) = %f\n', y_val, t_val, other_vals.x, other_vals.z);

%z_val = 1.6848/1.8431;
z_val = 0.1030;
[t_val, other_vals] = solve_for_variable(z_val, 3, 1, coeffs);
fprintf('Given z(t) = %f, |  t = %f, |x(t) = %f, y(t) = %f\n', z_val, t_val, other_vals.x, other_vals.y);

function [t_val, other_vals] = solve_for_variable(target_val, target_func, initial_guess, coeffs)
    % 目标函数定义
    switch target_func
        case 1
            func = @(t) polyval(coeffs.x, t) - target_val;
        case 2
            func = @(t) polyval(coeffs.y, t) - target_val;
        case 3
            func = @(t) polyval(coeffs.z, t) - target_val;
        otherwise
            error('Invalid target function');
    end
    % 使用fzero找到方程的根
    t_val = fzero(func, initial_guess);
    % 计算其他变量的值
    other_vals.x = polyval(coeffs.x, t_val);
    other_vals.y = polyval(coeffs.y, t_val);
    other_vals.z = polyval(coeffs.z, t_val);
end