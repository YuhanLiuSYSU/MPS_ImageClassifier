function [] = PlotEntropyZview(entropy,tstring)
L=28;
entropymesh=zeros(L,L);
Sequence=SequenceZigZag(L);

for i=1:length(entropy)
       entropymesh(Sequence(i,1),29-Sequence(i,2))=entropy(i); 
end
gcf=figure('Position',[10 10 480 450]);
 set( gca, 'Position', get( gca, 'OuterPosition' ) - ...
  get( gca, 'TightInset' ) * [-0.5 0 0.5 0; 0 -1 0 2; 0 0 1 0; 0 0 0 1] );

set(gcf,'visible','off')
[X,Y] = meshgrid(1:1:L);

set(gca, 'fontsize', 20)
pcolor(X,Y,entropymesh); shading flat;axis equal; axis off;
%colobar1=colorbar('FontSize',15);
 title(tstring,'fontsize', 20)
 print(gcf, '-r600', '-dpng',['plot/Zview/',tstring])
 %axis([0 L 0 L 0 max(entropy)*1.1])
 

 %view(2);colorbar


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

