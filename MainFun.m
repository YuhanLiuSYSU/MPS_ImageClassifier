%% Cleaned version from the stable version
 function MainFun(varargin)
%% Preparation
tic % Counting computational time

if(numel(varargin)==1)
%      Para=varargin{1};
else
    Para=Parameter;
end
Para %#ok<NOPRT>



if(norm(Para.Angel-[0,1])>1e-10)
    warning('The angels in the feature map is not standard. Make sure the saved vectorized data are consistent. \n')
end

train_precision=zeros(Para.ReSampleTime,1);
train_overlap=zeros(Para.ReSampleTime,1);
test_precision=zeros(Para.ReSampleTime,1);
test_overlap=zeros(Para.ReSampleTime,1);
time_test=0;
Nsample=Para.NumberSample; % number of samples in each time
Npixel=Para.L^2;ONpixel=Npixel;
Sequence0=SequenceZigZag(Para.L);
ReorderC=0;

%% Load dataset
[imgs,labels,imgs_t,labels_t]=ReadTrainAndTest(Para,Sequence0);

 for tsample=1:Para.ReSampleTime
      %% ======== Renew Training Samples =========
     fprintf(['Training with new samples: tsample=',num2str(tsample),'\n']);
     [TrainImgs,TrainLabels] = GetRandomSample( imgs,labels,Sequence0,Nsample,ONpixel,Para.ImgsClasses,Para.L,Para.d,...
         Para.Angel,Para.Fourier*Para.IsFourierMaxNormalize);
     
     
     %% Consider reordering & cutting.
     if(Para.Fourier)
         EXPorder=[Para.ResultPath,'NewOrder(',num2str(Para.ImgsClasses(1)),'-',num2str(Para.ImgsClasses(2)),')DCT.mat'];
     else
         EXPorder=[Para.ResultPath,'NewOrder(',num2str(Para.ImgsClasses(1)),'-',num2str(Para.ImgsClasses(2)),')Real.mat'];
     end
     flagdataMPS=(exist([Para.EXP,'.mat'],'file') && Para.IsLoad);
     IsOrderUpdated=0;
     if(Para.IsReorder==1)
         fprintf('Consider reording data ... \n');
         if(tsample==1 && exist(EXPorder,'file'))
             % Use the existing NewOrder
             fprintf('New-Order file exists. Loading ... \n');
             load(EXPorder,'NewOrder');
             if(flagdataMPS)
                 load(Para.EXP,'OrderNow');
                 if(exist('OrderNow','var'))
                     IsOrderUpdated=(sum(OrderNow~=NewOrder)>Para.UpdateOrderThreshold);
                 else
                     IsOrderUpdated=1;
                 end
                 if(IsOrderUpdated==0)
                     fprintf('The order of the existing MPS is similar to the saved NewOrder. Use the order of the MPS. \n')
                     NewOrder=OrderNow;
                 end
             else
                 IsOrderUpdated=1;
             end
             [TrainImgs]=Reorder_Data(TrainImgs,NewOrder);
         elseif(tsample==1 && ~exist(EXPorder,'file'))
             fprintf('New-Order file does not exist. Creating NewOrder ... \n');
             if(flagdataMPS)
                 load(Para.EXP,'SEE','OrderNow');
                 [~,NewOrder]=sort(SEE,'descend');
                 if(exist('OrderNow','var'))
                     IsOrderUpdated=(sum(NewOrder~=(1:Npixel).')>Para.UpdateOrderThreshold);
                 else
                     OrderNow=(1:Npixel).';
                     IsOrderUpdated=1;
                 end
                 if(IsOrderUpdated)
                     NewOrder=OrderNow(NewOrder);
                 else
                     NewOrder=OrderNow;
                 end
                 [TrainImgs]=Reorder_Data(TrainImgs,NewOrder);
             else
                 NewOrder=(1:Npixel).';
             end
         else
             dOrder=sum(NewOrder~=(1:Npixel).');
             if(dOrder>Para.UpdateOrderThreshold)
                 fprintf(['The change of NewOrder is ',num2str(dOrder),'>',num2str(Para.UpdateOrderThreshold),'. Updating NewOrder ... \n']);                 
                 IsOrderUpdated=1;
             else
                 fprintf(['The change of NewOrder is ',num2str(dOrder),'<=',num2str(Para.UpdateOrderThreshold),'. Keep NewOrder unchanged ... \n']);
                 NewOrder=OrderNow;
             end
             [TrainImgs]=Reorder_Data(TrainImgs,NewOrder);
         end
         
         if(Para.IsCut&&tsample>1)
             if Para.CutFix==1
                Npixel=Para.CutNum;
             else                 
                Npixel=FindCut(BEE);
                Para.CutNum=Npixel;
                fprintf('# of remaining sites: %d\n',Npixel);
             end
             NewOrder=NewOrder(1:Npixel);
             TrainImgs=TrainImgs(1:Npixel);
             Para.IsReorder=2;
             ReorderC=1;
         end
         
     elseif(Para.IsReorder==2)
         if(tsample==1)
             fprintf('Training with the existing fixed order... \n')
             if(exist(EXPorder,'file'))
                 fprintf('Load the existing order... \n')
                 load(EXPorder,'NewOrder')
             else
                 error('For the case of Para.IsReorder=2, the order file is missing. Train the order first.')
             end
         end
         [TrainImgs]=Reorder_Data(TrainImgs,NewOrder);
         if(Para.IsCut)
             Npixel=Para.CutNum;
             NewOrder=NewOrder(1:Npixel);
             TrainImgs=TrainImgs(1:Npixel);
         end
         
     elseif(Para.IsReorder==0 && Para.IsCut)
         Npixel=Para.CutNum;
         TrainImgs=TrainImgs(1:Npixel);
     end     
     
     %% ======== Generate Initial MPS and vectors ========
     IsIniMPS = ((tsample==1||(tsample==2&&ReorderC==1)) && (~flagdataMPS || (flagdataMPS && ~Para.IsLoad)));
     if(IsIniMPS)
         % Initialize a new MPS
         fprintf('Randomly initialize the MPS. \n')
         MPS=Initial_MPS(Npixel,Para.d,Para.chi,Para.Labelbond);
         [VectorL,VectorR]=Initial_Vector( MPS,TrainImgs,TrainLabels,Npixel);
         delta=1;
     elseif tsample==1 && flagdataMPS && Para.IsLoad
         % Load existing MPS
         fprintf('MPS exists. Load directly. \n')
         load(Para.EXP,'MPS','Env');
         
         [VectorL,VectorR]=Initial_Vector( MPS,TrainImgs,TrainLabels,Npixel);
         delta=Para.delta_pert;
     else
         % Only re-sampling      
         [VectorL,VectorR]=Initial_Vector( MPS,TrainImgs,TrainLabels,Npixel);
         delta=Para.delta_pert;
     end
     if(Para.IsReorder && IsOrderUpdated && abs(delta-1)>1e-14)
         fprintf('Note: if the order is updated, set delta=1. \n')
         delta=1;
     end
     if(exist('Env','var')==0)
         % If no existing Env, use MPS as its initial guess
         if(Para.IsCorrectNorm)
             [Env]=UpdateEnv_All(VectorR,TrainImgs,VectorL,MPS,delta,MPS); 
         else
             [Env]=UpdateEnv_All(VectorR,TrainImgs,VectorL,MPS,delta); 
         end
     else
         if(Para.IsCorrectNorm)
             [Env]=UpdateEnv_All(VectorR,TrainImgs,VectorL,Env,delta,MPS); 
         else
             [Env]=UpdateEnv_All(VectorR,TrainImgs,VectorL,Env,delta); 
         end
     end
     
     %% Calculate the starting precision
     [Precision_init,Overlap_init]=CalculatePrecision(VectorL{1},VectorR{1});
     fprintf('At the beginning: Precision = %g, Overlap = %g \n',Precision_init,Overlap_init)
     
     %% ========= Update MPS ========
     PrecisionTrain=zeros(Para.updatetime,1); 
     OverlapTrain=PrecisionTrain;
     flagBreak=0;

     for ktime=1:Para.updatetime
        %% Update the boundary part of the MPS
        MPS{Npixel}=UpdateMPS_n(Env{Npixel},1); % Update the right-most tensor
        VectorR{Npixel}=UpdateVectorR(MPS{Npixel},TrainImgs{Npixel},[],2); % Update the right-most VectorR
        if(Para.IsCorrectNorm) % Update the second right-most Env
            Env{Npixel-1}=Update_Env(Env{Npixel-1},VectorL{Npixel-1},TrainImgs{Npixel-1},VectorR{Npixel},delta,0,MPS{Npixel-1}); 
        else
            Env{Npixel-1}=Update_Env(Env{Npixel-1},VectorL{Npixel-1},TrainImgs{Npixel-1},VectorR{Npixel},delta,0); 
        end
         
        %% Update the bulk parts
         for i=Npixel-1:-1:1
             MPS{i}=UpdateMPS_n(Env{i},0);
             VectorR{i}=UpdateVectorR(MPS{i},TrainImgs{i},VectorR{i+1},0); % The predictions
             if i~=1
                 if(Para.IsCorrectNorm)
                     Env{i-1}=Update_Env(Env{i-1},VectorL{i-1},TrainImgs{i-1},VectorR{i},delta,0,MPS{i-1});
                 else
                     Env{i-1}=Update_Env(Env{i-1},VectorL{i-1},TrainImgs{i-1},VectorR{i},delta,0);
                 end
             end
         end 

         %% Update all VectorL and Env for the next iteration
         VectorL=UpdateVectorL(MPS,TrainImgs,TrainLabels,Npixel); % Update all VectorL from second to the last. The first of VectorL is the label
         if(Para.IsCorrectNorm)
             [Env]=UpdateEnv_All(VectorR,TrainImgs,VectorL,Env,delta,MPS); 
         else
             [Env]=UpdateEnv_All(VectorR,TrainImgs,VectorL,Env,delta); 
         end

         %% Calculate precision
         [PrecisionTrain(ktime),OverlapTrain(ktime)]=CalculatePrecision(VectorL{1},VectorR{1});
         fprintf('At the %g-th sweep: Precision = %g, Overlap = %g \n',ktime,PrecisionTrain(ktime),OverlapTrain(ktime))
         
         %% Check convergence and break condition
         if(ktime>max(1.1,Para.updatetime0))
             flagBreak=( abs(OverlapTrain(ktime)-OverlapTrain(ktime-1))<Para.BreakEps );
         end
         if(flagBreak)
             fprintf('Converged. Break the iteration. \n')
             break;
         elseif(ktime==Para.updatetime)
             fprintf('Iteration of the current samples finished. \n')
         end
         train_precision(tsample)=PrecisionTrain(ktime);
         train_overlap(tsample)=OverlapTrain(ktime);
     end
      
     %% Calculate testing accuracy
     if(rem(tsample,Para.dTimeTest)==0)
         time_test=time_test+1;
         if(Para.IsReorder~=0)
             [TestSamples]=Reorder_Data(imgs_t.data,NewOrder);
             if(Para.IsCut)
                 TestSamples=TestSamples(1:Npixel);
             end
             [test_overlap(time_test),test_precision(time_test)]=TestData(MPS,TestSamples,labels_t,Para);
         else
             if(Para.IsCut)
                 TestSamples=imgs_t.data(1:Npixel);
                 [test_overlap(time_test),test_precision(time_test)]=TestData(MPS,TestSamples,labels_t,Para);
             else
                 [test_overlap(time_test),test_precision(time_test)]=TestData(MPS,imgs_t.data,labels_t,Para);
             end
         end
         fprintf('For the test samples: Precision = %g, Overlap = %g \n',test_precision(time_test),test_overlap(time_test))
     end

     %% Calcualte entropy
     if(Para.IsPlot==1 || (Para.IsPlot==2 && rem(tsample,Para.dTimeTest)==0) || Para.IsReorder)
         [BEE,SEE]=Entangle(MPS);
%          PlotEntropy(BEE,SEE,Para.ResultPath,tsample);
         if(~Para.IsCut&&Para.IsPlot3D)
             PlotEntropy3D( SEE,Sequence0,Para.L,0,Para.ResultPath,tsample );
             PlotEntropy3D( BEE,Sequence0,Para.L,1,Para.ResultPath,tsample );
             pause(0.1)
         end
    end

     %% Save data
     if(Para.IsReorder || Para.IsSave==1 || (Para.IsSave==2 && rem(tsample,Para.dTimeTest)==0))
         test_Overlap=test_overlap(1:time_test); test_Precision=test_precision(1:time_test); %#ok<NASGU>
         save(Para.EXP,'MPS','Env','BEE','SEE','test_Overlap','test_Precision','train_precision','train_overlap','Para'); 
         if(Para.IsReorder==1)
             OrderNow=NewOrder;
             [~,NewOrder]=sort(SEE,'descend');
             NewOrder=OrderNow(NewOrder);
             save(Para.EXP,'OrderNow','-append'); 
             save(EXPorder,'NewOrder')
         end
     end
 end
toc
fprintf('Done! ¨r£¨£þ¨Œ£þ£©¨q  \n\n');
 end
 
%% Find zig-zag sequence
function Sequence=SequenceZigZag(L)
 % Return the zigzag sequence of the 2D image
 Sequence=zeros(L^2,2);
 flag=1;
for x=2:2*L
    [Sequencetemp]=FindSequence(x,L);
    templength=size(Sequencetemp,1);
    Sequence(flag:flag+templength-1,:)=Sequencetemp;
    flag=flag+templength;
end
 end
 
%% Function for calculate precision
function [Precision,Overlap]=CalculatePrecision(Label,Prediction)
Nsample=size(Label,2);
% Prediction=abs(Prediction);
 
%  Overlap=trace(abs(Prediction'*(Label)))/Nsample;
Overlap=0;
for n=1:Nsample
     Overlap=Overlap+Prediction(:,n)'*Label(:,n)/Nsample;
end
Precision=0;

 for j=1:Nsample
     pred= double(Prediction(:,j)==max(Prediction(:,j)));
     Precision=Precision+(Label(:,j)).'*pred/norm(pred);
 end
 Precision=Precision/Nsample;
 end
 
 %% Calculate testing precision
function [Overlap_t,Precision_t]=TestData(MPS,imgs_t,labels_t,Para)
L_o=numel(MPS);
Myimgs_t=cell(L_o,1);
x1=find(labels_t==Para.ImgsClasses(1),1,'first');
x2=find(labels_t==Para.ImgsClasses(1),1,'last');

Num1=x2-x1+1;
Pos=(x1:1:x2);
Mylabels_t=[ones(1,Num1);zeros(1,Num1)];

for j=1:L_o
      Myimgs_t{j,1}(:,1:Num1)=imgs_t{j}(:,Pos);
end
    
x1=find(labels_t==Para.ImgsClasses(2),1,'first');
x2=find(labels_t==Para.ImgsClasses(2),1,'last');
    
Num2=x2-x1+1;
Pos=(x1:1:x2);
Mylabels_t=[Mylabels_t,[zeros(1,Num2);ones(1,Num2)]];
    
for j=1:L_o
     Myimgs_t{j,1}(:,Num1+1:Num1+Num2)=imgs_t{j}(:,Pos);
end

[VectorR_t]=CalculatePredV( MPS,Myimgs_t,L_o);
[Precision_t,Overlap_t]=CalculatePrecision(Mylabels_t,VectorR_t);
 end

 %% Calculate entropy of the MPS
function PlotEntropy(BEE,SEE,ResultPath,tsample) %#ok<DEFNU>
L_o=numel(BEE);

gcf=figure('visible','off');
x=2:L_o-1;plot(x,BEE(2:L_o-1));
hold on;xlabel('momentum route');ylabel('entanglement entropy');title(['Bipartition Entanglement,tsample=',num2str(tsample)]);hold off;
print(gcf, '-r600', '-dpng',[ResultPath,'Bi_tsample=',num2str(tsample)]) % dpi600
close(gcf)

gcf=figure('visible','off');
semilogy(x,BEE(2:L_o-1));
hold on;xlabel('momentum route');ylabel('log entanglement entropy');title(['Bipartition Entanglement,tsample=',num2str(tsample)]);hold off;
print(gcf, '-r600', '-dpng',[ResultPath,'Bi_log_tsample=',num2str(tsample)]) % dpi600
close(gcf)

gcf=figure('visible','off');
x=1:L_o-2;plot(x,SEE(1:L_o-2));
hold on;xlabel('momentum route');ylabel('entanglement entropy');title(['Single-point Entanglement,tsample=',num2str(tsample)]);hold off;
print(gcf, '-r600', '-dpng',[ResultPath,'Sin_tsample=',num2str(tsample)]) % dpi600
close(gcf)

gcf=figure('visible','off');
semilogy(x,SEE(1:L_o-2));
hold on;xlabel('momentum route');ylabel('log entanglement entropy');title(['Single-point Entanglement,tsample=',num2str(tsample)]);hold off;
print(gcf, '-r600', '-dpng',[ResultPath,'Sin_log_tsample=',num2str(tsample)]) % dpi600
close(gcf)

fprintf('Entropy...Done\n');
 end
 
 %% ReOrder
function [Samples1]=Reorder_Data(Samples,NewOrder)
 % Samples must be vectorized
 Npixel=numel(NewOrder);
 Samples1=cell(Npixel,1);
 for n=1:Npixel
     Samples1{n,1}=Samples{NewOrder(n),1};
 end
end

%% Update all environment tensors
function [Env]=UpdateEnv_All(VectorR,TrainImgs,VectorL,Env,delta,varargin)
Npixel=numel(TrainImgs);

for n=1:Npixel
     IsEdge=(n==(Npixel));
     if(IsEdge)
         EnvR=[];
     else
         EnvR=VectorR{n+1};
     end
     if(numel(varargin)==1)
         Env{n}=Update_Env(Env{n},VectorL{n},TrainImgs{n},EnvR,delta,IsEdge,varargin{1}{n});
     elseif(numel(varargin)==0)
         Env{n}=Update_Env(Env{n},VectorL{n},TrainImgs{n},EnvR,delta,IsEdge);
     end
 end
end
