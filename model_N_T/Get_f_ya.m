function [ f_ya ] = Get_f_ya( y , F)%系统闭环脉冲响应求解程序
N=length(y);
m1=armax(y,[20 20]);%A(q) y(t) = C(q) e(t)，其中设A为10阶；B为9阶；m1为AB模型且包含其信息
e=resid(m1,y);%求序列y的残差
close
e_var=var(e.outputdata);%求残差方差
e.outputdata=e.outputdata/F(1);%求序列y的残差
e_var=var(e.outputdata);%求残差方差
for r=0:1000
    f_ya(r+1)=y(r+1:end)'*e.outputdata(1:end-r)/(N-r)*e_var;%FCOR算法
end
end