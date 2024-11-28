function E=BP(x)
%%BP神经网络模型
% 原始数据
X = 2000:2023; % 年份
Y = [126743 127627 128453 129227 129988 130756 131448 132129 132802 133450 134091 134735 135404 136072 136782 137462 138271 139008 140541 141008 141178 141260 141175 140967]; 
%建立神经网络
net=newff(minmax(Y),[5,1],{'tansig','purelin'});
net.trainFcn='trainbr';
%设置训练参数
net.trainParam.show=50;
net.trainParam.lr=0.05;
net.trainParam.epochs=500;%迭代500次
net.trainParam.goal=1e-5;
%训练
net = train(net, X, Y);
% 使用模型进行预测
future_years = 2000:2050;
predicted_population = net(future_years);
t=2024:2051;
predicted=net(t);
% 绘制原始数据和预测结果
plot(X, Y, 'r*', future_years, predicted_population, 'b-');
grid on
xlabel('年份')
ylabel('中国人口数量/万人')
legend('中国人口实际数量','中国人口预测数量/万人')
% 显示预测结果

e=predicted;
E=x.*e;
end