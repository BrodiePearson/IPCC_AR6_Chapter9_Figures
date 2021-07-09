%% IPCC AR6 Chapter 9: Figure 9.25 (Sea level rise PDFs)
%
% Code used to plot pre-processed sea level rise PDFs 
%
% Plotting code written by Brodie Pearson & Bob Kopp
% Processed data provided by Bob Kopp
% Other datasets cited in report/caption

clear all

addpath ../../../Functions/
addpath ../Functions/

baseyear=2005;
histrate=3.2e-3;
summaryqlevs=[.05 .17 .83 .95];
conf_levs = [0.05, 0.17, 0.5, 0.83, 0.95];
grey_color = 0.1*[150 150 150]/255;

studyspecs.codes={
    'Bakker2017',
    'Jackson2016a',
    'Kopp2014',
    'Kopp2016',
    'Mengel2016',
    'Nauels2017a',
    'Slangen2014',
    'LeBars2018_partial',
    'LeCozannet2019_lowend',
    'Goodwin2017',
    'Nicholls2018',
    'Kopp2017',
    'Wong2017',
    'Grinsted2015',
    'Jackson2016b_HighEnd',
    'Jevrejeva2014',
    'Bamber2019',
    'Horton2020'
    };
studyspecs.names={
        'Bakker et al. 2017',
        'Jackson and Jevrejeva 2016',
        'Kopp et al. 2014',
        'Kopp et al. 2016',
        'Mengel et al. 2016',
        'Nauels et al. 2017a',
        'Slangen et al. 2014',
        'LeBars et al. 2018',
        'LeCozannet et al. 2019',
        'Goodwin et al. 2017',
        'Nicholls et al. 2018',
        'Kopp et al. 2017 [MICI]',
        'Wong et al. 2017 [MICI]',
        'Grinsted et al. 2015 [SEJ]',
        'Jackson and Jevrejeva 2016 [SEJ]',
        'Jevrejeva et al. 2014 [SEJ]',
        'Bamber et al. 2019 [SEJ]'
        'Horton et al. 2020 [ES]'
        };
for i=1:size(studyspecs.codes,1)
    ii=i;
    if i>10
        ii=i+2;
    end
    if i>14
        ii=i+8;
    end
    [a, b] ...
        = IPCC_Get_LineColors(size(studyspecs.codes,1),mod(ii,16)+1);
    studyspecs.colors(i,:) = 10*grey_color;
    if contains(studyspecs.names(i),"[SEJ]")
        studyspecs.linespec(i) = ":";
    elseif contains(studyspecs.names(i),"[MICI]")
        studyspecs.linespec(i) = "--";
    else
        studyspecs.linespec(i) = "-";
    end
%     studyspecs.colors(i,:) = a;
%     studyspecs.linespec(i) = string(b);
end
% studyspecs.linespec={
%     '-',
%     ':',
%     '-',
%     ':',
%     ':',
%     '-',
%     '-',
%     '--',
%     '--',
%     '--',
%     '--',
%     '--',
%     '--',
%     '-.',
%     '-.',
%     ':'
% };
studyspecs.conflev=[
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    3,
    3,
    4,
    4,
    4,
    4,
    5
];


datpaths={
    'datafiles/RCP85/',
    'datafiles/RCP45/',
    'datafiles/RCP26/'
};
scenlabs={
    'RCP 8.5',
    'RCP 4.5',
    'RCP 2.6'
};

AR5lev=[
    0.52 0.98
    0.36 0.71
    0.28 0.61
]-histrate*(baseyear-1996);
AR5lev2050=[
    0.22 0.38
    0.19 0.34
    0.17 0.32
]-histrate*(baseyear-1996) - 5 *0.005;

SROCClev=[
    0.61 1.10
    0.39 0.72
    0.29 0.59
]-histrate*(baseyear-1996);
SROCClev2050=[
    0.23 0.40
    0.19 0.34
    0.17 0.32
]-histrate*(baseyear-1996) - 5 *0.005;

AR6lev=[
    0.625 1.011 %0.631 1.017 %0.65 1.07  %GGG updated %BFK updated to v3 of AR6
    0.435 0.759 %0.438 0.759 %0.45 0.79
    0.324 0.615 %0.326 0.614 %0.33 0.63
];
AR6lev2050=[
    0.198 0.293 %0.201 0.296 %0.20 0.31  %GGG updated
    0.173 0.263 %0.176 0.264 %0.18 0.28
    0.158 0.247 %0.160 0.248 %0.16 0.26
];

AR6levHE2050=[0.195 0.397 %0.198 0.400 %0.20 0.41   %GGG updated
nan*0.173 nan*0.318 %nan*0.18 nan*0.34   %0.18 0.34  %BFK--note middle scenario not updated in v3
0.158 0.310 %0.160 0.223 %0.16 0.21
];

AR6levHE=[0.625 1.603 %0.63 1.61 %0.65 1.66  %GGG updated
nan*0.435 nan*0.875 %nan*0.45 nan*0.92 %0.45 0.92  %BFK--note middle scenario not updated in v3
0.324 0.791 %0.326 0.795 %0.33 0.47
];

AR6levHE2050_95=[0.159 0.541 %0.164 0.543  %0.65 1.66   %GGG updated
nan*0.138 nan*0.408 %nan*0.15 nan*0.43  %BFK--note middle scenario not updated in v3
0.130 0.400 %0.134 0.403 %0.14 0.42
];

AR6levHE_95=[0.530 2.274 %0.54 2.28  %0.56 2.33   %GGG updated
nan*0.355 nan*1.169 %nan*0.37 nan*1.21  %BFK--note middle scenario not updated in v3
0.265 1.085 %0.264 1.09 %0.26 1.11
];

clear yrstart yrend2050 yrend2100 qlevs qvals2050 qvals2100 study studyidx conflevs;
for nnn=1:length(studyspecs.codes)
    for lll=1:3
        datpath=datpaths{lll};    
        files=dir(fullfile(datpath,[studyspecs.codes{nnn} '*.xlsx']));
        iii=1;
        if length(files)>=1
            dat(iii)=importdata(fullfile(datpath,files(1).name));
            yrstart(nnn)=dat(iii).data.Sheet1(2,6);
            yrend2050(nnn)=dat(iii).data.Sheet1(2,7);
            yrend2100(nnn)=dat(iii).data.Sheet1(2,8);
            qlevs{nnn,lll}=dat(iii).data.Sheet1(2:end,1);
            qvals2050{nnn,lll}=dat(iii).data.Sheet1(2:end,2);
            qvals2100{nnn,lll}=dat(iii).data.Sheet1(2:end,3);
            qvals2050{nnn,lll}=qvals2050{nnn,lll}-(baseyear-yrstart(nnn))*histrate;
            deltayr=(yrend2050(nnn)-baseyear);
            qvals2050{nnn,lll}=(qvals2050{nnn,lll}-deltayr*histrate)*(2050-baseyear)^2/deltayr^2+(2050-baseyear)*histrate;
%            qvals2050{nnn,lll}=qvals2050{nnn,lll}.*((2050-baseyear)./(yrend2050(nnn)-baseyear));
            qvals2100{nnn,lll}=qvals2100{nnn,lll}-(baseyear-yrstart(nnn))*histrate;
            deltayr=(yrend2100(nnn)-baseyear);
            qvals2100{nnn,lll}=(qvals2100{nnn,lll}-deltayr*histrate)*(2100-baseyear)^2/deltayr^2+(2100-baseyear)*histrate;
%            qvals2100{nnn,lll}=qvals2100{nnn,lll}.*((2100-baseyear)./(yrend2100(nnn)-baseyear));
            study{nnn}=studyspecs.codes{nnn};
            studyidx(nnn)=nnn;
            conflevs(nnn)=studyspecs.conflev(studyidx(nnn));
        end
    end
end


fid=fopen('RCPprojections-summary.tsv','w');
fprintf(fid,'Study\tGrouping\tStart Year (pre-adj)\tEnd Year (pre-adj)');
for lll=1:3
    qqq=4-lll;
    fprintf(fid,['\t' scenlabs{qqq} '-0.67 \t ' scenlabs{qqq} '-0.90']);
end
fprintf(fid,'\n');
for nnn=1:length(studyspecs.codes)
    if ~isnan(yrend2050(nnn))
        fprintf(fid,[studyspecs.names{nnn} '\t%0.0f\t%0.0f\t%0.0f'],[conflevs(nnn) yrstart(nnn) yrend2050(nnn)]);
        for lll=1:3
            qqq=4-lll;
            sub1=find(abs(qlevs{nnn,qqq}-0.17)<=0.012);
            sub2=find(abs(qlevs{nnn,qqq}-0.83)<=0.012);
            if (length(sub1)==1)&&(length(sub2)==1)
                fprintf(fid,'\t%0.2f--%0.2f',qvals2050{nnn,qqq}([sub1 sub2]));
            else
                fprintf(fid,'\t');
            end
            sub1=find(abs(qlevs{nnn,qqq}-0.05)<=0.012);
            sub2=find(abs(qlevs{nnn,qqq}-0.95)<=0.012);
            if (length(sub1)==1)&&(length(sub2)==1)
                fprintf(fid,'\t%0.2f--%0.2f',qvals2050{nnn,qqq}([sub1 sub2]));
            else
                fprintf(fid,'\t');
            end
        end
        fprintf(fid,'\n');
    end
end
for nnn=1:length(studyspecs.codes)
    if ~isnan(yrend2100(nnn))
        fprintf(fid,[studyspecs.names{nnn} '\t%0.0f\t%0.0f\t%0.0f'],[conflevs(nnn) yrstart(nnn) yrend2100(nnn)]);
        for lll=1:3
            qqq=4-lll;
            sub1=find(abs(qlevs{nnn,qqq}-0.17)<=0.012);
            sub2=find(abs(qlevs{nnn,qqq}-0.83)<=0.012);
            if (length(sub1)==1)&&(length(sub2)==1)
                fprintf(fid,'\t%0.2f--%0.2f',qvals2100{nnn,qqq}([sub1 sub2]));
            else
                fprintf(fid,'\t');
            end
            sub1=find(abs(qlevs{nnn,qqq}-0.05)<=0.012);
            sub2=find(abs(qlevs{nnn,qqq}-0.95)<=0.012);
            if (length(sub1)==1)&&(length(sub2)==1)
                fprintf(fid,'\t%0.2f--%0.2f',qvals2100{nnn,qqq}([sub1 sub2]));
            else
                fprintf(fid,'\t');
            end
        end
        fprintf(fid,'\n');
    end
end
fclose(fid);


%% Create figure with all literature

% %figure;
% figure('Position', [10 10 1200 600])
% %set(gcf,'PaperPosition',[.3 .3 14 15])
% 
% % fid=fopen('SLRcdf.tsv','w');
% % %fprintf(fid,'Scenario\tYear\tCDF\tConflevel');
% % %fprintf(fid,'\t%0.3f',summaryqlevs);
% % %fprintf(fid,'\n');
% 
% clf;
% studylabs2050={''};
% studylabs2100={''};
% iiii2050=1; iiii2100=1;
% for lll=1:3
%     qqq=4-lll;
%     datpath=datpaths{qqq};
% 
%     if contains(scenlabs{qqq}, '8.5')
%         rcp_color = IPCC_Get_SSPColors('rcp85');
%         ax.XColor = grey_color;
%         ax.YColor = grey_color;
% %        text(0.02,0.8,['2050'], 'FontSize',25, ...
% %            'FontWeight','bold');
%     elseif contains(scenlabs{qqq}, '4.5')
%         rcp_color = IPCC_Get_SSPColors('rcp45');
%         ax.XColor = grey_color;
%         ax.YColor = grey_color;
% %         title(['SSP245 (2050)'],'Color', rcp_color);
%     elseif contains(scenlabs{qqq}, '2.6')
%         rcp_color = IPCC_Get_SSPColors('rcp26');
%         ax.XColor = grey_color;
%         ax.YColor = grey_color;
% %         title(['SSP126 (2050)'],'Color', rcp_color);
%     else
% %        title([scenlabs{qqq} ' (2050)']);
%     end
% 
%     clear dat qlevs qvals2050 qvals2100 study conflevs yrstarts;
%     clear studyidx studycolor studyline linespecs;
% 
%     iii=1;
%     for nnn=1:length(studyspecs.codes)
%         files=dir(fullfile(datpath,[studyspecs.codes{nnn} '*.xlsx']));
%         if length(files)>=1
%             dat(iii)=importdata(fullfile(datpath,files(1).name));
%             yrstart=dat(iii).data.Sheet1(2:end,6);
%             yrend2100=dat(iii).data.Sheet1(2:end,8);
%             qlevs{iii}=dat(iii).data.Sheet1(2:end,1);
%             qvals2050{iii}=dat(iii).data.Sheet1(2:end,2);
%             qvals2100{iii}=dat(iii).data.Sheet1(2:end,3);
%             qvals2050{iii}=qvals2050{iii}-(baseyear-yrstart)*histrate;
%             qvals2100{iii}=qvals2100{iii}-(baseyear-yrstart)*histrate;
%             qvals2100{iii}=qvals2100{iii}.*((2100-baseyear)./(yrend2100-baseyear));
%             study{iii}=studyspecs.codes{nnn};
%             studyidx(iii)=nnn;
%             studycolor(iii,:)=studyspecs.colors(studyidx(iii),:);
%             studyline{iii}=studyspecs.linespec{studyidx(iii)}; 
%             linespecs(iii).color=studycolor(iii,:);
%             linespecs(iii).linestyle=studyline{iii};
%             conflevs(iii)=studyspecs.conflev(studyidx(iii));
%             yrstarts(iii)=yrstart(1);
%             iii=iii+1;
%         end
%     end
% 
%     subplot(1,2,1)
%   
%     for iii=1:length(study)
%         % 5th-95th percentile
%         yval=iiii2050;
%         done=0;
%         qdo=[.05 .95];
%         if (min(abs(qlevs{iii}-qdo(1)))<=.01) && (min(abs(qlevs{iii}-qdo(2)))<=.01)
%             qdovals=interp1(qlevs{iii},qvals2050{iii},qdo);
%             if ~isnan(sum(qdovals))
%                 plot(qdovals,[yval yval],linespecs(iii).linestyle,'Color',rcp_color); hold on;
%                 done=1;
%             end
%         end
%         qdo=[.17 .83];
%         if (min(abs(qlevs{iii}-qdo(1)))<=.01) && (min(abs(qlevs{iii}-qdo(2)))<=.01)
%             qdovals=interp1(qlevs{iii},qvals2050{iii},qdo);
%             if ~isnan(sum(qdovals))
%                 plot(qdovals,[yval yval],linespecs(iii).linestyle,'Color',rcp_color,'LineWidth',4); hold on;
%                done=1;
%             end
%         end
%         studylabs2050{yval}=study{iii};
%         if done==1; iiii2050=iiii2050+1; end
%     end
% 
%     yval=iiii2050;
%     studylabs2050{yval}='AR5';
%     plot(AR5lev2050(qqq,:),[yval yval],'Color',rcp_color,'LineWidth',4);
%     iiii2050=iiii2050+1;
%     yval=iiii2050;
%     studylabs2050{yval}='SROCC';
%     plot(SROCClev2050(qqq,:),[yval yval],'Color',rcp_color,'LineWidth',4);
%     iiii2050=iiii2050+1;
%     yval=iiii2050;
%     studylabs2050{yval}='AR6';
%     plot(AR6lev2050(qqq,:),[yval yval],'Color',rcp_color,'LineWidth',4);
%     set(gca,'yticklabel',studylabs2050,'ytick',1:iiii2050)
%     ylim([.5 iiii2050+.5]);
%     iiii2050=iiii2050+1;
%     xlim([0 0.6])
%     title('2050')
% 
% 
%     subplot(1,2,2)
% 
%     for iii=1:length(study)
%         % 5th-95th percentile
%         yval=iiii2100;
%         done=0;
%         qdo=[.05 .95];
%         if (min(abs(qlevs{iii}-qdo(1)))<=.01) && (min(abs(qlevs{iii}-qdo(2)))<=.01)
%             qdovals=interp1(qlevs{iii},qvals2100{iii},qdo);
%             if ~isnan(sum(qdovals))
%                 plot(qdovals,[yval yval],linespecs(iii).linestyle,'Color',rcp_color); hold on;
%                 done=1;
%             end
%         end
%         qdo=[.17 .83];
%         if (min(abs(qlevs{iii}-qdo(1)))<=.01) && (min(abs(qlevs{iii}-qdo(2)))<=.01)
%             qdovals=interp1(qlevs{iii},qvals2100{iii},qdo);
%             if ~isnan(sum(qdovals))
%                 plot(qdovals,[yval yval],linespecs(iii).linestyle,'Color',rcp_color,'LineWidth',4); hold on;
%                done=1;
%             end
%         end
%         studylabs2100{yval}=study{iii};
%         if done==1; iiii2100=iiii2100+1; end
%     end
%     yval=iiii2100;
%     studylabs2100{yval}='AR5';
%     plot(AR5lev(qqq,:),[yval yval],'Color',rcp_color,'LineWidth',4);
%     iiii2100=iiii2100+1;
% 
%     yval=iiii2100;
%     studylabs2100{yval}='SROCC';
%     plot(SROCClev(qqq,:),[yval yval],'Color',rcp_color,'LineWidth',4);
%     iiii2100=iiii2100+1;
%     yval=iiii2100;
%     studylabs2100{yval}='AR6';
%     plot(AR6levHE_95(qqq,:),[yval yval],'Color',.1*rcp_color+.9*[1 1 1],'LineWidth',2);
%     plot(AR6levHE(qqq,:),[yval yval],'Color',.1*rcp_color+.9*[1 1 1],'LineWidth',8);
%     plot(AR6lev(qqq,:),[yval yval],'Color',rcp_color,'LineWidth',8);
%     set(gca,'yticklabel',studylabs2100,'ytick',1:iiii2100)
%      ylim([.5 iiii2100+.5]);
%      iiii2100=iiii2100+1;
%     
%     xlim([0 2.5])
%     if lll==1
%         title('2100')
%     end
% end
% % pdfwrite('SLRCDF');
% savefig('SSP_SLRCDFs.fig')
% close(1)
% %fclose(fid);


%% Create summary figure for chapter

figure('Position', [10 10 1200 600])

clf;
studylabs2050={''};
studylabs2100={''};
iiii2050=1; iiii2100=1;
for lll=1:3
    qqq=4-lll;
    datpath=datpaths{qqq};

    if contains(scenlabs{qqq}, '8.5')
        rcp_color = IPCC_Get_SSPColors('rcp85');
        ssp_color = IPCC_Get_SSPColors('ssp585');
        ax.XColor = grey_color;
        ax.YColor = grey_color;
%        text(0.02,0.8,['2050'], 'FontSize',25, ...
%            'FontWeight','bold');
    elseif contains(scenlabs{qqq}, '4.5')
        rcp_color = IPCC_Get_SSPColors('rcp45');
        ssp_color = IPCC_Get_SSPColors('ssp245');
        ax.XColor = grey_color;
        ax.YColor = grey_color;
%         title(['SSP245 (2050)'],'Color', rcp_color);
    elseif contains(scenlabs{qqq}, '2.6')
        rcp_color = IPCC_Get_SSPColors('rcp26');
        ssp_color = IPCC_Get_SSPColors('ssp126');
        ax.XColor = grey_color;
        ax.YColor = grey_color;
%         title(['SSP126 (2050)'],'Color', rcp_color);
    else
%        title([scenlabs{qqq} ' (2050)']);
    end

    clear dat qlevs qvals2050 qvals2100 study conflevs;
    clear studyidx studycolor studyline linespecs;

    iii=1;
    for nnn=1:length(studyspecs.codes)
        files=dir(fullfile(datpath,[studyspecs.codes{nnn} '*.xlsx']));
        if length(files)>=1
            dat(iii)=importdata(fullfile(datpath,files(1).name));
            yrstart=dat(iii).data.Sheet1(2:end,6);
            yrend2100=dat(iii).data.Sheet1(2:end,8);
            qlevs{iii}=dat(iii).data.Sheet1(2:end,1);
            qvals2050{iii}=dat(iii).data.Sheet1(2:end,2);
            qvals2100{iii}=dat(iii).data.Sheet1(2:end,3);
            qvals2050{iii}=qvals2050{iii}-(baseyear-yrstart)*histrate;
            qvals2100{iii}=qvals2100{iii}-(baseyear-yrstart)*histrate;
            qvals2100{iii}=qvals2100{iii}.*((2100-baseyear)./(yrend2100-baseyear));
            study{iii}=studyspecs.codes{nnn};
            studyidx(iii)=nnn;
            studycolor(iii,:)=studyspecs.colors(studyidx(iii),:);
            studyline{iii}=studyspecs.linespec{studyidx(iii)}; 
            linespecs(iii).color=studycolor(iii,:);
            linespecs(iii).linestyle=studyline{iii};
            conflevs(iii)=studyspecs.conflev(studyidx(iii));
            iii=iii+1;
        end
    end

    subplot(1,100,1:36)
  
    [uconflevs,uconflevsi] = unique(conflevs);

    for jjj=1:length(uconflevs)
        yval=iiii2050+jjj;
        if (yval>1 && yval<8)
            yval_temp = yval-1;
        elseif (yval>9 && yval<15)
            yval_temp = yval-2;
        elseif yval>16
            yval_temp = yval-3;
        else
            yval_temp=1;
        end
        if uconflevs(jjj)==2
            studylabs2050{yval_temp}='MED';
            docolor=rcp_color;
        elseif uconflevs(jjj)==5
            studylabs2050{yval_temp}='Survey';
            docolor=.3*rcp_color+.7*[1 1 1];
        elseif uconflevs(jjj)==4
            studylabs2050{yval_temp}='SEJ';
            docolor=.3*rcp_color+.7*[1 1 1];
        elseif uconflevs(jjj)==3
            studylabs2050{yval_temp}='MICI';
            docolor=.3*rcp_color+.7*[1 1 1];
        end

        sub=find(conflevs==uconflevs(jjj));
        
        for iii=sub
                
            % 5th-95th percentile
            done=0;
            qdo=[.05 .95];
            if (min(abs(qlevs{iii}-qdo(1)))<=.01) && (min(abs(qlevs{iii}-qdo(2)))<=.01)
                qdovals=interp1(qlevs{iii},qvals2050{iii},qdo);
                if ~isnan(sum(qdovals))
                    plot(qdovals,[yval_temp yval_temp],'-','Color',docolor,'linewidth',2); hold on;
                    done=1;
                end
            end
            qdo=[.17 .83];
            if (min(abs(qlevs{iii}-qdo(1)))<=.01) && (min(abs(qlevs{iii}-qdo(2)))<=.01)
                qdovals=interp1(qlevs{iii},qvals2050{iii},qdo);
                if ~isnan(sum(qdovals))
                    plot(qdovals,[yval_temp yval_temp],'-','Color',docolor,'LineWidth',8); hold on;
                done=1;
                end
            end

        end
    end
    iiii2050=iiii2050+length(uconflevs)+1;
    yval=iiii2050;
    if (yval>1 && yval<8)
        yval_temp = yval-1;
    elseif (yval>9 && yval<15)
        yval_temp = yval-2;
    elseif yval>16
        yval_temp = yval-3;
    else
        yval_temp=1;
    end
    studylabs2050{yval_temp}='AR5';
    plot(AR5lev2050(qqq,:),[yval_temp yval_temp],'Color',rcp_color,'LineWidth',8);
    iiii2050=iiii2050+1;

    yval=iiii2050;
    if (yval>1 && yval<8)
        yval_temp = yval-1;
    elseif (yval>9 && yval<15)
        yval_temp = yval-2;
    elseif yval>16
        yval_temp = yval-3;
    else
        yval_temp=1;
    end
    studylabs2050{yval_temp}='SROCC';
    plot(SROCClev2050(qqq,:),[yval_temp yval_temp],'Color',rcp_color,'LineWidth',8);
    iiii2050=iiii2050+1;
    yval=iiii2050;
    if (yval>1 && yval<8)
        yval_temp = yval-1;
    elseif (yval>9 && yval<15)
        yval_temp = yval-2;
    elseif yval>16
        yval_temp = yval-3;
    else
        yval_temp=1;
    end
    studylabs2050{yval_temp}='AR6';
    plot(AR6levHE2050_95(qqq,:),[yval_temp yval_temp],'Color',.3*ssp_color+.7*[1 1 1],'LineWidth',2);
    plot(AR6levHE2050(qqq,:),[yval_temp yval_temp],'Color',.3*ssp_color+.7*[1 1 1],'LineWidth',8);
    plot(AR6lev2050(qqq,:),[yval_temp yval_temp],'Color',ssp_color,'LineWidth',8);
    set(gca,'yticklabel',studylabs2050,'ytick',1:iiii2050)
    ylim([0 iiii2050+0.9-3]);
    iiii2050=iiii2050+1;
    xlim([0 0.6])
    plot([0 2.5], [7 7],'k','LineWidth',2)
    plot([0 2.5], [13 13],'k','LineWidth',2)
    if lll==3
        patch_object = patch([0 2.5 2.5 0 0],[3.8 3.8 4.2 4.2 3.8]-1,'y', ...
            'FaceColor','none');
        hatchfill2(patch_object)
        patch_object = patch([0 2.5 2.5 0 0],[19.8 19.8 20.2 20.2 19.8]-3,'y', ...
            'FaceColor','none');
        hatchfill2(patch_object)
    end
    xlabel('(m)')

    iiii2050=iiii2050+1;
    
     set(gca,'FontSize',16)
     title('2050 GMSL Projections','fontsize',22);
     
%      rcp_color=IPCC_Get_SSPColors('rcp85')
%      ssp_color=IPCC_Get_SSPColors('ssp585')
%      rcp_color=IPCC_Get_SSPColors('rcp45')
%      ssp_color=IPCC_Get_SSPColors('ssp245')
%      rcp_color=IPCC_Get_SSPColors('rcp26')
%      ssp_color=IPCC_Get_SSPColors('ssp126')
     txt = "\color[rgb]{0.6 0 0.0078}RCP 8.5\color{black}/\color[rgb]{0.5176 0.0431 0.1333}SSP5-8.5";
     text(0.34,18,txt,'FontSize',16, 'FontWeight', 'bold','interpreter','tex')
     txt = "\color[rgb]{0.4392 0.6275 0.8039}RCP 4.5\color{black}/\color[rgb]{0.9176 0.8667 0.2392}SSP2-4.5";
     text(0.34,10,txt,'FontSize',16, 'FontWeight', 'bold')
     txt = "\color[rgb]{0 0.2039 0.4000}RCP 2.6\color{black}/\color[rgb]{0.1137 0.2000 0.3294}SSP1-2.6";
     text(0.34,4.5,txt,'FontSize',16, 'FontWeight', 'bold')


    subplot(1,100,40:100) 

    for jjj=1:length(uconflevs)
        yval=iiii2100+jjj;
        if (yval>1 && yval<8)
        yval_temp = yval-1;
    elseif (yval>9 && yval<15)
        yval_temp = yval-2;
    elseif yval>16
        yval_temp = yval-3;
    else
        yval_temp=1;
    end
        if uconflevs(jjj)==2
            studylabs2100{yval}='MED';
            docolor=rcp_color;
        elseif uconflevs(jjj)==5
            studylabs2100{yval}='Survey';
            docolor=.3*rcp_color+.7*[1 1 1];
        elseif uconflevs(jjj)==4
            studylabs2100{yval}='SEJ';
            docolor=.3*rcp_color+.7*[1 1 1];
        elseif uconflevs(jjj)==3
            studylabs2100{yval}='MICI';
            docolor=.3*rcp_color+.7*[1 1 1];
        end

        sub=find(conflevs==uconflevs(jjj));
        for iii=sub
        % 5th-95th percentile
        done=0;
        qdo=[.05 .95];
        if (min(abs(qlevs{iii}-qdo(1)))<=.01) && (min(abs(qlevs{iii}-qdo(2)))<=.01)
            qdovals=interp1(qlevs{iii},qvals2100{iii},qdo);
            if ~isnan(sum(qdovals))
                plot(qdovals,[yval_temp yval_temp],'-','Color',docolor,'linewidth',2); hold on;
                done=1;
            end
        end
        qdo=[.17 .83];
        if (min(abs(qlevs{iii}-qdo(1)))<=.01) && (min(abs(qlevs{iii}-qdo(2)))<=.01)
            qdovals=interp1(qlevs{iii},qvals2100{iii},qdo);
            if ~isnan(sum(qdovals))
                plot(qdovals,[yval_temp yval_temp],'-','Color',docolor,'LineWidth',8); hold on;
               done=1;
            end
        end
      end
    end
    iiii2100=iiii2100+length(uconflevs)+1;
    yval=iiii2100;
    if (yval>1 && yval<8)
        yval_temp = yval-1;
    elseif (yval>9 && yval<15)
        yval_temp = yval-2;
    elseif yval>16
        yval_temp = yval-3;
    else
        yval_temp=1;
    end
    studylabs2100{yval}='AR5';
    plot(AR5lev(qqq,:),[yval_temp yval_temp],'Color',rcp_color,'LineWidth',8);
    iiii2100=iiii2100+1;

    yval=iiii2100;
    if (yval>1 && yval<8)
        yval_temp = yval-1;
    elseif (yval>9 && yval<15)
        yval_temp = yval-2;
    elseif yval>16
        yval_temp = yval-3;
    else
        yval_temp=1;
    end
    studylabs2100{yval}='SROCC';
    plot(SROCClev(qqq,:),[yval_temp yval_temp],'Color',rcp_color,'LineWidth',8);
    iiii2100=iiii2100+1;
    yval=iiii2100;
    if (yval>1 && yval<8)
        yval_temp = yval-1;
    elseif (yval>9 && yval<15)
        yval_temp = yval-2;
    elseif yval>16
        yval_temp = yval-3;
    else
        yval_temp=1;
    end
    studylabs2100{yval}='AR6';
    if lll==1
        thinline=plot(AR6levHE_95(qqq,:),[yval_temp yval_temp],'Color',.3*ssp_color+.7*[1 1 1],'LineWidth',2);
        thickline=plot(AR6levHE(qqq,:),[yval_temp yval_temp],'Color',.3*ssp_color+.7*[1 1 1],'LineWidth',8);
        darkline=plot(AR6lev(qqq,:),[yval_temp yval_temp],'Color',ssp_color,'LineWidth',8);
        thindarkline=plot(AR6lev(qqq,:),[yval_temp yval_temp],'Color',ssp_color,'LineWidth',2);
    else
        plot(AR6levHE_95(qqq,:),[yval_temp yval_temp],'Color',.3*ssp_color+.7*[1 1 1],'LineWidth',2);
        plot(AR6levHE(qqq,:),[yval_temp yval_temp],'Color',.3*ssp_color+.7*[1 1 1],'LineWidth',8);
        plot(AR6lev(qqq,:),[yval_temp yval_temp],'Color',ssp_color,'LineWidth',8);
        plot(AR6lev(qqq,:),[yval_temp yval_temp],'Color',ssp_color,'LineWidth',2);
    end
%     set(gca,'yticklabel',studylabs2100,'ytick',1:iiii2100)
    set(gca,'yticklabels',{},'ytick',1:iiii2100)
    ylim([0 iiii2100+0.9-3]);
    iiii2100=iiii2100+1;
    plot([0 2.5], [7 7],'k','LineWidth',2)
    plot([0 2.5], [13 13],'k','LineWidth',2)
    xlim([0 2.5])
      xlabel('(m)')
    
    set(gca,'FontSize',18)
    
    title('2100 GMSL Projections','fontsize',22);

    iiii2100=iiii2100+1;
end
legend([darkline thindarkline thickline thinline], '17^{th}-83^{rd} percentile', ...
    '5^{th}-95^{th} percentile','17^{th}-83^{rd} (low confidence; see caption)', ...
    '5^{th}-95^{th} (low confidence)','Box','on' ...
    ,'Position',[0.7 0.2 0.1 0.1],'FontSize',14)

%pdfwrite('SLRdists')
savefig('SLRdists.fig')
print(gcf,'../PNGs/New_Fig9_25_SLR_PDFs.png','-dpng','-r1000', '-painters');
%close(1)


