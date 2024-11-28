function A=multinomial(x)
%%多项式拟合预测
n=3;%拟合多项式的次数
year=2000:2023;
num=[126743 127627 128453 129227 129988 130756 131448 132129 132802 133450 134091 134735 135404 136072 136782 137462 138271 139008 140541 141008 141178 141260 141175 140967];
p3= polyfit(year,num,n);       
%绘制原始数据和拟合曲线图
hold on;
xlabel('年份')
ylabel('中国人口数量/万人')
grid on      %网格线
plot(year,num,'r*') 
%预测
hold on
year1=2000:2050;
plot(year1,polyval(p3,year1),'b') 
legend('中国人口实际数量','中国人口预测数量/万人')
disp('未来2024-2050年的人口预测结果:');
year2=2024:2051;
a=polyval(p3,year2);
A=x.*a;
end