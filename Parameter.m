function Para=Parameter

Para.ImgsClasses=[0,2]; %distinguish classes
Para.chi=16;
Para.d=2;

Para.Fourier=0;
Para.Angel=[0,0.5]; % *pi/2 ; range of angel in the feature  % real space[0,0.5]  %dct space[0,2.5]
Para.NumberSample=500;
Para.updatetime=4; % iteration time with fixed samples
Para.updatetime0=1; % minimal update time
Para.BreakEps=1e-3;
Para.ReSampleTime=8; % iteration time where the samples are retaken
Para.delta_pert=1; % A small number that controls the pertubation on the environment tensor
Para.dTimeTest=Para.ReSampleTime; % In how many iteration time, the testing accuracy is calculated

Para.CutNum=0; % 0 or >Para.L^2: do not cut; N: cut to N sites
Para.IsReorder=0; % 0: do not reorder; 1: reorder and update orders; 2: reorder by the saved order
Para.UpdateOrderThreshold=30;
Para.IsFourierMaxNormalize=1; % If normalize each DCT image by its maximum; Only for DCT images
Para.IsCorrectNorm=1; % If correct the normalization factor according to the inner product
Para.featuremap=1;
Para.IsLoad=0; % If read existing MPS data
Para.IsPlot=2; % 1: plot while resampling; 0: do not plot; 2: plot while testing
Para.IsSave=2; % 1: save while resampling; 2: save while testing  |  Note:  If reorder, save while resampling
Para.IsPlot3D=0;

Para.IsSaveDctV=1; % If save the training vecterized data after DCT (about 90Mb)
Para.L=28;
Para.Labelbond=numel(Para.ImgsClasses);

if(Para.CutNum<0.1 || Para.CutNum>Para.L^2-0.1)
    Para.IsCut=0;
else
    Para.IsCut=1;
end

Para.TrainDataPath='Dataset\';
Para.TestDataPath=Para.TrainDataPath;

Para.ResultPath=['Result',filesep,'test',filesep];
if(~exist(Para.ResultPath,'dir'))
    mkdir(Para.ResultPath)
end
Para.EXP=[Para.ResultPath,'MPS_Class(',num2str(Para.ImgsClasses(1)),'-',num2str(Para.ImgsClasses(2)),')_d(',num2str(Para.d),',',...
    num2str(Para.chi),')_Map',num2str(Para.featuremap)];

if(Para.IsReorder&&~Para.IsCut)
    Para.EXP=[Para.EXP,'_Reordered'];
elseif(Para.IsCut&&~Para.IsReorder)
    Para.EXP=[Para.EXP,'_Cut',num2str(Para.CutNum)];
elseif(Para.IsCut&&Para.IsReorder)
    Para.EXP=[Para.EXP,'_Cut',num2str(Para.CutNum),'_Reordered'];
end



end
% Info %#ok<NOPTS>
