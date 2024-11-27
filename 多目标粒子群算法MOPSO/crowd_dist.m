function I = crowd_dist(pareto_set)
%% ��pareto�⼯�����и����ӵ������
    [N,M]    = size(pareto_set);%NΪ���������MΪĿ�����
    I = zeros(1,N);%��ʼ��ӵ������
    Fmax     = max(pareto_set,[],1);%Ŀ�꺯�����ֵ
    Fmin     = min(pareto_set,[],1);%Ŀ�꺯����Сֵ
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
