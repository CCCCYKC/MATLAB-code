clear
clc
close all

%%三次指数平滑时间序列模型
S=xlsread('品类日销售量.xlsx','B731:B1094');%取一年期间的数据
figure
hold on
plot(S,'b-');
alpha=0.5;
beta=0.5;
gamma=0.3;
num=7;%预测个数
k=50;%初始取均值数据个数
n=length(S);
a(1)=sum(S(1:k))/k;
b(1)=(sum(S(k+1:2*k))-sum(S(1:k)))/k;
s=S(1)-a(1);
y=a(1)+b(1)+s(1);
for i=1:n+num-1
    if i==length(S)
        S(i+1)=a(end)+b(end)+s(end-k+1);
    end
    a(i+1)=alpha*(S(i)-s(i))+(1-alpha)*(a(i)+b(i));%水平
    b(i+1)=beta*(a(i+1)-a(i))+(1-beta)*b(i);%趋势
    s(i+1)=gamma*(S(i)-a(i)-b(i))+(1-gamma)*s(i);%周期
    y(i+1)=a(i+1)+b(i+1)+s(i+1);
end
plot(n:n+num,S(end-num:end),'r-','linewidth',1);
legend('历史走势','未来走势')
xlim([0,37])
for i=n+1:n+num
    S(i)
end