%%
var=[2.9,3,3.1,3.2];
% var=0.8;
name='Angel(2)';

Ni=numel(var);
Precison=zeros(Ni,1);
Overlap=zeros(Ni,1);
TrainPrecison=zeros(Ni,1);
TrainOverlap=zeros(Ni,1);
SEEmax=zeros(Ni,1);
BEEmax=zeros(Ni,1);

Para=Parameter;
mkdir('TestData')
var=var';
for n=1:Ni
    eval(['Para.',name,'=',num2str(var(n)),';']);
%     eval(['Para.',name,'(1)=',num2str(var(n)),';']); eval(['Para.',name,'(2)=',num2str(var(n)),'+0.5;']);
    Para.EXP=[Para.ResultPath,'MPS_Class(',num2str(Para.ImgsClasses(1)),'-',num2str(Para.ImgsClasses(2)),')_d(',num2str(Para.d),',',...
        num2str(Para.chi),')_Map',num2str(Para.featuremap)];    
    MainFun(Para);
    
    load(Para.EXP)
    Overlap(n)=test_Overlap(end);
    Precison(n)=test_Precision(end);
    TrainOverlap(n)=train_overlap(end);
    TrainPrecison(n)=train_precision(end);
    SEEmax(n)=max(SEE(:));
    BEEmax(n)=max(BEE(:));
    
    if(n==1)
        save(['TestData',filesep,'TestDelta.mat'],'var','Precison','Overlap','TrainPrecison','TrainOverlap','SEEmax','BEEmax');
    else
        save(['TestData',filesep,'TestDelta.mat'],'var','Precison','Overlap','TrainPrecison','TrainOverlap','SEEmax','BEEmax','-append');
    end
    save(['TestData',filesep,'MPS_Class(',num2str(Para.ImgsClasses(1)),'-',num2str(Para.ImgsClasses(2)),')_d(',num2str(Para.d),',',...
        num2str(Para.chi),')_Map',num2str(Para.featuremap),'_var',num2str(var(n)),'.mat'],'MPS','Env','BEE','SEE','test_Overlap','test_Precision',...
        'train_precision','train_overlap','Para');
end