cd E:\mypackages\MWPCR-with-Matlab
%% 生成数据
% clear;
%需要设置噪声标准差std=0.1
% [Dis,Y_train,Y_test,esp_0,esp_iid_train,esp_iid_test,esp_short_train,esp_short_test,esp_long_train,esp_long_test] = GenerateData(0.1); %生成数据
% postion = [repmat(1:20,1,200);
%     repmat(reshape(repmat(1:20,20,1),1,400),1,10);
%     reshape(repmat(1:10,400,1),1,4000)];
% 位置的的距离矩阵
% Dis = dist(postion);
%% example 
% choose data set
clc;
data_train=esp_long_train;
data_test=esp_long_test;
%% 训练集训练模型
% compute Wi(importace score weights matrix)
fprintf('------Start Training Model -----%s----------\n',datestr(now()));
W=zeros(size(data_train,2),1);
for i=1:size(data_train,2)
    W(i)=WI(data_train(:,i),Y_train);
end
if ismember(0,W)
    fprintf('--------!!!进行了超界处理!!!-----%s----------\n',datestr(now()));
    W(W==0)=exp(-745); % 超界处理
end
Wi = -4000*log(W)/(-sum(log(W)));
% compute We(spatial weights matrix)
fprintf('--------Start Computing Spatial Weights Matrix-----%s----------\n',datestr(now()));
ch=1.2;
Cn = log(100) * chi2inv(0.95,2);
Kloc=true;
Kst=true;
S0=3;
S=5;
X=Y_train;
warm=WARM(data_train,ch,Cn,Kloc,Kst,S0,S,Dis,X);
We=zeros(size(data_train,2),size(data_train,2));
for index=1:size(data_train,2)
    We(:,index)=WE(index,warm,Dis,ch^S);
end
fprintf('--------Finish Computing Spatial Weights Matrix -----%s----------\n',datestr(now()));
% 创建多尺度阈值集
criter=[quantile(Wi,3);quantile(reshape(We(We~=0),[],1),3);ch.^quantile(1:S,3)];%三尺度
Qmatrix=createQ(We,Wi,Dis,criter);
% 减去均值
data_norm=data_train-ones(size(data_train,1),1)*mean(data_train);
% 数据加权
data_weig=zeros(size(data_train,1),size(data_train,2),size(criter,2));
for index=1:size(criter,2)
    data_weig(:,:,index)=data_norm*Qmatrix(:,:,index);
end
% svd分解
K=5; %奇异值个数
SVD=cell(size(criter,2),3);
for index=1:size(criter,2)
    [SVD{index,1},SVD{index,2},SVD{index,3}]=svds(data_weig(:,:,index),K);
    SVD{index,2}=svd(data_weig(:,:,index));
end
% plot(SVD{1,2})
% hold on;
% plot(SVD{2,2})
% plot(SVD{3,2})
% hold off;
U_train=zeros(size(data_train,1),size(criter,2)*K);
for index=1:size(criter,2)
   U_train(:,K*index-K+1:index*K)=SVD{index,1};
end
% 拟合多元线性回归
[beta,~,res,~,stats]=regress(Y_train,[ones(100,1),U_train]);
% glmfit(U_train,Y_train,'binomial','logit')
figure(1)
plot(Y_train,'.')
hold on;
plot([ones(size(data_train,1),1),U_train]*beta,'.')
plot(repmat(0.5,size(data_train,1),1),'-.');
% grid on;
hold off;
fprintf('------Finish Training Model -----%s----------\n',datestr(now()));
%% 测试集测试模型
% 减去均值
fprintf('------Start Testing Model -----%s----------\n',datestr(now()));
data_norm_test=data_test-ones(size(data_test,1),1)*mean(data_test);
% 计算U_test
U_test=zeros(size(data_test,1),size(criter,2)*K);
for index=1:size(criter,2)
    U_test(:,K*index-K+1:index*K)=data_norm_test*Qmatrix(:,:,index)*SVD{index,3}/diag(SVD{index,2}(1:K));
end
figure(2)
plot(Y_test,'.')
hold on;
plot([ones(size(data_test,1),1),U_test]*beta,'.')
plot(repmat(0.5,size(data_test,1),1),'-.');
grid on;
hold off;
% roc曲线
figure(3)
plotroc((Y_test)',([ones(size(data_test,1),1),U_test]*beta)');
fprintf('------Finish Testing Model -----%s----------\n',datestr(now()));