%����Ⱥ�Ż�����������BP���������
clear;
clc;
close all;
rng(0);
tic
global SamIn SamOut HiddenUnitNum InDim OutDim TrainSamNum
%% ����ѵ������
% data = xlsread('data.xlsx');
% load Data.mat
data=csvread("data.csv",1);
[data_m,data_n] = size(data);%��ȡ����ά��

P = 80;  %�ٷ�֮P����������ѵ�����������
Ind = floor(P * data_m / 100);
feature_num=8;%��Ӧ8������
train_data = data(1:Ind,1:feature_num)';
train_result = data(1:Ind,end)';
test_data = data(Ind+1:end,1:feature_num)';% ����ѵ���õ��������Ԥ��
test_result = data(Ind+1:end,end)';

%% ��ʼ������
[InDim,TrainSamNum] = size(train_data);% ѧϰ��������
[OutDim,TrainSamNum] = size(train_result);
HiddenUnitNum = 16;                     % ��������Ԫ����

[SamIn,PS_i] = mapminmax(train_data,0,1);    % ԭʼ�����ԣ�������������ʼ��
[SamOut,PS_o] = mapminmax(train_result,0,1);

W1 = HiddenUnitNum*InDim;      % ��ʼ���������������֮���Ȩֵ
B1 = HiddenUnitNum;            % ��ʼ���������������֮�����ֵ
W2 = OutDim*HiddenUnitNum;     % ��ʼ���������������֮���Ȩֵ
B2 = OutDim;                   % ��ʼ���������������֮�����ֵ
L = W1+B1+W2+B2;               % ����ά��

%% *********��ʼ��**********
M=100;  %��Ⱥ��ģ
%��ʼ������λ��
X=rand(M,L);
c1=2;  %ѧϰ����
c2=2;
wmax=0.9;%�����С����Ȩ��
wmin=0.5;
Tmax=200;%��������
v=zeros(M,L);%��ʼ���ٶ�
%*******ȫ����������λ�ó�ʼ��
fmin=inf;
for i=1:M
    fx = f(X(i,:));
    if fx<fmin
        fmin=fx;
        gb=X(i,:);
    end
end
%********���Ӹ�����ʷ����λ�ó�ʼ��
pb=X; 
%********�㷨����
for t=1:Tmax
    w(t)=wmax-(wmax-wmin)*t/Tmax;  %�����½�����Ȩ��
    for i=1:M
       %******���������ٶ�
       v(i,:)=w(t)*v(i,:)+c1*rand(1)*(pb(i,:)-X(i,:))+c2*rand(1)*(gb-X(i,:));
       if sum(abs(v(i,:)))>1e3
           v(i,:)=rand(size(v(i,:)));
       end
       %*******��������λ��
       X(i,:)=X(i,:)+v(i,:);
    end
    %����pbest��gbest
    for i=1:M
        if f(X(i,:))<f(pb(i,:))
            pb(i,:)=X(i,:);
        end
        if f(X(i,:))<f(gb)
            gb=X(i,:);
        end
    end
    %���������Ӧ��
    re(t)=f(gb);
    fprintf('��%d��ѵ�������Ϊ%f����ʱ%fs\n\n',t,f(gb),toc);
    %���ӻ���������
    subplot(221)
    plot(gb)
    set(gca,'Fontname','Monospaced');
    title('Ȩ��ֵ��������')
    hold on
    subplot(222)
    mesh(v)
    set(gca,'Fontname','Monospaced');
    title('�����ٶȱ仯')
    pause(0.000000001)
    subplot(2,2,[3,4])
    plot(re,'r')
    set(gca,'Fontname','Monospaced');
    title('�ۼ�����������')
    %74-86�����ӳ�������ʱ�䣬ע�͵��ɼӿ��������
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
HiddenOut = logsig(W1 * SamIn + repmat(B1, 1, TrainSamNum));   % �������������
NetworkOut = W2 * HiddenOut + repmat(B2, 1, TrainSamNum);      % ������������
Error = SamOut - NetworkOut;       % ʵ��������������֮��
Forcast_data = mapminmax('reverse',NetworkOut,PS_o);
[OutDim,ForcastSamNum] = size(test_result);
SamIn_test= mapminmax('apply',test_data,PS_i); % ԭʼ�����ԣ�������������ʼ��
HiddenOut_test = logsig(W1 * SamIn_test + repmat(B1, 1, ForcastSamNum));  % ���������Ԥ����
NetworkOut = W2 * HiddenOut_test + repmat(B2, 1, ForcastSamNum);          % ��������Ԥ����
Forcast_data_test = mapminmax('reverse',NetworkOut,PS_o);


rmse=(sum((Forcast_data_test-test_result).^2)/length(test_result))^0.5
mae=sum(abs(Forcast_data_test-test_result))/length(test_result)
mape=sum(abs(Forcast_data_test-test_result)./test_result)/length(test_result)*100
x=1:1:length(Forcast_data_test);
figure
grid on
xlabel('ʱ��'),ylabel('�õ���')%����
title("���Լ�����")
legend('Ԥ��ֵ','��ʵֵ');

toc
plot(x,Forcast_data_test,"o-r",x,test_result,"b*-");
set(gca,'Fontname','Monospaced');