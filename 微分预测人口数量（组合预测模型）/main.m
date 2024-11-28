clc
close
clear

x=[0.3405 0.1588 0.0526 0.1931 0.2550]; 
predicted=(Gray(x(4))+multinomial(x(1))+Logistic(x(2))+Malthus(x(3))+BP(x(5)))'
t=2024:2051;
figure(3)
plot(t,predicted,'-o')
grid on
xlabel('年份')
ylabel('中国人口数量/万人')
legend('预测中国人口数量')
title('2024-2050年的中国人口预测结果')


