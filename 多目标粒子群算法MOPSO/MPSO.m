%% ��ջ���
clc
clear
close all
%% ������Ⱥ����
sizepop = 200;                      % ��ʼ��Ⱥ����
dim = 10;                           % �ռ�ά��
ger = 100;                          % ����������    
x_max=1*ones(1,dim);                % λ������
x_min=zeros(1,dim);                 % λ������
v_max=0.8*x_max;                    % �ٶ�����
v_min=-v_max;                       % �ٶ�����
w_start=0.9;                        % ����Ȩ�س�ʼֵ
w_end=0.4;                          % ����Ȩ�ؽ���ֵ
c_1 = 1.5;                          % ����ѧϰ����
c_2 = 1.5;                          % Ⱥ��ѧϰ���� 
set_num_max=100;                    % pareto�⼯��ģ
%% ��Ⱥ��ʼ��
pop=x_min+rand(sizepop,dim).*(x_max-x_min);     % ��ʼ����Ⱥ
pop_v=v_min+rand(sizepop,dim).*(v_max-v_min);   % ��ʼ����Ⱥ�ٶ�                 
fitness=zeros(sizepop,2);                       % ���и������Ӧ��
% ��ʼ����Ӧ��
for k=1:sizepop
    % ������Ӧ��ֵ,���������Ŀ�꺯������������������������������������������������������������������������������������������������������������������������������������������
    [a,b]=ZDT1(pop(k,:));
    fitness(k,:)=[a,b];
end
% ����pareto�⼯
pareto_set=fitness(1,:);
pareto_pop=pop(1,:);
for k=2:sizepop
    nk=length(pareto_set(:,1));
    kk=1;
    index=0;% �ж��Ƿ����pareto�⼯�еı�־
    while kk<=nk
        % ���pareto�⼯�б���k������֧��ͽ���ɾ��
        if fitness(k,:)<pareto_set(kk,:)
            pareto_set(kk,:)=[];
            pareto_pop(kk,:)=[];
            nk=nk-1;
            kk=kk-1;
        % �������k��pareto�⼯������֧����˳�ѭ��
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
% �����ܼ����뷨����ȫ�����ź͸�������
I = crowd_dist(pareto_set);                     % �����и����ӵ������
% ������һȥ��������pareto�⼯
while length(I)>set_num_max
    pareto_set(I==min(I),:)=[];
    I = crowd_dist(pareto_set);
end
% ��ӵ������ϴ��ǰ20%�������ѡ��ȫ������
if floor(0.2*length(I))<1
    r1=1;
else
    r1=randi([1,floor(0.2*length(I))]);
end
x_zbest=pareto_pop(r1,:);                       % ȫ�����ŵ�λ��
fitness_zbest=pareto_set(r1,:);                 % ��Ⱥ��������Ӧ��
x_gbest=pop;                                    % ���������λ��   
fitness_gbest=fitness;                          % �����������Ӧ��
%% ������pareto�⼯
iter=1;
while iter <= ger
    for k=1:sizepop
        % ������Ӧ����Ȩ��
        X_i_k=1/mean(x_max-x_min)/dim*sum(abs(x_zbest-pop(k,:)));
        w=w_start-(w_start-w_end)*(X_i_k-1)^2;
        % �����ٶȲ����ٶȽ��б߽紦�� 
        pop_v(k,:)= w * pop_v(k,:) + c_1*rand*(x_gbest(k,:)-pop(k,:))+c_2*rand*(x_zbest-pop(k,:));
        for kk=1:dim
            if  pop_v(k,kk) > v_max(kk)
                pop_v(k,kk) = v_max(kk);
            end
            if  pop_v(k,kk) < v_min(kk)
                pop_v(k,kk) = v_min(kk);
            end
        end
        % ����λ�ò���λ�ý��б߽紦��
        pop(k,:)=pop(k,:)+pop_v(k,:);
        for kk=1:dim
            if  pop(k,kk) > x_max(kk)
                pop(k,kk) = x_max(kk);
            end
            if  pop(k,kk) < x_min(kk)
                pop(k,kk) = x_min(kk);
            end
        end
        % ������Ӧ��ֵ,���������Ŀ�꺯������������������������������������������������������������������������������������������������������������������������������������������
        [a,b]=ZDT1(pop(k,:));
        fitness(k,:)=[a,b];
        % ����pareto�⼯
        nk=length(pareto_set(:,1));
        kk=1;
        index=0;% �ж��Ƿ����pareto�⼯�еı�־
        while kk<=nk
            % ���pareto�⼯�б���k������֧��ͽ���ɾ��
            if fitness(k,:)<=pareto_set(kk,:)
                pareto_set(kk,:)=[];
                pareto_pop(kk,:)=[];
                nk=nk-1;
                kk=kk-1;
            % �������k��pareto�⼯������֧����˳�ѭ��
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
        % �����ܼ����뷨����ȫ�����ź͸�������
        I = crowd_dist(pareto_set);  % �����и����ӵ������
        % ������һȥ��������pareto�⼯
        while length(I)>set_num_max
            pareto_set(I==min(I),:)=[];
            I = crowd_dist(pareto_set);
            pareto_pop(I==min(I),:)=[];
        end
        % ��ӵ������ϴ��ǰ20%�������ѡ��ȫ������
        if floor(0.2*length(I))<1
            r1=1;
        else
            r1=randi([1,floor(0.2*length(I))]);
        end
        x_zbest=pareto_pop(r1,:);                       % ȫ�����ŵ�λ��
        fitness_zbest=pareto_set(r1,:);                 % ��Ⱥ��������Ӧ��
        if fitness(k,:)<fitness_gbest(k,:)
            fitness_gbest(k,:)=fitness(k,:);
            x_gbest(k,:)=pop(k,:);
        end
    end
    scatter(pareto_set(:,1),pareto_set(:,2)) 
    pause(0.01)
    iter=iter+1;
end
