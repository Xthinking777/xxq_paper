function [ f_ya ] = Get_f_ya( y , F)%ϵͳ�ջ�������Ӧ������
N=length(y);
m1=armax(y,[20 20]);%A(q) y(t) = C(q) e(t)��������AΪ10�ף�BΪ9�ף�m1ΪABģ���Ұ�������Ϣ
e=resid(m1,y);%������y�Ĳв�
close
e_var=var(e.outputdata);%��в��
e.outputdata=e.outputdata/F(1);%������y�Ĳв�
e_var=var(e.outputdata);%��в��
for r=0:1000
    f_ya(r+1)=y(r+1:end)'*e.outputdata(1:end-r)/(N-r)*e_var;%FCOR�㷨
end
end