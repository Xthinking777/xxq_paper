function [c, ceq] = fitting_constraint3(x)
    % x 是优化问题的决策变量向量
    
    % 由于这是一个等式约束，不等式约束 c 为空
    c = [];

    % 计算非线性等式约束 ceq
    % 等式约束是 x(3) = -0.1081*x(4)^2 - 0.849*x(4) + 3.6587
    %ceq = x(3) + 0.1081*x(4)^2 + 0.849*x(4) - 3.6587;
    ceq = x(3) +0.0022*x(4)^3- 0.0547*x(4)^2 + 0.4905*x(4) - 12.4742;
    % 由于这是一个等式约束，ceq 应该等于 0
    % 所以我们需要将原始等式转换为 ceq = 0 的形式
end