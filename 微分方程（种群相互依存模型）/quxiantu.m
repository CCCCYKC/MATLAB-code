%%种群随时间变化的曲线图
t0=0;
tf=10;
[t,y]=ode15s('xt',[t0 tf],[100 200]);
plot(t,y(:,1),t,y(:,2),'r');%画出x(t),y(t)曲线图
xlabel('t');
ylabel('种群数量');
grid on;
legend('Location', [0.2, 0.8, 0.1, 0.1]);%图例