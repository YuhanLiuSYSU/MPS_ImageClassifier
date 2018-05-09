function [DCTimgsV] = VectorizeDCTimage(d,DCTImgs,L,Sequence,Angel,IsMaxNorm)

S=size(DCTImgs);  
Lc=S(1);  

if(numel(S)==2) % Reorder & Cut, 1D arrey images
    DCTimgsV=cell(Lc,1);
    for i=1:S(2)
        if(IsMaxNorm)
%             tempDCT=DCTImgs(:,i)/max(abs(DCTImgs(:,i)));
            tempDCT=DCTImgs(:,i)/(max(DCTImgs(:,i))-min(DCTImgs(:,i)));
            tempDCT=vectorize(tempDCT,d,L,1,Angel); % feature map
        else
            tempDCT=vectorize(DCTImgs(:,i),d,L,1,Angel); % feature map
        end
        for j=1:Lc
            DCTimgsV{j,1}(:,i)=tempDCT(j,:);
        end
    end
elseif(numel(S)==3) % Original case, 2D arrey images
    DCTimgsV=cell(L*L,1);
    for i=1:S(3)
        
        if(IsMaxNorm)
%             tempDCT=DCTImgs(:,:,i)/max(max(abs(DCTImgs(:,:,i))));
            tempDCT=DCTImgs(:,:,i)/(max(max(DCTImgs(:,:,i)))-min(min(DCTImgs(:,:,i))));
            tempDCT=vectorize(tempDCT,d,L,0,Angel); % feature map
        else
            tempDCT=vectorize(DCTImgs(:,:,i),d,L,0,Angel); % feature map
        end
        
        for j=1:L^2
            DCTimgsV{j,1}(:,i)=tempDCT(Sequence(j,1),Sequence(j,2),:);
        end
    end
else
    error('Logic error on the size of DCTImgs.\n')
end
end

