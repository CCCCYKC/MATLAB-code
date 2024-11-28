function H=Gray(j)
%%Gray(1,1)灰色模型
A=[126743 127627 128453 129227 129988 130756 131448 132129 132802 133450 134091 134735 135404 136072 136782 137462 138271 139008 140541 141008 141178 141260 141175 140967];
A=sort(A);
syms a b;
c=[a b]';
B=cumsum(A); % 原始数据累加
n=length(A);
for i=1:(n-1)
C(i)=(B(i)+B(i+1))/2; % 生成累加矩阵
end
%级比检验
lambda = A(1:n-1)./A(2:n); %计算级比
range=minmax(lambda'); %计算级比的范围
lamrange_min=exp(-2/(n+1)); %允许范围的上届
lamrange_max=exp(2/(n+1)); %允许范围的下届
if (range(1)>lamrange_min && range(2)<lamrange_max)
    disp('原始数据通过级比检验')
else
    disp('原始数据未通过级比检验!')
    return
end
% 计算待定参数的值
D=A;D(1)=[];
D=D';
E=[-C;ones(1,n-1)];
c=inv(E*E')*E*D;
c=c';
a=c(1);b=c(2);
% 预测后续数据
F=[];F(1)=A(1);
for i=2:(n+27)
F(i)=(A(1)-b/a)/exp(a*(i-1))+b/a;
end
G=[];G(1)=A(1);
for i=2:(n+27)
  G(i)=F(i)-F(i-1); %得到预测出来的数据  
end
t1=2000:2023;
t2=2023:2050;
t3=2000:2050;

G;a;b;% 输出预测值，发展系数和灰色作用量
scatter(t1,A,'r*');
hold on
plot(t3,G,'b-');
xlabel('年份');ylabel('人口数/万人');
legend('实际人口数量','预测人口数量');
grid on

%灰色预测模型的检验
H = G(1:24);
%计算残差序列
epsilon = A - H;
%法一：相对残差Q检验
%计算相对误差序列
delta = abs(epsilon./A);
%计算相对误差Q
disp('相对残差Q检验：')
Q = mean(delta);
h=G(24:51);
H=j.*h;
end

