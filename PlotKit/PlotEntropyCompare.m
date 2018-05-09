%% fig(a) SEE in freq space 
load('data/MPS_Class(0-2)_d(2,16)_Map1_DCT_Reordered.mat');
see_r=SEE;
scale=10^4;
prec_r=(round(test_Precision.*scale))./scale;
load('data/MPS_Class(0-2)_d(2,16)_Map1_DCT.mat');
see=SEE;
prec=(round(test_Precision.*scale))./scale;


gcf=figure('Position',[10 10 580 450]);
 set( gca, 'Position', get( gca, 'OuterPosition' ) - ...
  get( gca, 'TightInset' ) * [-3.9 0 4.5 0; 0 -4.2 0 4.55; 0 0 2.5 0; 0 0 0 2.5] );


 mf=20;
 L_o=length(see);
 x=1:L_o;plot(x,see(1:L_o),'k--','LineWidth',1.5);
 myup=max(see)*1.1;
 hold on;xlabel('frequency','fontsize',mf);ylabel('SEE','fontsize',mf);axis([0 200 0 myup])
 
 plot(x,see_r(1:L_o),'b','LineWidth',2);
set(gca, 'fontsize', mf)

xt =-35;
yt = 0.68;
txt1 = '(a)';
text(xt,yt,txt1,'fontsize',mf+2);

x1 = [0.25,0.18];
y1 = [0.87,0.8];
a = annotation('textarrow',x1,y1,'String',[num2str(prec_r)],'fontsize',15);
a.Color='blue';

x2 = [0.35,0.32];
y2 = [0.8,0.75];
b = annotation('textarrow',x2,y2,'String',[num2str(prec)],'fontsize',15);
 
legend({'Without reordering','With reordering'},'FontSize',14)

axes('Position',[.58 .39 .35 .35])
box on
xL=1:length(see);
plot(xL,see(1:length(see)),'k');
axis([0 784 0 myup])
set(gca, 'fontsize', mf-5)

saveas(gcf,['plot/','figa.eps'],'eps2c');

%% fig(b) SEE in real space
load('data/MPS_Class(0-2)_d(2,16)_Map1_Real.mat')
sin_entropy=SEE;
scale=10^4;
prec=(round(test_Precision.*scale))./scale;
myup=max(sin_entropy)*1.3;
load('data/MPS_Class(0-2)_d(2,16)_Map1_Reordered.mat')
sin_entropy_r=SEE;
prec_r=(round(test_Precision.*scale))./scale;
myup=max(max(sin_entropy_r)*1.3,myup);

mf=20;
gcf=figure('Position',[10 10 540 450]);
L_o=length(SEE);

plot(x,sin_entropy(1:L_o),'color',[0,0,0]+0.5,'LineWidth',2);
set(gca, 'fontsize', mf);
hold on;xlabel('real space route','fontsize',mf);ylabel('SEE','fontsize',mf);
axis([0 784 0 myup]);
plot(x,sin_entropy_r(1:L_o),'r','LineWidth',2);
 
x1 = [0.35,0.31];
y1 = [0.8,0.75];
a1 = annotation('textarrow',x1,y1,'String',[num2str(prec)],'fontsize',15);
a1.Color=[0,0,0]+0.5;

x1 = [0.3,0.25];
y1 = [0.87,0.8];
a1 = annotation('textarrow',x1,y1,'String',[num2str(prec_r)],'fontsize',15);
a1.Color='r';
legend({'Without reordering','With reordering'},'FontSize',14)

xt =-160;
yt = 0.4;
txt1 = '(b)';
text(xt,yt,txt1,'fontsize',mf+2);

saveas(gcf,['plot/','figb.eps'],'eps2c'); 
%% fig(c)
load('data/MPS_Class(0-2)_d(2,16)_Map1_Real.mat')
bee_real=BEE;
scale=10^4;
prec_re=(round(test_Precision.*scale))./scale;

load('data/MPS_Class(0-2)_d(2,16)_Map1_Reordered.mat')
bee_real_r=BEE;
prec_re_r=(round(test_Precision.*scale))./scale;
myup=max(bee_real_r)*1.1;
load('data/MPS_Class(0-2)_d(2,16)_Map1_DCT.mat')
bee_freq=BEE;
prec_freq=(round(test_Precision.*scale))./scale;
load('data/MPS_Class(0-2)_d(2,16)_Map1_DCT_Reordered.mat')
bee_freq_r=BEE;
prec_freq_r=(round(test_Precision.*scale))./scale;

mf=20;
gcf=figure('Position',[10 10 580 450]);
 set( gca, 'Position', get( gca, 'OuterPosition' ) - ...
  get( gca, 'TightInset' ) * [-3.8 0 3.9 0; 0 -4.1 0 4.1; 0 0 2.5 0; 0 0 0 2.5] );

 L_o=784;
 x=1:L_o;plot(x,bee_real(1:L_o),'color',[0,0,0]+0.5,'LineWidth',1.5);
 hold on;xlabel('frequency/real space route','fontsize',mf);ylabel('BEE','fontsize',mf);
 axis([0 784 0 myup]);
   plot(x,bee_real_r(1:L_o),'r','LineWidth',2);
 plot(x,bee_freq(1:L_o),'k','LineWidth',2);
 plot(x,bee_freq_r(1:L_o),'b','LineWidth',2);

set(gca, 'fontsize', mf);
 
x1 = [0.82,0.86];
y1 = [0.35,0.38];
b = annotation('textarrow',x1,y1,'String',num2str(prec_re),'fontsize',mf-4);
b.Color=[0,0,0]+0.5;

x1 = [0.62,0.58];
y1 = [0.42,0.39];
b = annotation('textarrow',x1,y1,'String',num2str(prec_re_r),'fontsize',mf-4);
b.Color='red';
 
x2 = [0.28,0.25];
y2 = [0.76,0.73];
a = annotation('textarrow',x2,y2,'String',num2str(prec_freq),'fontsize',mf-4);
a.Color=[0,0,0];

x3= [0.215,0.18];
y3 = [0.89,0.8];
a = annotation('textarrow',x3,y3,'String',num2str(prec_freq_r),'fontsize',mf-4);
a.Color='blue';

%legend({'Real space','Real space-reordering','Freq space','Freq space-reordering'},'fontsize',mf-4)
xt =-150;
yt = 2.8;
txt1 = '(c)';
text(xt,yt,txt1,'fontsize',mf+2);

saveas(gcf,['plot/','figc.eps'],'eps2c'); 