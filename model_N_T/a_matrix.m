function [ma] = a_matrix(dimension,a)
%A_MATRIX 此处显示有关此函数的摘要
%   此处显示详细说明
ma = [];
for i = 1 : dimension
    for j = 1 :dimension
         m = i-j;
         if m == 0
             ma(i,j) = 1;
         elseif m <= 0
             ma(i,j) = 0;
         else
             ma(i,j) = a(i-j+1);
         end
    end
end
end

