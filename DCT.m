function[DCTImgs]=DCT(imgs,IsDCT)
L=size(imgs,2);

    DCTImgs=zeros(size(imgs));
    for i=1:size(imgs,3)
        tmp=imgs(:,:,i);
        if IsDCT==1
            [DCTImgs(:,:,i),~,~]=DctII(tmp);
             DCTImgs(:,:,i)=DCTImgs(:,:,i)/L;
        else
            DCTImgs(:,:,i)=tmp; 
        end
    end
end

