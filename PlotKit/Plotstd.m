load('data/TestCut.mat')
mys=size(Precision);myl=mys(1);
mymean=zeros(myl,1);
mystd=zeros(myl,1);
for ii=1:myl
    mymean(ii)=mean(Precision(ii,:));
    mystd(ii)=std(Precision(ii,:));
end

errorbar(var,mymean,mystd,'s-','LineWidth',2,'MarkerSize',8)
hold on
plot(var,mymean,'rs-','LineWidth',2,'MarkerSize',8)