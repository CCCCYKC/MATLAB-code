%创建训练样本输入集
clc;clear;close all;
rng(0);
feature_num=8;%对应8个特征

data=csvread("data.csv",1);
[sample_size,col]=size(data); %sample_size=24;col=9(有9行数据)

p=0.8;
train_len=floor(sample_size*p);
%建立训练集测试集
x_train=data(1:train_len,1:feature_num)';
% x_train=[data(1:len-2,:).'];
y_train=data(1:train_len,end)';
x_test=data(train_len+1:end,1:feature_num)';
y_test=data(train_len+1:end,end)';


%创建BP神经网络
%创建网络
net=newff(x_train,y_train,[16,1],{'tansig','purelin'},'trainlm');%隐层神经元个数，输出层神经元个数,第1个参数为测试输入的输入范围
%设置训练次数
net.trainParam.epochs = 200;
net.trainParam.lr = 0.01;
%设置收敛误差
net.trainParam.goal=0.001;
%训练网络
[net,tr]=train(net,x_train,y_train);
%在训练集和测试集上的表现
y_train_predict=sim(net,x_train);
Predict=sim(net,x_test);
%作图 分别在测试集上
x=1:1:length(Predict);
plot(x,Predict,"o-r",x,y_test,"b*-");
set(gca,'Fontname','Monospaced');
grid on
xlabel('时间'),ylabel('用电量')%命名
title("测试集表现")
legend('预测值','真实值');
rmse=(sum((Predict-y_test).^2)/length(y_test))^0.5
mae=sum(abs(Predict-y_test))/length(y_test)
mape=sum(abs(Predict-y_test)./y_test)/length(y_test)*100

