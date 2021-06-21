%% IPCC AR6 Chapter 9: Figure 9.11 (Barotropic Streamfunction maps)
%
% Code used to plot pre-processed transport of different currents. 
%
% Plotting code written by Baylor Fox-Kemper
% CMIP processed data provided by Alex Sen Gupta

clear all
close all


SG = xlsread('./Processed_Data/transport_data_for_AR6.xlsx', 'All Data');

fs=30; % Font Size

addpath ../../../Functions/

cr85 = IPCC_Get_SSPColors('rcp85');
c585 = IPCC_Get_SSPColors('ssp585');

%% Copy SenGupta data and likely ranges

% Big magnitude changes
rw=116;rf=rw+31;
GS100_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]   % GS (28-33^oN) 100m file
GS100_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]

rw=101;rf=rw+31;
GSx100_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]     % GSx (300^oE) 100m file
GSx100_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]

rw=113;rf=rw+31;
NGC100_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]    % NGC (10-5^oS)  100m file
NGC100_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]

% Big percentage changes

rw=102;rf=rw+31;
TASL100_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]    % TASL (146oE) 100m file
TASL100_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]
     
rw=104;rf=rw+31;
EACx100_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]    % EACx (40-35^oS) 100m file
EACx100_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]

rw=97;rf=rw+31;
ITF100_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]    % ITF  100m file -- Not biggest, but close
ITF100_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]

rw=114;rf=rw+31;
BC100_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]    % BC  100m file -- Bigger than ITF in CMIP6
BC100_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]


%1000m Currents

% Big magnitude changes
rw=2;rf=rw+31;
ACx1000_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]   % ACx (25^oE) 1000m file
ACx1000_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]

rw=5;rf=rw+31;
GSx1000_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]     % GSx (300^oE) 1000m file
GSx1000_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]

rw=20;rf=rw+31;
GS1000_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]    % GS (28-33^oN)  1000m file
GS1000_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]

% Big percentage changes

rw=6;rf=rw+31;
TASL1000_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]    % TASL (146oE) 1000m file
TASL1000_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]
           
rw=8;rf=rw+31;
EACx1000_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]    % EACx (40-35^oS) 1000m file
EACx1000_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]

rw=1;rf=rw+31;
ITF1000_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]    % ITF  1000m file
ITF1000_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]

rw=18;rf=rw+31;
BC1000_pre=[mean(SG(rw,1:28))	prctile(SG(rw,1:28),17)	prctile(SG(rw,1:28),83); mean(SG(rw,34:58))	prctile(SG(rw,34:58),17)     prctile(SG(rw,34:58),83)]    % BC 1000m file -- Bigger than ITF in CMIP6
BC1000_fut=[mean(SG(rf,1:28))	prctile(SG(rf,1:28),17)	prctile(SG(rf,1:28),83); mean(SG(rf,34:58))	prctile(SG(rf,34:58),17)     prctile(SG(rf,34:58),83)]



%% Create Figures

figure('Position', [0 0 600 600])

set(gca,'Box', 'on','Clipping','off')

%subplot(100,10,1:50)
wid=4;
sz=12;
x=0.8
plot([x,x], ACx1000_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], ACx1000_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=1.1
plot([x,x], ACx1000_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], ACx1000_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=0.9
plot([x,x], ACx1000_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], ACx1000_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=1.2
plot([x,x], ACx1000_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], ACx1000_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);

x=1.8
plot([x,x], GS1000_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], GS1000_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=2.1
plot([x,x], GS1000_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], GS1000_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=1.9
plot([x,x], GS1000_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], GS1000_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=2.2
plot([x,x], GS1000_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], GS1000_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);



x=2.8
plot([x,x], GSx1000_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], GSx1000_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=3.1
plot([x,x], GSx1000_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], GSx1000_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=2.9
plot([x,x], GSx1000_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], GSx1000_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=3.2
plot([x,x], GSx1000_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], GSx1000_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);



x=3.8
plot([x,x], TASL1000_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], TASL1000_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=4.1
plot([x,x], TASL1000_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], TASL1000_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=3.9
plot([x,x], TASL1000_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], TASL1000_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=4.2
plot([x,x], TASL1000_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], TASL1000_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);


x=4.8
plot([x,x], EACx1000_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], EACx1000_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=5.1
plot([x,x], EACx1000_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], EACx1000_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=4.9
plot([x,x], EACx1000_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], EACx1000_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=5.2
plot([x,x], EACx1000_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], EACx1000_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);


x=5.8
h1=plot([x,x], ITF1000_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], ITF1000_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=6.1
h2=plot([x,x], ITF1000_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], ITF1000_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=5.9
h3=plot([x,x], ITF1000_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], ITF1000_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=6.2
h4=plot([x,x], ITF1000_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], ITF1000_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);

x=6.8
h1=plot([x,x], ITF1000_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], ITF1000_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=7.1
h2=plot([x,x], ITF1000_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], ITF1000_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=6.9
h3=plot([x,x], ITF1000_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], ITF1000_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=7.2
h4=plot([x,x], ITF1000_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], ITF1000_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);

% VERTICAL DIVIDER
plot([3.5 3.5],[-60 60],':')

xlim([0 8])
hold off;

ylabel('0-1000m Current Transport (10^9 kg/s) ','FontSize',fs)
xticks([1 2 3 4 5 6 7]);
xticklabels({'ACx','GS','GSx','TASL','EACx','ITF','BC'});
xtickangle(90)
set(gca,'FontSize',fs,'Box', 'on')

%legend([h1, h2, h3, h4],'CMIP5 historical','CMIP5 RCP85','CMIP6 historical','CMIP6 SSP5-8.5','FontSize',fs,'Location','NorthEastOutside')

saveas(gcf,'../PNGs/SenGupta_1.png')



%% Create Figure2

figure('Position', [0 0 600 600])

set(gca,'Box', 'on','Clipping','off')

%subplot(100,10,1:50)
x=0.8
plot([x,x], GS100_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], GS100_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=1.1
plot([x,x], GS100_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], GS100_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=0.9
plot([x,x], GS100_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], GS100_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=1.2
plot([x,x], GS100_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], GS100_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);

x=1.8
plot([x,x], GSx100_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], GSx100_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=2.1
plot([x,x], GSx100_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], GSx100_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=1.9
plot([x,x], GSx100_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], GSx100_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=2.2
plot([x,x], GSx100_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], GSx100_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);



x=2.8
plot([x,x], NGC100_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], NGC100_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=3.1
plot([x,x], NGC100_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], NGC100_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=2.9
plot([x,x], NGC100_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], NGC100_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=3.2
plot([x,x], NGC100_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], NGC100_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);



x=3.8
plot([x,x], TASL100_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], TASL100_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=4.1
plot([x,x], TASL100_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], TASL100_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=3.9
plot([x,x], TASL100_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], TASL100_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=4.2
plot([x,x], TASL100_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], TASL100_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);


x=4.8
plot([x,x], EACx100_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], EACx100_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=5.1
plot([x,x], EACx100_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], EACx100_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=4.9
plot([x,x], EACx100_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], EACx100_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=5.2
plot([x,x], EACx100_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], EACx100_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);


x=5.8
h1=plot([x,x], ITF100_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], ITF100_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=6.1
h2=plot([x,x], ITF100_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], ITF100_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=5.9
h3=plot([x,x], ITF100_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], ITF100_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=6.2
h4=plot([x,x], ITF100_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], ITF100_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);


x=6.8
h1=plot([x,x], ITF100_pre(1,[2 3]),'--','Color','k','LineWidth',wid)
hold on;
plot([x], ITF100_pre(1,1),'o','Color','k', 'MarkerFaceColor', 'k','MarkerSize',sz)
x=7.1
h2=plot([x,x], ITF100_fut(1,[2 3]),'--','Color',cr85,'LineWidth',wid)
hold on;
plot([x], ITF100_fut(1,1),'o','Color',cr85,'MarkerFaceColor',cr85,'MarkerSize',sz)
x=6.9
h3=plot([x,x], ITF100_pre(2,[2 3]),'Color','k','LineWidth',wid)
plot([x], ITF100_pre(2,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',sz)
x=7.2
h4=plot([x,x], ITF100_fut(2,[2 3]),'Color',c585,'LineWidth',wid)
plot([x], ITF100_fut(2,1),'o','Color',c585,'MarkerFaceColor', c585,'MarkerSize',sz);

% VERTICAL DIVIDER
plot([3.5 3.5],[-11 11],':')

xlim([0 8])
ylim([-11 11])
hold off;

ylabel('0-100m Current Transport (10^9 kg/s)','FontSize',fs)
xticks([1 2 3 4 5 6 7]);
xticklabels({'GS','GSx','NGC','TASL','EACx','ITF','BC'});
xtickangle(90)
set(gca,'FontSize',fs,'Box', 'on')

legend([h1, h2, h3, h4],'CMIP5 historical','CMIP5 RCP85','CMIP6 historical','CMIP6 SSP5-8.5','FontSize',fs-4,'Location','NorthEast')

saveas(gcf,'../PNGs/SenGupta_2.png')


