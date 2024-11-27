function I = crowd_dist(pareto_set)
%% 求pareto解集中所有个体的拥挤距离
    [N,M]    = size(pareto_set);%N为解的数量，M为目标个数
    I = zeros(1,N);%初始化拥挤距离
    Fmax     = max(pareto_set,[],1);%目标函数最大值
    Fmin     = min(pareto_set,[],1);%目标函数最小值
    for i = 1 : M
        [~,rank1] = sortrows(pareto_set(:,i));
        I(rank1(1))   = inf;
        if length(rank1)>2
            I(rank1(end)) = I(rank1(end))+(pareto_set(rank1(end-1),i)-pareto_set(rank1(end-2),i))/(Fmax(i)-Fmin(i));
        else
            I(rank1(end))=inf;
        end
        for j = 2 : N-1
            I(rank1(j)) = I(rank1(j))+(pareto_set(rank1(j+1),i)-pareto_set(rank1(j-1),i))/(Fmax(i)-Fmin(i));
        end
    end
end
