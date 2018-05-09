function[]=ReadData(imgFile, labelFile,name,IsTestData)
fid = fopen(imgFile, 'r', 'b');
header = fread(fid, 1, 'int32');
if header ~= 2051
    error('Invalid image file header');
end
count = fread(fid, 1, 'int32');
myoffset=0;

if IsTestData==0
    [imgs1,labels] = readMNIST(imgFile, labelFile,count,myoffset);
    [labels,Order]=sort(labels,'ascend');
    
    imgs.data=zeros(size(imgs1));
    for n=1:size(labels,1)
        imgs.data(:,:,n)=imgs1(:,:,Order(n));
    end
    imgs.IsV=0;
    %imgstemp=imgs(:,:,1);
    %imshow(imgstemp);
    save(name,'imgs','labels')
else
    [imgs_t1,labels_t] = readMNIST(imgFile, labelFile,count,myoffset);
    [labels_t,Order]=sort(labels_t,'ascend');
    imgs_t.data=zeros(size(imgs_t1));
    for n=1:size(labels_t,1)
        imgs_t.data(:,:,n)=imgs_t1(:,:,Order(n));
    end
    imgs_t.IsV=0;
    save(name,'imgs_t','labels_t')
end
end


