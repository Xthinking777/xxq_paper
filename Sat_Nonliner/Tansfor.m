function [eT]=Tansfor(est_T,d)
class=12;%阶数
lemma=100;%
est_Td=est_T(d+1:end);
fin=[];
for i=1:class
tempfin=est_Td(i+1:i+lemma);
fin=[fin tempfin];
end
fin2=-est_Td(class+2:class+lemma+1);
fin1=est_Td(1:class+1);
A=pinv(fin'*fin)*fin'*fin2;
theta=toeplitz([1;flipud(A)]);
theta=tril(theta);
B=theta*fin1;
eT=filt(B',[1 flipud(A)'],'iodelay',d);
end