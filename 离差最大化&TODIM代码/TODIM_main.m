clc
clear
close all

%% 定义决策矩阵
A =[21584,76.7,7.3,1.01,78.3,97.5,2;
   24372,86.3,7.4,0.8,91.1,98,2;
   22041,81.8,7.3,0.62,91.1,97.3,3.2;
   21115,84.5,6.9,0.6,90.2,97.7	2.9;
   24633,90.3,6.9,0.25,95.5,97.9,3.6;];

%% 标准化决策矩阵
[n, m] = size(A);
for j = 1:m
    minVal = min(A(:, j));
    maxVal = max(A(:, j));
    A(:, j) = (A(:, j) - minVal) / (maxVal - minVal);
end

%% 计算属性权重（基于离差最大化）
weightMaxDiff = max(A) - min(A);
w = weightMaxDiff / sum(weightMaxDiff);
% %废稿
% % for i=1:n
% %     for j=1:m
% %         attributeWeights=(max(A)-A(i,j))/weightMaxDiff;
% %     end
% % end
% % S=zeros(n,1);
% % for i=1:n
% %     S=(1/n).*attributeWeights(i,:);
% % end
% % w=zeros(n,1);
% % w=S./sum(S);%权重

%%TODIM
sita=1; %设置衰减参数

%%计算相对优势
Dom=[];
for j=1:m
    for i=1:n
        for r=1:n
            if A(i,j)>A(r,j)
                Dom(i+(j-1)*n,r)=sqrt(w(j)*((A(i,j)-A(r,j)))./sum(w));
            end
            if A(i,j)==A(r,j)
                Dom(i+(j-1)*n,r)=0;
            end
            if A(i,j)<A(r,j)
                Dom(i+(j-1)*n,r)=-(1/sita)*sqrt(sum(w)*(A(r,j)-A(i,j))./w(j));
            end
        end
    end
end

%%建立综合优势矩阵
all_Dom=zeros(n,n);
for i=1:n:m*n
    Dom_token=Dom([i:i+n-1],:);
    all_Dom=all_Dom+Dom_token;
end

%%得到全局优势度
Global_Dom=[];
for i=1:n
    Global_Dom(end+1)=sum(all_Dom(i,:));
end
Global_val=[];
for i=1:n
    Global_val(i)=(Global_Dom(i)-min(Global_Dom))/(max(Global_Dom)-min(Global_Dom));
end

%%排序输出
[sorted,rank] = sort(Global_val ,'descend');
disp('最后的得分为：')
disp(Global_val);
disp('按得分从高到底排列方案 分别为:  ');
disp(rank');%方案排名








