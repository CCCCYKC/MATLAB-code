%粒子群优化多输入多输出BP神经网络代码
clear;
clc;
close all;
rng(0);
tic
global SamIn SamOut HiddenUnitNum InDim OutDim TrainSamNum
%% 导入训练数据
% data = xlsread('data.xlsx');
% load Data.mat
data=csvread("data.csv",1);
[data_m,data_n] = size(data);%获取数据维度

P = 80;  %百分之P的数据用于训练，其余测试
Ind = floor(P * data_m / 100);
feature_num=8;%对应8个特征
train_data = data(1:Ind,1:feature_num)';
train_result = data(1:Ind,end)';
test_data = data(Ind+1:end,1:feature_num)';% 利用训练好的网络进行预测
test_result = data(Ind+1:end,end)';

%% 初始化参数
[InDim,TrainSamNum] = size(train_data);% 学习样本数量
[OutDim,TrainSamNum] = size(train_result);
HiddenUnitNum = 16;                     % 隐含层神经元个数

[SamIn,PS_i] = mapminmax(train_data,0,1);    % 原始样本对（输入和输出）初始化
[SamOut,PS_o] = mapminmax(train_result,0,1);

W1 = HiddenUnitNum*InDim;      % 初始化输入层与隐含层之间的权值
B1 = HiddenUnitNum;            % 初始化输入层与隐含层之间的阈值
W2 = OutDim*HiddenUnitNum;     % 初始化输出层与隐含层之间的权值
B2 = OutDim;                   % 初始化输出层与隐含层之间的阈值
L = W1+B1+W2+B2;               % 粒子维度

%% *********初始化**********
M=100;  %种群规模
%初始化粒子位置
X=rand(M,L);
c1=2;  %学习因子
c2=2;
wmax=0.9;%最大最小惯性权重
wmin=0.5;
Tmax=200;%迭代次数
v=zeros(M,L);%初始化速度
%*******全局最优粒子位置初始化
fmin=inf;
for i=1:M
    fx = f(X(i,:));
    if fx<fmin
        fmin=fx;
        gb=X(i,:);
    end
end
%********粒子个体历史最优位置初始化
pb=X; 
%********算法迭代
for t=1:Tmax
    w(t)=wmax-(wmax-wmin)*t/Tmax;  %线性下降惯性权重
    for i=1:M
       %******更新粒子速度
       v(i,:)=w(t)*v(i,:)+c1*rand(1)*(pb(i,:)-X(i,:))+c2*rand(1)*(gb-X(i,:));
       if sum(abs(v(i,:)))>1e3
           v(i,:)=rand(size(v(i,:)));
       end
       %*******更新粒子位置
       X(i,:)=X(i,:)+v(i,:);
    end
    %更新pbest和gbest
    for i=1:M
        if f(X(i,:))<f(pb(i,:))
            pb(i,:)=X(i,:);
        end
        if f(X(i,:))<f(gb)
            gb=X(i,:);
        end
    end
    %保存最佳适应度
    re(t)=f(gb);
    fprintf('经%d次训练，误差为%f，用时%fs\n\n',t,f(gb),toc);
    %可视化迭代过程
    subplot(221)
    plot(gb)
    set(gca,'Fontname','Monospaced');
    title('权阈值更新曲线')
    hold on
    subplot(222)
    mesh(v)
    set(gca,'Fontname','Monospaced');
    title('粒子速度变化')
    pause(0.000000001)
    subplot(2,2,[3,4])
    plot(re,'r')
    set(gca,'Fontname','Monospaced');
    title('累计误差迭代曲线')
    %74-86会增加程序运行时间，注释掉可加快程序运行
end
x = gb;
W1 = x(1:HiddenUnitNum*InDim);
L1 = length(W1);
W1 = reshape(W1,[HiddenUnitNum, InDim]);
B1 = x(L1+1:L1+HiddenUnitNum)';
L2 = L1 + length(B1);
W2 = x(L2+1:L2+OutDim*HiddenUnitNum);
L3 = L2 + length(W2);
W2 = reshape(W2,[OutDim, HiddenUnitNum]);
B2 = x(L3+1:L3+OutDim)';
HiddenOut = logsig(W1 * SamIn + repmat(B1, 1, TrainSamNum));   % 隐含层网络输出
NetworkOut = W2 * HiddenOut + repmat(B2, 1, TrainSamNum);      % 输出层网络输出
Error = SamOut - NetworkOut;       % 实际输出与网络输出之差
Forcast_data = mapminmax('reverse',NetworkOut,PS_o);
[OutDim,ForcastSamNum] = size(test_result);
SamIn_test= mapminmax('apply',test_data,PS_i); % 原始样本对（输入和输出）初始化
HiddenOut_test = logsig(W1 * SamIn_test + repmat(B1, 1, ForcastSamNum));  % 隐含层输出预测结果
NetworkOut = W2 * HiddenOut_test + repmat(B2, 1, ForcastSamNum);          % 输出层输出预测结果
Forcast_data_test = mapminmax('reverse',NetworkOut,PS_o);


rmse=(sum((Forcast_data_test-test_result).^2)/length(test_result))^0.5
mae=sum(abs(Forcast_data_test-test_result))/length(test_result)
mape=sum(abs(Forcast_data_test-test_result)./test_result)/length(test_result)*100
x=1:1:length(Forcast_data_test);
figure
grid on
xlabel('时间'),ylabel('用电量')%命名
title("测试集表现")
legend('预测值','真实值');

toc
plot(x,Forcast_data_test,"o-r",x,test_result,"b*-");
set(gca,'Fontname','Monospaced');