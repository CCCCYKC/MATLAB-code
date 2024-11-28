function B=Logistic(k)
%%Logistic阻滞增长模型
x=[126743 127627 128453 129227 129988 130756 131448 132129 132802 133450 134091 134735 135404 136072 136782 137462 138271 139008 140541 141008 141178 141260 141175 140967];
n=length(x);
t=0:1:n-1;
rk=zeros(1,n);
rk(1)=(-3*x(1)+4*x(2)-x(3))/2;
rk(n)=(x(n-2)-4*x(n-1)+3*x(n))/2;
for i=2:n-1
    rk(i)=(x(i+1)-x(i-1))/2;
end
rk=rk./x;
p=polyfit(x,rk,1);
b=p(2);
a=p(1);
r0=b;
xm=-r0/a;
%输出
pnum=zeros(n,1);
for i=0:1:n-1
    pnum(i+1)=xm/(1+(xm/x(1)-1)*exp(-r0*i));
end
year1=2000:2023;
plot(year1,x,'r*')
%预测
hold on
fnum=zeros(n+27,1);
for i=0:1:n+26
    fnum(i+1)=xm/(1+(xm/x(1)-1)*exp(-r0*i));
end
year2=2000:2050;
plot(year2,fnum,'b')
grid on      %网格线
xlabel('年份')
ylabel('中国人口数量/万人')
legend('中国人口实际数量','中国人口预测数量/万人')

t=2024:2051;
b=(xm./(1+(xm/x(1)-1)*exp(-r0*t)));
B=k.*b;
end
