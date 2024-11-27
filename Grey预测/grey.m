clc
clear
%load('production.mat') %读取数据
%s=data;
%y=s(:,3); %%直接输入原始时间序列
y=[1869
2150
2225
2395
2721
]';
n=length(y); 
yy=ones(n,1); 
yy(1)=y(1); 
for i=2:n  
    yy(i)=yy(i-1)+y(i) 
end
B=ones(n-1,2); 
for i=1:(n-1)  
    B(i,1)=-(yy(i)+yy(i+1))/2; 
    B(i,2)=1; 
end
BT=B';  
for j=1:(n-1) 
    YN(j)=y(j+1); 
end
YN=YN';  
A=inv(BT*B)*BT*YN; 
a=A(1); 
u=A(2); 
t=u/a;  
t_test=4;     %%直接输入预测个数 
i=1:t_test+n;  
yys(i+1)=(y(1)-t).*exp(-a.*i)+t; 
yys(1)=y(1);  
for j=n+t_test:-1:2 
    ys(j)=yys(j)-yys(j-1); 
end
x=1:n;  
xs=2:n+t_test; 
yn=ys(2:n+t_test);  
plot(x,y,'^r',xs,yn,'*-b'); 
det=0; 
for i=2:n  
    det=det+abs(yn(i)-y(i)); 
end
det=det/(n-1);
disp(['百分绝对误差为：',num2str(det),'%']); 
disp(['预测值为：',num2str(ys(n+1:n+t_test))]);