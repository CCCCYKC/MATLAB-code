%%相轨线
t0=0; 
tf=10;
[t,y]=ode45('xt',[t0 tf],[100 200]);
plot(y(:,1),y(:,2),'b');
hold on; 
plot(y(1,1),y(1,2),'r+');
xlabel('甲种群x');
ylabel('乙种群y');%作标记
