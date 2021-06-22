%% IPCC AR6 Chapter 9: Figure 9.30 (RSL commitments)
%
% Code used to plot pre-processed regional sea level commitments
%
% Plotting code written by Baylor Fox-Kemper & Brodie Pearson
% Processed data provided by Gregory Garner

clear all

addpath ../../../Functions/

linewidth=2;

%% vanBreedam et al 2020

dat=importdata('vanbreedam2020/global_T_ts_van_breedam.txt');
VB2020.yrs=dat.data(:,1);
VB2020.scens=dat.colheaders(2:end);
VB2020.T=dat.data(:,2:end)+0.45; % adjust from 1970-2000 to 1880-1900 using GIStemp

[VB2020.peakT,mi]=max(VB2020.T);
VB2020.peakyr=VB2020.yrs(mi);

[m,mi]=min(abs(VB2020.yrs-2090));
VB2020.T2090=VB2020.T(mi,:);

dat=importdata('vanbreedam2020/sea_level_ts_van_breedam.txt');
[m,mi]=min(abs(dat.data(:,1)-4000));
VB2020.GMSL(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
VB2020.GMSL(:,:,2)=dat.data(mi,2:end);

dat=importdata('vanbreedam2020/sea_level_AIS_ts_van_breedam.txt');
[m,mi]=min(abs(dat.data(:,1)-4000));
VB2020.AIS(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
VB2020.AIS(:,:,2)=dat.data(mi,2:end);

dat=importdata('vanbreedam2020/sea_level_GrIS_ts_van_breedam.txt');
[m,mi]=min(abs(dat.data(:,1)-4000));
VB2020.GrIS(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
VB2020.GrIS(:,:,2)=dat.data(mi,2:end);

dat=importdata('vanbreedam2020/sea_level_glaciers_ts_van_breedam.txt');
[m,mi]=min(abs(dat.data(:,1)-4000));
VB2020.GIC(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
VB2020.GIC(:,:,2)=dat.data(mi,2:end);

dat=importdata('vanbreedam2020/sea_level_steric_ts_van_breedam.txt');
[m,mi]=min(abs(dat.data(:,1)-4000));
VB2020.GMTE(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
VB2020.GMTE(:,:,2)=dat.data(mi,2:end);

%% Clark et al 2016 UVic28

dat=importdata('clark2016/UVic28_GSAT.xlsx');
UVIC28.yrs=dat.data(:,1);
UVIC28.scens=dat.colheaders(2:end);
UVIC28.GSAT=dat.data(:,2:end);
UVIC28.T0=mean(UVIC28.GSAT(find(abs(UVIC28.yrs-1875)<=25)));

[UVIC28.peakT,mi]=max(UVIC28.GSAT);
UVIC28.peakT=UVIC28.peakT-UVIC28.T0;
UVIC28.peakyr=UVIC28.yrs(mi);

[m,mi]=min(abs(UVIC28.yrs-2090));
UVIC28.T2090=UVIC28.GSAT(mi,:)-UVIC28.T0;

dat=importdata('clark2016/UVic28_GMSL.xlsx');
[m,mi]=min(abs(dat.data(:,1)-4000));
UVIC28.GMSL(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
UVIC28.GMSL(:,:,2)=dat.data(mi,2:end);

dat=importdata('clark2016/UVic28_AIS.xlsx');
[m,mi]=min(abs(dat.data(:,1)-4000));
UVIC28.AIS(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
UVIC28.AIS(:,:,2)=dat.data(mi,2:end);

dat=importdata('clark2016/UVic28_GrIS.xlsx');
[m,mi]=min(abs(dat.data(:,1)-4000));
UVIC28.GrIS(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
UVIC28.GrIS(:,:,2)=dat.data(mi,2:end);

dat=importdata('clark2016/UVic28_GIC.xlsx');
[m,mi]=min(abs(dat.data(:,1)-4000));
UVIC28.GIC(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
UVIC28.GIC(:,:,2)=dat.data(mi,2:end);

dat=importdata('clark2016/UVic28_GMTE.xlsx');
[m,mi]=min(abs(dat.data(:,1)-4000));
UVIC28.GMTE(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
UVIC28.GMTE(:,:,2)=dat.data(mi,2:end);

%% Clark et al 2016 UVic29

dat=importdata('clark2016/UVic29_GSAT.xlsx');
UVIC29.yrs=dat.data(:,1);
UVIC29.scens=dat.colheaders(2:end);
UVIC29.GSAT=dat.data(:,2:end);
UVIC29.T0=mean(UVIC29.GSAT(find(abs(UVIC29.yrs-1875)<=25)));

[UVIC29.peakT,mi]=max(UVIC29.GSAT);
UVIC29.peakT=UVIC29.peakT-UVIC29.T0;
UVIC29.peakyr=UVIC29.yrs(mi);

[m,mi]=min(abs(UVIC29.yrs-2090));
UVIC29.T2090=UVIC29.GSAT(mi,:)-UVIC29.T0;

dat=importdata('clark2016/UVic29_GMSL.xlsx');
[m,mi]=min(abs(dat.data(:,1)-4000));
UVIC29.GMSL(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
UVIC29.GMSL(:,:,2)=dat.data(mi,2:end);

dat=importdata('clark2016/UVic29_AIS.xlsx');
[m,mi]=min(abs(dat.data(:,1)-4000));
UVIC29.AIS(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
UVIC29.AIS(:,:,2)=dat.data(mi,2:end);

dat=importdata('clark2016/UVic29_GrIS.xlsx');
[m,mi]=min(abs(dat.data(:,1)-4000));
UVIC29.GrIS(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
UVIC29.GrIS(:,:,2)=dat.data(mi,2:end);

dat=importdata('clark2016/UVic29_GIC.xlsx');
[m,mi]=min(abs(dat.data(:,1)-4000));
UVIC29.GIC(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
UVIC29.GIC(:,:,2)=dat.data(mi,2:end);

dat=importdata('clark2016/UVic29_GMTE.xlsx');
[m,mi]=min(abs(dat.data(:,1)-4000));
UVIC29.GMTE(:,:,1)=dat.data(mi,2:end);
[m,mi]=min(abs(dat.data(:,1)-12000));
UVIC29.GMTE(:,:,2)=dat.data(mi,2:end);

%Garbe et al. 2020 data
lowergarbe=csvread('GarbeData/lower_branch_equilibrium.csv');
uppergarbe=csvread('GarbeData/upper_branch_equilibrium.csv');

garbe2020.lower.T=lowergarbe(:,1);
garbe2020.upper.T=uppergarbe(:,1);
garbe2020.lower.AIS=uppergarbe(1,3)-lowergarbe(:,3);
garbe2020.upper.AIS=uppergarbe(1,3)-uppergarbe(:,3);

% DeConto and Pollard 2016
DP16.T = 3.2 * [log(7.994)/log(2) log(2.08)/log(2)]; %CCSM4 climate sensitivity of 3.2C, Bitz et al 2012
DP16.AIS = [19.5 6.0];

% Gregory et al. 2002 - Greenland
dat=importdata('Gregory2020/Gregory2020.xlsx');
Gr20.T=dat.data(:,4);
Gr20.GrIS=dat.data(:,2:3);

%% assessed paleo levels


% Paleo.label={'EECO','MCO','MPWP','LIG','CE'};
% Paleo.T=[14 7 3.25 1.0 0.1];
% Paleo.Tsd=[2 2 0.75 0.5 0.1];
% Paleo.sl=[72.5 23 15 7 0];
% Paleo.slsd=[1.5 7 5 2 0.1];

Paleo.label={'EECO','MPWP','LIG','CE'};
Paleo.T=[15 3.25 1.0 0.1];
Paleo.Tsd=[3 0.75 0.5 0.1];
Paleo.sl=[73 15 7.5 0];
Paleo.slsd=[3 10 2.5 0.1];


%%%%%

rows={'GMSL','AIS','GrIS','GMTE','GIC'};
rowlabel={'GMSL (m)','AIS (m)','GrIS (m)','Steric (m)','GIC (m)'};
ylims=[
    0 50
    0 40
    0 8
    0 4
    0 0.35
]

figure('Renderer', 'painters', 'Position', [10 10 1026 500])

colrs=[159 0 159 ; 0 0 159 ; 0 159 0 ; 159 159 0 ; 0 159 159]/255;
lightcolrs=.2*ones(size(colrs))+.8*colrs;
symbs='dos+^';
paleocolor=[124 130 130]/255;

clear hp;

for vvv=1:2
  for sss=1:length(rows)

    clear hp;
    subplot(2,length(rows),sss+(2-vvv)*5)
    qqq=1;
    hp(qqq)=plot(UVIC28.peakT,UVIC28.(rows{sss})(:,:,vvv),[symbs(qqq) '-'],'Color',colrs(qqq,:),'MarkerFaceColor',colrs(qqq,:),'LineWidth',linewidth);
    %hp(qqq)=plot(UVIC28.peakT,UVIC28.(rows{sss})(:,:,vvv), '-','Color',colrs(qqq,:),'MarkerFaceColor',colrs(qqq,:));
 
    hold on;
    qqq=2;
    hp(qqq)=plot(UVIC29.peakT,UVIC29.(rows{sss})(:,:,vvv),[symbs(qqq) '-'],'Color',colrs(qqq,:),'MarkerFaceColor',colrs(qqq,:),'LineWidth',linewidth);
    %hp(qqq)=plot(UVIC29.peakT,UVIC29.(rows{sss})(:,:,vvv), '-','Color',colrs(qqq,:),'MarkerFaceColor',colrs(qqq,:));

    hold on;
    qqq=3;
    hp(qqq)=plot(VB2020.peakT,VB2020.(rows{sss})(:,:,vvv),[symbs(qqq) '-'],'Color',colrs(qqq,:),'MarkerFaceColor',colrs(qqq,:),'LineWidth',linewidth);
    %hp(qqq)=plot(VB2020.peakT,VB2020.(rows{sss})(:,:,vvv),'-','Color',colrs(qqq,:),'MarkerFaceColor',colrs(qqq,:));
    if vvv==2
        set(gca,'XTickLabel',[]);
    end

    if strcmpi(rows{sss},'AIS')
        if vvv==2
            title('AIS','Fontsize',16)
            qqq=4;
%            hp(qqq)=plot(garbe2020.lower.T,garbe2020.lower.AIS,[symbs(qqq) '-'],'Color',colrs(qqq,:),'MarkerFaceColor',colrs(qqq,:));
            hp(qqq)=plot(garbe2020.upper.T,garbe2020.upper.AIS,[symbs(qqq) '-'],'Color',colrs(qqq,:),'MarkerFaceColor',colrs(qqq,:),'LineWidth',linewidth);
            %hp(qqq)=plot(garbe2020.upper.T,garbe2020.upper.AIS,'-','Color',colrs(qqq,:),'MarkerFaceColor',colrs(qqq,:));
            %hl=legend(hp(qqq),'Garbe et al. 2020, deglac.','Location','Northwest');
            %set(hl,'fontsize',7);
            txt = {'Garbe et al.', '2020, deglac.'};
            text(4.6,3,txt,'FontSize',9, ...
                'Color', colrs(4,:), 'FontWeight', 'bold','HorizontalAlignment','center')
        end
        if vvv==1
            qqq=4;
            hm(qqq)=plot(DP16.T,DP16.AIS,symbs(qqq+1),'Color',colrs(qqq+1,:),'MarkerFaceColor',colrs(qqq+1,:));
            hm(qqq).MarkerSize = 8;
            blank=plot([0 0],[0 0],'-','Color','w');
            hl=legend([hm(qqq) blank],'DeConto &,', 'Pollard, 2016','Location','Northwest','Box','off');
            set(hl,'fontsize',10);
        end
    end


    if strcmpi(rows{sss},'GrIS')
        if vvv==2
            title('GrIS','Fontsize',16)
        end
        qqq=4;
        hm(qqq)=plot(Gr20.T,Gr20.GrIS(:,vvv),'x','Color','k','MarkerFaceColor','k');
        hm(qqq).MarkerSize = 5;
        blank=plot([0 0],[0 0],'-','Color','w');
        if vvv==1
            hl=legend([hm(qqq) blank],'Gregory et', 'al., 2020.','Location','Northwest','Box','off');
            set(hl,'fontsize',10);
        end
    end


    xlim([0 6]); ylim(ylims(sss,:));
    set(hp,'markersize',3)
    set(gca,'FontSize',12)
    %xlabel('GSAT Anomaly (^oC)')
    if sss==1
        if vvv==1
            ylabel('2000-year','Fontsize',16);
            set(gca,'FontSize',12)
            %hl=legend(hp,'Clark et al. 2016 - UVic 2.8','Clark et al. 2016 - UVic 2.9','van Breedam et al. 2020','Paleo','Location','Northwest');
            %set(hl,'fontsize',7);
            txt = {'Clark et al. 2016', '(UVic 2.8)'};
            text(2,28,txt,'FontSize',10, ...
                'Color', colrs(1,:), 'FontWeight', 'bold','HorizontalAlignment','center')
            txt = {'Clark et al. 2016', '(UVic 2.9)'};
            text(2,18,txt,'FontSize',10, ...
                'Color', colrs(2,:), 'FontWeight', 'bold','HorizontalAlignment','center')
        elseif vvv==2
            ylabel('10000-year','Fontsize',16);
            title('GMSL')
            qqq=qqq+1;
            %hp(qqq)=plot(Paleo.T,Paleo.sl,'v','Color',paleocolor);
            for www=1:length(Paleo.T);
                paleopatch(www)=patch([Paleo.T(www)+Paleo.Tsd(www) ...
                    Paleo.T(www)-Paleo.Tsd(www) ...
                    Paleo.T(www)-Paleo.Tsd(www) ...
                    Paleo.T(www)+Paleo.Tsd(www) ...
                    Paleo.T(www)+Paleo.Tsd(www)], ...
                    [Paleo.sl(www)+Paleo.slsd(www) ...
                    Paleo.sl(www)+Paleo.slsd(www) ...
                    Paleo.sl(www)-Paleo.slsd(www) ...
                    Paleo.sl(www)-Paleo.slsd(www) ...
                    Paleo.sl(www)+Paleo.slsd(www)],'k', ...
                    'EdgeColor', 'none', 'FaceAlpha', 0.2)
            end
%             for www=1:length(Paleo.T);
%                 plot(Paleo.T(www)*[1 1]+Paleo.Tsd(www),Paleo.sl(www)*[1 1]+Paleo.slsd(www).*[-1 1],'-','Color',paleocolor);
%                 plot(Paleo.T(www)*[1 1]-Paleo.Tsd(www),Paleo.sl(www)*[1 1]+Paleo.slsd(www).*[-1 1],'-','Color',paleocolor);
%                 plot(Paleo.T(www)*[1 1]+Paleo.Tsd(www).*[-1 1],Paleo.sl(www)*[1 1]-Paleo.slsd(www),'-','Color',paleocolor);
%                 plot(Paleo.T(www)*[1 1]-Paleo.Tsd(www).*[-1 1],Paleo.sl(www)*[1 1]+Paleo.slsd(www),'-','Color',paleocolor);
%                 %plot(Paleo.T(www)*[1 1],Paleo.sl(www)+[-1 1]*Paleo.slsd(www),'-','Color',paleocolor);
%                 %plot(Paleo.T(www)+[1 -1]*Paleo.Tsd(www),Paleo.sl(www)*[1 1],'-','Color',paleocolor);
%             end
            hl=legend(paleopatch(1),'Paleo ranges','Location','Northwest');
            set(gca,'FontSize',12)
            set(hl,'fontsize',10);
            txt = {'van Breedam', 'et al. 2020'};
            text(4,5,txt,'FontSize',10, ...
                'Color', colrs(3,:), 'FontWeight', 'bold','HorizontalAlignment','center')
        end
    end
    if vvv==2
        title(rowlabel{sss},'Fontsize',16);
    end  
    if sss==3 & vvv==1
        xlabel('Peak GSAT anomaly (^oC)','Fontsize',16);
    end
end
end

print(gcf,'../PNGs/SLR_commitments.png','-dpng','-r1000', '-painters');


%pdfwrite('commitment_panels')

%%% output table

testt=[1:.5:8];
timesc=[2000 10000];
fid = fopen('committment.tsv','w');
fprintf(fid,'Model\tComponent\tTime\tMinT\tMaxT');
fprintf(fid,'\t%0.1f',testt);
fprintf(fid,'\n');
for sss=1:length(rows)
    for vvv=1:2
        qqq=1;
        fprintf(fid,['UVic28\t' rows{sss} '\t%0.0f'],timesc(vvv));
        fprintf(fid,'\t%0.2f',min(UVIC28.peakT));
        fprintf(fid,'\t%0.2f',max(UVIC28.peakT));     
        fprintf(fid,'\t%0.2f',interp1(UVIC28.peakT,UVIC28.(rows{sss})(:,:,vvv),testt,'linear','extrap'));
        fprintf(fid,'\n');

        qqq=2;
        fprintf(fid,['UVic29\t' rows{sss} '\t%0.0f'],timesc(vvv));
        fprintf(fid,'\t%0.2f',min(UVIC29.peakT));
        fprintf(fid,'\t%0.2f',max(UVIC29.peakT));     
        fprintf(fid,'\t%0.2f',interp1(UVIC29.peakT,UVIC29.(rows{sss})(:,:,vvv),testt,'linear','extrap'));
        fprintf(fid,'\n');

        qqq=3;
        fprintf(fid,['VB2020\t' rows{sss} '\t%0.0f'],timesc(vvv));
        fprintf(fid,'\t%0.2f',min(VB2020.peakT));
        fprintf(fid,'\t%0.2f',max(VB2020.peakT));     
        fprintf(fid,'\t%0.2f',interp1(VB2020.peakT,VB2020.(rows{sss})(:,:,vvv),testt,'linear','extrap'));
        fprintf(fid,'\n');

        if strcmpi(rows{sss},'AIS')
            if vvv==2
                qqq=4;
                % fprintf(fid,['Garbe2020-Lower\t' rows{sss} '\t%0.0f'],Inf);
                % fprintf(fid,'\t%0.2f',min(garbe2020.lower.T));
                % fprintf(fid,'\t%0.2f',max(garbe2020.lower.T));     
                % fprintf(fid,'\t%0.2f',interp1(garbe2020.lower.T,garbe2020.lower.AIS,testt));
                % fprintf(fid,'\n');

                fprintf(fid,['Garber2020-Upper\t' rows{sss} '\t%0.0f'],Inf);
                fprintf(fid,'\t%0.2f',min(garbe2020.upper.T));
                fprintf(fid,'\t%0.2f',max(garbe2020.upper.T));             
                fprintf(fid,'\t%0.2f',interp1(garbe2020.upper.T,garbe2020.upper.AIS,testt));
                fprintf(fid,'\n');
            end
            if vvv==1
                qqq=4;
                fprintf(fid,['DeConto and Pollard 2016\t' rows{sss} '\t%0.0f'],Inf);
                fprintf(fid,'\t%0.2f',  min(DP16.T));
                fprintf(fid,'\t%0.2f',max(DP16.T));             
                fprintf(fid,'\t%0.2f',interp1(DP16.T,DP16.AIS,testt));
                fprintf(fid,'\n');
            end
        end    
    
        % if strcmpi(rows{sss},'GrIS')
        %     qqq=4;
        %     hm(qqq)=plot(Gr20.T,Gr20.GrIS(:,vvv),'x','Color','k','MarkerFaceColor','k');
        %     fprintf(fid,['Gregory et al 2020\t' rows{sss} '\t%0.0f'],Inf);
        %     fprintf(fid,'\t%0.2f',min(Gr20.T));
        %     fprintf(fid,'\t%0.2f',max(Gr20.T));             
        %     fprintf(fid,'\t%0.2f',interp1(Gr20.T,Gr20.GrIS,testt));
        %     fprintf(fid,'\n');

        % end
    end
end
fclose(fid);

%%%%

% Plot output data

var_name = 'SL_Commitment'; 
var_units = 'meters'; 

timesc=[2000 10000];
for sss=1:length(rows)
    for vvv=1:2
        ncfilename = ['../Plotted_Data/Fig9-30_data_Clark2016_UVic28_' rows{sss} '_' num2str(timesc(vvv)) 'y.nc']; 
        title = [num2str(timesc(vvv)) '-year SL rise commitment from ' rows{sss} ' as a function of peak Global Surface Air Temperature Anomaly' ... 
    ' (data from Clark et al., 2016, UVic 2.8)']; 
        comments = 'Data is for Figure 9.30 in the IPCC Working Group I contribution to the Sixth Assesment Report'; 
    IPCC_Write_NetCDF_Field(ncfilename, var_name, var_units, UVIC28.(rows{sss})(:,:,vvv)', 'Peak_GSAT_Anomaly_degC', UVIC28.peakT', title, comments) 

    ncfilename = ['../Plotted_Data/Fig9-30_data_Clark2016_UVic29_' rows{sss} '_' num2str(timesc(vvv)) 'y.nc']; 
    title = [num2str(timesc(vvv)) '-year SL rise commitment from ' rows{sss} ' as a function of peak Global Surface Air Temperature Anomaly' ... 
' (data from Clark et al., 2016, UVic 2.9)']; 
    comments = 'Data is for Figure 9.30 in the IPCC Working Group I contribution to the Sixth Assesment Report'; 
IPCC_Write_NetCDF_Field(ncfilename, var_name, var_units, UVIC28.(rows{sss})(:,:,vvv)', 'Peak_GSAT_Anomaly_degC', UVIC28.peakT', title, comments) 

ncfilename = ['../Plotted_Data/Fig9-30_data_VB2020_' rows{sss} '_' num2str(timesc(vvv)) 'y.nc']; 
title = [num2str(timesc(vvv)) '-year SL rise commitment from ' rows{sss} ' as a function of peak Global Surface Air Temperature Anomaly' ... 
' (data from van Breedam et al., 2020)']; 
comments = 'Data is for Figure 9.30 in the IPCC Working Group I contribution to the Sixth Assesment Report'; 
IPCC_Write_NetCDF_Field(ncfilename, var_name, var_units, VB2020.(rows{sss})(:,:,vvv)', 'Peak_GSAT_Anomaly_degC', VB2020.peakT', title, comments) 

    end
end

ncfilename = ['../Plotted_Data/Fig9-30_data_Garbe2020_AIS.nc']; 
title = ['SL rise commitment from AIS as a function of peak Global Surface Air Temperature Anomaly' ... 
' (data from Garbe et al., 2020, deglacial branch)']; 
comments = 'Data is for Figure 9.30 in the IPCC Working Group I contribution to the Sixth Assesment Report'; 
IPCC_Write_NetCDF_Field(ncfilename, var_name, var_units, garbe2020.upper.AIS, 'Peak_GSAT_Anomaly_degC', garbe2020.upper.T, title, comments) 

ncfilename = ['../Plotted_Data/Fig9-30_data_DeConto2016_AIS_2000y.nc']; 
title = ['2000-year SL rise commitment from AIS as a function of peak Global Surface Air Temperature Anomaly' ... 
' (data from DeConto and Pollard, 2016)']; 
comments = 'Data is for Figure 9.30 in the IPCC Working Group I contribution to the Sixth Assesment Report'; 
IPCC_Write_NetCDF_Field(ncfilename, var_name, var_units, DP16.AIS', 'Peak_GSAT_Anomaly_degC', DP16.T', title, comments) 

for vvv=1:2

    ncfilename = ['../Plotted_Data/Fig9-30_data_Gregory2020_GrIS_' num2str(timesc(vvv)) 'y.nc']; 
    title = [num2str(timesc) '-year SL rise commitment from GrIS as a function of peak Global Surface Air Temperature Anomaly' ... 
    ' (data from Gregory et al., 2020)']; 
    comments = 'Data is for Figure 9.30 in the IPCC Working Group I contribution to the Sixth Assesment Report'; 
    IPCC_Write_NetCDF_Field(ncfilename, var_name, var_units, Gr20.GrIS(:,vvv), 'Peak_GSAT_Anomaly_degC', Gr20.T, title, comments) 
end
