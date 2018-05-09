%%
var=[1,0.5,0.2,0.1,0.01,0.005,0.001];
name='delta_pert';

Ni=numel(var);
Precison=zeros(Ni,1);
Overlap=zeros(Ni,1);

Para=Parameter;
mkdir('TestData_delta')
for n=1:Ni
    eval(['Para.',name,'=',num2str(var(n)),';']);
    Para.EXP=[Para.ResultPath,'MPS_Class(',num2str(Para.ImgsClasses(1)),'-',num2str(Para.ImgsClasses(2)),')_d(',num2str(Para.d),',',...
        num2str(Para.chi),')_Map',num2str(Para.featuremap)];    
    MainFun(Para);
    load(Para.EXP)
    Overlap(n)=test_Overlap(end);
    Precison(n)=test_Precision(end);
    if(n==1)
        save(['TestData_delta',filesep,'TestDelta.mat'],'var','Precison','Overlap');
    else
        save(['TestData_delta',filesep,'TestDelta.mat'],'var','Precison','Overlap','-append');
    end
    save(['TestData_delta',filesep,'MPS_Class(',num2str(Para.ImgsClasses(1)),'-',num2str(Para.ImgsClasses(2)),')_d(',num2str(Para.d),',',...
        num2str(Para.chi),')_Map',num2str(Para.featuremap),'.mat'],'MPS','Env','BEE','SEE','test_Overlap','test_Precision','Para');
end