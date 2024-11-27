clc
clear
close all

A=[1 1/7 1/4 1/3;7 1 6 6;4 1/6 1 1/2;3 1/6 2 1];
[n,n]=size(A);
D=eig(A);
s=max(D)
CI=(s-n)/(n-1)
if n==5
    RI=1.12
elseif n==4
    RI=0.89
end
CR=CI/RI
SO=sum(A,1);
for j=1:n
    X(:,j)=A(:,j)./SO(j);
end
w=sum(X,2);
w=w/n

