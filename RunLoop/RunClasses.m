Nc=10;
Precison=zeros(Nc,Nc);
Overlap=zeros(Nc,Nc);
TrainPrecison=zeros(Nc,Nc);
TrainOverlap=zeros(Nc,Nc);
SEEmax=zeros(Nc,Nc);
BEEmax=zeros(Nc,Nc);

mkdir('TestData')
for n1=3:Nc-1
    for n2=n1+1:Nc-1
        Para=Parameter;
        Para.ImgsClasses=[n1,n2]; 
        Para.EXP=[Para.ResultPath,'MPS_Class(',num2str(Para.ImgsClasses(1)),'-',num2str(Para.ImgsClasses(2)),')_d(',num2str(Para.d),',',...
            num2str(Para.chi),')_Map',num2str(Para.featuremap)];    
        MainFun(Para);

        load(Para.EXP)
        Overlap(n1+1,n2+1)=test_Overlap(end);
        Precison(n1+1,n2+1)=test_Precision(end);
        TrainOverlap(n1+1,n2+1)=train_overlap(end);
        TrainPrecison(n1+1,n2+1)=train_precision(end);
        SEEmax(n1+1,n2+1)=max(SEE(:));
        BEEmax(n1+1,n2+1)=max(BEE(:));

        if(n1==0 && n2==1)
            save(['TestData',filesep,'TestDelta.mat'],'Precison','Overlap','TrainPrecison','TrainOverlap','SEEmax','BEEmax');
        else
            save(['TestData',filesep,'TestDelta.mat'],'Precison','Overlap','TrainPrecison','TrainOverlap','SEEmax','BEEmax','-append');
        end
    end
end