
load('data/TestCut_dct.mat');
tLc_dct=var; Precision_dct=Precison;
load('data/TestCut_dct_reordered.mat');
tLc_dct_r=var; Precision_dct_r=Precision;
load('data/TestCut_real.mat');
tLc_real=var; Precision_real=Precision;
load('data/TestCut_real_reordered');
tLc_real_r=var; Precision_real_r=Precision;

myfig=figure('Position',[10 10 650 500]);
set( gca, 'Position', get( gca, 'OuterPosition' ) - ...
  get( gca, 'TightInset' ) * [-4.0 0 4.8 0; 0 -4 0 3.6; 0 0 2.8 0; 0 0 0 2.5] );

mf=25;
plot(tLc_dct,Precision_dct,'ks-','LineWidth',2,'MarkerSize',8);
axis([0 600 0.4 1])
hold on;
plot(tLc_dct_r,Precision_dct_r,'bs-','LineWidth',2,'MarkerSize',8);
c=plot(tLc_real,Precision_real,'s-','LineWidth',2,'MarkerSize',8);
c.Color=[0,0,0]+0.5;
plot(tLc_real_r,Precision_real_r,'rs-','LineWidth',2,'MarkerSize',8);



xlabel('${\tilde{L}}$','Interpreter','LaTex','fontsize',mf);ylabel('Accuracy','fontsize',mf);
set(gca, 'fontsize', mf)

%({'Real','Freq','Freq.Reordering'},'FontSize',mf-4,'Location','southeast','Orientation','horizontal')


axes('Position',[.56 .38 .35 .3])
box on
plot(tLc_dct,Precision_dct,'ks-','LineWidth',2,'MarkerSize',4);
hold on
plot(tLc_dct_r,Precision_dct_r,'bs-','LineWidth',2,'MarkerSize',4);
axis([0 100 0.8 1.0])
set(gca, 'fontsize', mf-4)

xt =-160;
yt = 1.2;
txt1 = '(d)';
text(xt,yt,txt1,'fontsize',mf+2);

saveas(myfig,['plot/','figd.eps'],'eps2c'); 