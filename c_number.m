function [result] = c_number(P)
%C_NUMBER 此处显示有关此函数的摘要
%   此处显示详细说明
N = 0;
for k = 1:4
    temp = ~P(2*k-1) - ~P(2*k-1)*~P(2*k)*~P(2*k+1);
    N = N + temp;
end
result = N;
end

