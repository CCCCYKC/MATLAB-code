clc
clear
close all

options=gaoptimset('PopulationSize',200,'Generations',5000,'stallGenLimit',200,'TolFun',1e-10,'plotFcn',@gaplotbestf);
fun=@fitnessfun;      %目标函数，min就直接敲上去，max则乘-1
nonlcon=@nonlconfun;  %非线性约束条件
nvars=3;              %变量数
A=[1,2,0];            %线性不等式的左边矩阵
b=[1]';               %线性不等式的右边
Aeq=[];               %线性等式的左边
beq=[];               %线性等式的右边
lb=[0];               %变量下界
ub=[];                %变量上界
[x_best,fval]=ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,options)