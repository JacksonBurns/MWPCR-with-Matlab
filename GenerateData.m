% 生成1100例数据，前660个来自class zero，后440个来自class one.分别取60和40例作为训练集，剩余的是测试集.
function[Dis,Y_train,Y_test,esp_0,esp_iid_train,esp_iid_test,esp_short_train,esp_short_test,esp_long_train,esp_long_test] = GenerateData(std)
N=1100;%总的数据例数
% std=0.1; %设置噪声标准差
postion = [repmat(reshape(repmat(1:20,20,1),1,400),1,10);
    repmat(1:20,1,200);
    reshape(repmat(1:10,400,1),1,4000)];
% 位置的的距离矩阵
Dis = dist(postion);
%% 生成数据集--训练集和测试集
value=repmat(0.8,4000,1);
value_zero=value;
value_zero(ismember(postion(1,:),7:14)|ismember(postion(2,:),7:14),:)=0.2;
value_one=value_zero;
value_one(ismember(postion(1,:),9:12)&ismember(postion(2,:),9:12)&ismember(postion(3,:),5:6),:)=0.5;
% g=normrnd(0,std,[1,3]);
% 生成1100组数据，前660个来自class zero，后440个来自class one.
esp_0=zeros(N,length(value));
esp_iid=zeros(N,length(value));
esp_short=zeros(N,length(value));
esp_long=zeros(N,length(value));
for i=1:N
    noise_iid=normrnd(0,std,[length(value),1]);
    noise_short=noise_iid;
    for j=1:length(value)
        noise_short(j)=EspShort(j,Dis,1,noise_iid);
    end
    noise_long=EspLong(postion,0,std,noise_iid);
    if i<=660 %class zero 
        esp_0(i,:)=value_zero;%不含噪声
        esp_iid(i,:)=value_zero+noise_iid;
        esp_short(i,:)=value_zero+noise_short;
        esp_long(i,:)=value_zero+noise_long;
    else %class one
        esp_0(i,:)=value_one;
        esp_iid(i,:)=value_one+noise_iid;
        esp_short(i,:)=value_one+noise_short;
        esp_long(i,:)=value_one+noise_long;        
    end
end
Y_train=[zeros(60,1);ones(40,1)];
Y_test=[zeros(600,1);ones(400,1)];

% esp_0_train=esp_0([1:60,121:160],:);
% esp_0_test=esp_0([61:120,161:200],:);

esp_iid_train=esp_iid([1:60,661:700],:);
esp_iid_test=esp_iid([61:660,701:1100],:);

esp_short_train=esp_short([1:60,661:700],:);
esp_short_test=esp_short([61:660,701:1100],:);

esp_long_train=esp_long([1:60,661:700],:);
esp_long_test=esp_long([61:660,701:1100],:);

end