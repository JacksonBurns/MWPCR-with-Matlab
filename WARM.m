%通过WARM计算相似矩阵，
%input data：图像数据集n*p ch：距离窗宽基数 Cn：相似窗宽 Kloc：是否使用距离核 Kst：是否使用相似核S0：停止检测开始迭代次数 S：迭代总次数 Dis：距离矩阵 X：自变量
%output 相似矩阵WW 每i列表示第i个像素与其他像素的相似度量
function[WW]=WARM(data,ch,Cn,Kloc,Kst,S0,S,Dis,X)
    fprintf('----------Initializing-----%s----------\n',datestr(now()));
    fprintf('----------Initializing Beta-----%s----------\n',datestr(now()));
    Init=cell(size(data,2),3);
    for i=1:size(Dis,2)
        Init(i,:)=OLS_loc(i,data,Dis,ch^0,X);
    end
    Init0=Init;
    W_loc = ones(size(data,2),size(data,2));
    W_st = ones(size(data,2),size(data,2));
    fprintf('----------Iteration Begin -----%s----------\n',datestr(now()));
    dict1=false(size(data,2),1);%标记所有停止的编号
    for i=1:S
        fprintf('----------开始地第%d次迭代 ----------\n',i);
        fprintf('------------Update WW -----%s----------\n',datestr(now()));
        if Kloc
            W_loc=(1-Dis/ch^i).*((1-Dis/ch^i)>=0);
            WW=W_loc.*W_st;
        end
        if Kst
%             fprintf('------------Update Similar Matrix -----%s----------\n',datestr(now()));
%             Sim=Smatrix(Init);
%             W_st=exp(-Sim/Cn); % Cn = log(100) * chi2inv(0.95,2)
        WW=Weight(Init,W_loc,Cn);
        end
%         WW=W_loc.*W_st;

        if i<S
            fprintf('------------Update A -----%s----------\n',datestr(now()));
            A=cell(size(data,2),1);
            for index=1:size(data,2)
                A{index,:}=CompA(index,ch^i,WW,Dis,Init,X);
            end
            fprintf('------------Update Beta -----%s----------\n',datestr(now()));
            beta=cell(size(data,2),1);
            for index=1:size(data,2)
               beta{index,:}=updatebeta(index,ch^i,WW,Dis,data,X,Init,A);
            end
            beta(dict1,:)=Init0(dict1,1);%停止的不进行迭代
            if i>S0
%                停止准则 
                D=stopctiter(Init,Init3);
                dict0=D>chi2inv(0.8,2);
                dict=(~dict1)&dict0;%标记新需要停止的标号
                dict1=dict1|dict0;%标记所有停止的编号
                beta(dict,:)=Init0(dict,1);%停止                  
            end
            Init(:,1)=beta;
            fprintf('------------Update Cov -----%s----------\n',datestr(now()));
            espn=zeros(size(data,2),size(data,1));%4000by100
            for index=1:size(data,2)
                espn(index,:)=epsn(index,WW,Dis,ch^i,Init,data,X);
            end
            for index=1:size(data,2)
                Init{index,3}=updatecov(index,espn,A,X);
            end
            if i==S0
                Init3=Init;            
            end
            Init0=Init;
        end
    end
    fprintf('----------Iteration End -----%s----------\n',datestr(now())); 
end