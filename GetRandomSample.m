function [TrainImgs,TrainLabels] = GetRandomSample( imgs,labels,Sequence,Nsamples,Npixels,ImgClasses,L,d,Angel,IsMaxNorm)
TrainImgs=cell(Npixels,1);
for cc=1:Npixels
    TrainImgs{cc,1}=zeros(d,2*Nsamples);
end

%% Get training samples of the first class
x1=find(labels==ImgClasses(1),1,'first');
x2=find(labels==ImgClasses(1),1,'last');

Num1=x2-x1+1;
Pos1=randperm(Num1,Nsamples);
Pos1=x1+Pos1-1;
TrainLabels=[ones(1,Nsamples);zeros(1,Nsamples)];

if(~imgs.IsV)
        [TrainImgs] = VectorizeDCTimage(d,imgs.data(:,:,Pos1),L,Sequence,Angel,IsMaxNorm);
else
    for j=1:Npixels
        TrainImgs{j,1}(:,1:Nsamples)=imgs.data{j}(:,Pos1);
    end
end

x1=find(labels==ImgClasses(2),1,'first');
x2=find(labels==ImgClasses(2),1,'last');

Num2=x2-x1+1;
Pos2=randperm(Num2,Nsamples);
Pos2=x1+Pos2-1;
TrainLabels=[TrainLabels,[zeros(1,Nsamples);ones(1,Nsamples)]];

%% Get training samples of the second class
if(~imgs.IsV)
    [myimgs] = VectorizeDCTimage(d,imgs.data(:,:,Pos2),L,Sequence,Angel,IsMaxNorm);
    for j=1:Npixels
      TrainImgs{j,1}(:,Nsamples+1:2*Nsamples)=myimgs{j};
    end
else
    for j=1:Npixels
       TrainImgs{j,1}(:,Nsamples+1:2*Nsamples)=imgs.data{j}(:,Pos2);
    end
end

end