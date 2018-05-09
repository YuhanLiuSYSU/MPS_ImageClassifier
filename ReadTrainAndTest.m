function [imgs,labels,imgs_t,labels_t]=ReadTrainAndTest(Para,Sequence)
% Save 1D data from 2D images (training dataset)
% Real-space data
flagdata0=exist([Para.TrainDataPath,'training.mat'],'file');
if(~flagdata0) 
    fprintf('2D Training data do not exist. Creating mat files... \n')
    ReadData([Para.TrainDataPath,'train-images.idx3-ubyte'],[Para.TrainDataPath,'train-labels.idx1-ubyte'],...
    [Para.TrainDataPath,'training.mat'],0);
else
    fprintf('2D Training data exist. Loading... \n')
end
if(~Para.Fourier)
    load([Para.TrainDataPath,'training.mat'],'imgs','labels');
end

% DCT data
if(Para.Fourier)
    EXPtrain=[Para.TrainDataPath,'traingingDct.mat'];
    flagdataF=exist(EXPtrain,'file');
    if(flagdataF)
            fprintf('2D Training data after DCT exist in Para.TrainDataPath. Loading... \n')
%             load([Para.TrainDataPath,'training.mat'],'labels');
            load(EXPtrain,'imgs','labels');
    else
            fprintf('2D Training data after DCT do not exist in Para.TrainDataPath. Creating mat files... \n')
            load([Para.TrainDataPath,'training.mat'],'imgs','labels');
            [imgs.data]=DCT(imgs.data,Para.Fourier); %#ok<NODEF>
%             fprintf('With small Info.d, create vectorized training samples... \n')
%             [imgs.data]=VectorizeDCTimage(Para.d,imgs.data,Para.L,Sequence,Para.Angel); % feature map
            imgs.IsV=0; % Vecrerized and Zigzaged
            save(EXPtrain,'imgs','labels');
    end
end

% Save 1D data from 2D images (testing dataset)
flagdata0=exist([Para.TrainDataPath,'testing.mat'],'file');
if(~flagdata0)
    fprintf('2D Original testing data do not exist. Creating mat files... \n')
    ReadData([Para.TrainDataPath,'t10k-images.idx3-ubyte'],[Para.TrainDataPath,'t10k-labels.idx1-ubyte'],...
        [Para.TrainDataPath,'testing.mat'],1);
else
    fprintf('2D Original testing data exist. Loading... \n')
end

if(~Para.Fourier) 
   EXPtest=[Para.TrainDataPath,'testingRealV_Theta(',num2str(Para.Angel(1)),'-',num2str(Para.Angel(2)),').mat'];
    flagdataR=exist(EXPtest,'file');
    if(flagdataR)
        fprintf('Vectorized testing data (without DCT) exist. Loading... \n')
        load(EXPtest,'imgs_t','labels_t');
    else
        fprintf('Vectorized testing data (without DCT) do not exist. Creating mat files... \n')
        load([Para.TestDataPath,'testing.mat'],'imgs_t','labels_t');
        [imgs_t.data]=VectorizeDCTimage(Para.d,imgs_t.data,Para.L,Sequence,Para.Angel,0);
        imgs_t.IsV=1;
        save(EXPtest,'imgs_t','labels_t');
    end
end

if(Para.Fourier)
    EXPtest=[Para.TrainDataPath,'testingDctV_Theta(',num2str(Para.Angel(1)),'-',num2str(Para.Angel(2)),')','_IsMaxNorm',num2str(Para.IsFourierMaxNormalize),'.mat'];
    if(exist(EXPtest,'file'))
            fprintf('Testing data (with DCT) exist in the Para.TestDataPath. Loading... \n')
            load(EXPtest);
    else
            fprintf('Testing data (with DCT) do not exist in Para.TestDataPath. Creating mat files... \n')
            load([Para.TestDataPath,'testing.mat'],'imgs_t','labels_t');
            [imgs_t.data]=DCT(imgs_t.data,Para.Fourier);
            [imgs_t.data]=VectorizeDCTimage(Para.d,imgs_t.data,Para.L,Sequence,Para.Angel,Para.IsFourierMaxNormalize);
            imgs_t.IsV=1;
            if(Para.IsSaveDctV)
                save(EXPtest,'imgs_t','labels_t');
            end
    end
end
end
