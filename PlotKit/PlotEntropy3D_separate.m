function [] = PlotEntropy3D_separate(entropy,tstring)
L=28;
entropymesh=zeros(L,L);
Sequence=SequenceZigZag(L);

for i=1:length(entropy)
       entropymesh(Sequence(i,1),Sequence(i,2))=entropy(i); 
end
gcf=figure;
b=bar3(entropymesh);
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end
 axis([0 L 0 L 0 max(entropy)*1.1])
 set(gca, 'fontsize', 20) 
 title(tstring,'fontsize', 20)
 print(gcf, '-r600', '-dpng',['plot/',tstring])
 
end

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