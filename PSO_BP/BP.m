%����ѵ���������뼯
clc;clear;close all;
rng(0);
feature_num=8;%��Ӧ8������

data=csvread("data.csv",1);
[sample_size,col]=size(data); %sample_size=24;col=9(��9������)

p=0.8;
train_len=floor(sample_size*p);
%����ѵ�������Լ�
x_train=data(1:train_len,1:feature_num)';
% x_train=[data(1:len-2,:).'];
y_train=data(1:train_len,end)';
x_test=data(train_len+1:end,1:feature_num)';
y_test=data(train_len+1:end,end)';


%����BP������
%��������
net=newff(x_train,y_train,[16,1],{'tansig','purelin'},'trainlm');%������Ԫ�������������Ԫ����,��1������Ϊ������������뷶Χ
%����ѵ������
net.trainParam.epochs = 200;
net.trainParam.lr = 0.01;
%�����������
net.trainParam.goal=0.001;
%ѵ������
[net,tr]=train(net,x_train,y_train);
%��ѵ�����Ͳ��Լ��ϵı���
y_train_predict=sim(net,x_train);
Predict=sim(net,x_test);
%��ͼ �ֱ��ڲ��Լ���
x=1:1:length(Predict);
plot(x,Predict,"o-r",x,y_test,"b*-");
set(gca,'Fontname','Monospaced');
grid on
xlabel('ʱ��'),ylabel('�õ���')%����
title("���Լ�����")
legend('Ԥ��ֵ','��ʵֵ');
rmse=(sum((Predict-y_test).^2)/length(y_test))^0.5
mae=sum(abs(Predict-y_test))/length(y_test)
mape=sum(abs(Predict-y_test)./y_test)/length(y_test)*100

