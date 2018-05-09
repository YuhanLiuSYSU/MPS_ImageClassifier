function [] = PlotEntropy3D( entropy,Sequence,L,flag,dire,tsample )
entropymesh=zeros(L,L);

for i=1:length(entropy)
       entropymesh(Sequence(i,1),Sequence(i,2))=entropy(i); 
end
%gcf=figure('visible','off');
gcf=figure;
b=bar3(entropymesh);
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end
 axis([0 L 0 L 0 max(entropy)*1.1])
 set(gca, 'fontsize', 20)
%  if flag==0
%      title('SEE(Real Space)');
%      print(gcf, '-r600', '-dpng',[dire,'Sin_tsample_bar=',num2str(tsample)]) % dpi600
%  else
%      title('BEE(Real Space)');
%      print(gcf, '-r600', '-dpng',[dire,'Bi_tsample_bar=',num2str(tsample)]) % dpi600
%  end
%close(gcf)
end

