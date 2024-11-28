b=[1.300 1.225 1.149
    1.103 1.290 1.260
    1.216 1.216 1.419
    0.954 0.728 0.922
    0.929 1.144 1.169
    1.056 1.107 0.965
    1.038 1.321 1.133
    1.089 1.305 1.732
    1.090 1.195 1.021
    1.083 1.390 1.131
    1.035 0.928 1.006
    1.176 1.715 1.908];%各股票的年收益率
[~,m]=size(b);
c=0.01*ones(size(b));
C=[0.01,0.01,0.01]';%股票单位交易额的交易费用向量
I=[1,1,1]';
r=b-c;%收益率
B=cumsum(r);
R=zeros(1,m);
R=B(12,:)./12;%股票期望收益率向量
disp('协方差矩阵')
O=cov(b)%协方差矩阵
lamdba=0:0.01:1;
n=length(lamdba);
x0=zeros(3,1);
X=zeros(3,n);
H=0.5*O;
a=-0.5*R;
fval=zeros(3,1);
Aeq=ones(1,3);
beq=1;
Lb=zeros(3,1);
%lamdba=0.5
[X,fval]=quadprog(H,a,[],[],Aeq,beq,Lb,[],x0)
%lamdba不确定时
for i=1:n
    H=lamdba(i)*Q;
    a=-(1-lamdba(i))*R;
    [X(:,i),fval(i)]=quadprog(H,a,[],[],Aeq,beq,Lb,[],x0);
end
plot(lamdba,fval)












