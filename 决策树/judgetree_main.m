clc
clear
close all

%% 准备训练数据
data = xlsread("Q2_1数据.xlsx",4,"E2:R35");
X = data(:, 1:13); % 输入特征
Y = data(:, 14);   % 类别
 
%% 构建决策树模型
tree = fitctree(X, Y);

%% 预测新样本
new_data = xlsread("Q2_1数据.xlsx",4,"E36:Q43");
prediction = predict(tree, new_data);
prediction  %输出预测结果

%% 可视化决策树
view(tree, 'Mode', 'graph');