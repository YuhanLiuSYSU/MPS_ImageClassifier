%%
var=50:50:600;
name='CutNum';

Ni=numel(var);
testtime=5;
Precision=zeros(Ni,testtime);
Overlap=zeros(Ni,testtime);
TrainPrecison=zeros(Ni,testtime);
TrainOverlap=zeros(Ni,testtime);
SEEmax=zeros(Ni,testtime);
BEEmax=zeros(Ni,testtime);

%%
var=50:50:300;%
Ni=numel(var);%
testtime=10;%
name='CutNum';%
Para=Parameter;
mkdir('TestData')
var=var';

for ii=7:testtime
    fprintf('the %d-th time...\n',ii);
for n=1:Ni
    eval(['Para.',name,'=',num2str(var(n)),';']);
    Para.EXP=[Para.ResultPath,'MPS_Class(',num2str(Para.ImgsClasses(1)),'-',num2str(Para.ImgsClasses(2)),')_d(',num2str(Para.d),',',...
        num2str(Para.chi),')_Map',num2str(Para.featuremap)];
    
    if(Para.IsReorder&&~Para.IsCut)
        Para.EXP=[Para.EXP,'_Reordered'];
    elseif(Para.IsCut&&~Para.IsReorder)
        Para.EXP=[Para.EXP,'_Cut',num2str(Para.CutNum)];
    elseif(Para.IsCut&&Para.IsReorder)
        Para.EXP=[Para.EXP,'_Cut',num2str(Para.CutNum),'_Reordered'];
    end
    
    
    MainFun(Para);
    
    load(Para.EXP)
    Overlap(n,ii)=test_Overlap(end);
    Precision(n,ii)=test_Precision(end);
    TrainOverlap(n,ii)=train_overlap(end);
    TrainPrecison(n,ii)=train_precision(end);
    SEEmax(n,ii)=max(SEE(:));
    BEEmax(n,ii)=max(BEE(:));
    
    if(n==1&&ii==1)
        save([Para.ResultPath,'TestCut.mat'],'var','Precision','Overlap','TrainPrecison','TrainOverlap','SEEmax','BEEmax');
    else
        save([Para.ResultPath,'TestCut.mat'],'var','Precision','Overlap','TrainPrecison','TrainOverlap','SEEmax','BEEmax','-append');
    end
 
end
end