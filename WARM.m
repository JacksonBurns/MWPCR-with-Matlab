%ͨ��WARM�������ƾ���
%input data��ͼ�����ݼ�n*p ch�����봰����� Cn�����ƴ��� Kloc���Ƿ�ʹ�þ���� Kst���Ƿ�ʹ�����ƺ�S0��ֹͣ��⿪ʼ�������� S�������ܴ��� Dis��������� X���Ա���
%output ���ƾ���WW ÿi�б�ʾ��i���������������ص����ƶ���
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
    dict1=false(size(data,2),1);%�������ֹͣ�ı��
    for i=1:S
        fprintf('----------��ʼ�ص�%d�ε��� ----------\n',i);
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
            beta(dict1,:)=Init0(dict1,1);%ֹͣ�Ĳ����е���
            if i>S0
%                ֹͣ׼�� 
                D=stopctiter(Init,Init3);
                dict0=D>chi2inv(0.8,2);
                dict=(~dict1)&dict0;%�������Ҫֹͣ�ı��
                dict1=dict1|dict0;%�������ֹͣ�ı��
                beta(dict,:)=Init0(dict,1);%ֹͣ                  
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