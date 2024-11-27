%% 清空环境
clc
clear
close all
%% 设置种群参数
sizepop = 200;                      % 初始种群个数
dim = 10;                           % 空间维数
ger = 100;                          % 最大迭代次数    
x_max=1*ones(1,dim);                % 位置上限
x_min=zeros(1,dim);                 % 位置下限
v_max=0.8*x_max;                    % 速度上限
v_min=-v_max;                       % 速度下限
w_start=0.9;                        % 惯性权重初始值
w_end=0.4;                          % 惯性权重结束值
c_1 = 1.5;                          % 自我学习因子
c_2 = 1.5;                          % 群体学习因子 
set_num_max=100;                    % pareto解集规模
%% 种群初始化
pop=x_min+rand(sizepop,dim).*(x_max-x_min);     % 初始化种群
pop_v=v_min+rand(sizepop,dim).*(v_max-v_min);   % 初始化种群速度                 
fitness=zeros(sizepop,2);                       % 所有个体的适应度
% 初始的适应度
for k=1:sizepop
    % 计算适应度值,在这里更换目标函数！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    [a,b]=ZDT1(pop(k,:));
    fitness(k,:)=[a,b];
end
% 更新pareto解集
pareto_set=fitness(1,:);
pareto_pop=pop(1,:);
for k=2:sizepop
    nk=length(pareto_set(:,1));
    kk=1;
    index=0;% 判断是否放入pareto解集中的标志
    while kk<=nk
        % 如果pareto解集中被第k个个体支配就将其删除
        if fitness(k,:)<pareto_set(kk,:)
            pareto_set(kk,:)=[];
            pareto_pop(kk,:)=[];
            nk=nk-1;
            kk=kk-1;
        % 如果个体k被pareto解集中任意支配就退出循环
        elseif fitness(k,:)>pareto_set(kk,:)
            break;
        else
            index=index+1;
        end
        kk=kk+1;
    end
    if index>=length(pareto_set(:,1))
        pareto_set=[pareto_set;fitness(k,:)];
        pareto_pop=[pareto_pop;pop(k,:)];
    end
end
% 采用密集距离法更新全局最优和个体最优
I = crowd_dist(pareto_set);                     % 求所有个体的拥挤距离
% 采用逐一去除法更新pareto解集
while length(I)>set_num_max
    pareto_set(I==min(I),:)=[];
    I = crowd_dist(pareto_set);
end
% 在拥挤距离较大的前20%解中随机选择全局最优
if floor(0.2*length(I))<1
    r1=1;
else
    r1=randi([1,floor(0.2*length(I))]);
end
x_zbest=pareto_pop(r1,:);                       % 全局最优的位置
fitness_zbest=pareto_set(r1,:);                 % 种群的最优适应度
x_gbest=pop;                                    % 个体的最优位置   
fitness_gbest=fitness;                          % 个体的最优适应度
%% 迭代求pareto解集
iter=1;
while iter <= ger
    for k=1:sizepop
        % 求自适应惯性权重
        X_i_k=1/mean(x_max-x_min)/dim*sum(abs(x_zbest-pop(k,:)));
        w=w_start-(w_start-w_end)*(X_i_k-1)^2;
        % 更新速度并对速度进行边界处理 
        pop_v(k,:)= w * pop_v(k,:) + c_1*rand*(x_gbest(k,:)-pop(k,:))+c_2*rand*(x_zbest-pop(k,:));
        for kk=1:dim
            if  pop_v(k,kk) > v_max(kk)
                pop_v(k,kk) = v_max(kk);
            end
            if  pop_v(k,kk) < v_min(kk)
                pop_v(k,kk) = v_min(kk);
            end
        end
        % 更新位置并对位置进行边界处理
        pop(k,:)=pop(k,:)+pop_v(k,:);
        for kk=1:dim
            if  pop(k,kk) > x_max(kk)
                pop(k,kk) = x_max(kk);
            end
            if  pop(k,kk) < x_min(kk)
                pop(k,kk) = x_min(kk);
            end
        end
        % 更新适应度值,在这里更换目标函数！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
        [a,b]=ZDT1(pop(k,:));
        fitness(k,:)=[a,b];
        % 更新pareto解集
        nk=length(pareto_set(:,1));
        kk=1;
        index=0;% 判断是否放入pareto解集中的标志
        while kk<=nk
            % 如果pareto解集中被第k个个体支配就将其删除
            if fitness(k,:)<=pareto_set(kk,:)
                pareto_set(kk,:)=[];
                pareto_pop(kk,:)=[];
                nk=nk-1;
                kk=kk-1;
            % 如果个体k被pareto解集中任意支配就退出循环
            elseif fitness(k,:)>=pareto_set(kk,:)
                break;
            else
                index=index+1;
            end
            kk=kk+1;
        end
        if index>=length(pareto_set(:,1))
            pareto_set=[pareto_set;fitness(k,:)];
            pareto_pop=[pareto_pop;pop(k,:)];
        end
        % 采用密集距离法更新全局最优和个体最优
        I = crowd_dist(pareto_set);  % 求所有个体的拥挤距离
        % 采用逐一去除法更新pareto解集
        while length(I)>set_num_max
            pareto_set(I==min(I),:)=[];
            I = crowd_dist(pareto_set);
            pareto_pop(I==min(I),:)=[];
        end
        % 在拥挤距离较大的前20%解中随机选择全局最优
        if floor(0.2*length(I))<1
            r1=1;
        else
            r1=randi([1,floor(0.2*length(I))]);
        end
        x_zbest=pareto_pop(r1,:);                       % 全局最优的位置
        fitness_zbest=pareto_set(r1,:);                 % 种群的最优适应度
        if fitness(k,:)<fitness_gbest(k,:)
            fitness_gbest(k,:)=fitness(k,:);
            x_gbest(k,:)=pop(k,:);
        end
    end
    scatter(pareto_set(:,1),pareto_set(:,2)) 
    pause(0.01)
    iter=iter+1;
end
