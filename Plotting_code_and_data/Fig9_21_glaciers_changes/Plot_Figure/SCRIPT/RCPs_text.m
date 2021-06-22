for k = 1:1:length(regions_numbers);
        
      j =k; % to be used if the orde
      display([cell2mat(regionnames(j)),'(',cell2mat(regions_numbers(j)),')']) 
     display(['RCP 2.6 = ',num2str((1-median_RCP26(j,end))*100,2),...
         ' +/- ',num2str(CI_RCP26(j,end).*100,2)])
    display(['RCP 4.5 = ',num2str((1-median_RCP45(j,end))*100,2),...
         ' +/- ',num2str(CI_RCP45(j,end).*100,2)])
    display(['RCP 8.5 = ',num2str((1-median_RCP85(j,end))*100,2),...
         ' +/- ',num2str(CI_RCP85(j,end).*100,2)])
     display('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
end

%% Load and format median and ci data provided by Ben Marzeion

% Load files
median_RCP26_m = load('c:\Users\lcsru\OneDrive\Documents\IPCC-AR6\09-FGD\Chapter9_Relative_glacier_mass_figure\INPUT_DATA\Median_and_CI_values_GLACIERMIP2\glaciermip2_regional_median_rcp26.txt');
ci_RCP26_m = load('c:\Users\lcsru\OneDrive\Documents\IPCC-AR6\09-FGD\Chapter9_Relative_glacier_mass_figure\INPUT_DATA\Median_and_CI_values_GLACIERMIP2\glaciermip2_regional_ci_rcp26.txt');

median_RCP45_m = load('c:\Users\lcsru\OneDrive\Documents\IPCC-AR6\09-FGD\Chapter9_Relative_glacier_mass_figure\INPUT_DATA\Median_and_CI_values_GLACIERMIP2\glaciermip2_regional_median_rcp45.txt');
ci_RCP45_m = load('c:\Users\lcsru\OneDrive\Documents\IPCC-AR6\09-FGD\Chapter9_Relative_glacier_mass_figure\INPUT_DATA\Median_and_CI_values_GLACIERMIP2\glaciermip2_regional_ci_rcp45.txt');

median_RCP85_m = load('c:\Users\lcsru\OneDrive\Documents\IPCC-AR6\09-FGD\Chapter9_Relative_glacier_mass_figure\INPUT_DATA\Median_and_CI_values_GLACIERMIP2\glaciermip2_regional_median_rcp85.txt');
ci_RCP85_m = load('c:\Users\lcsru\OneDrive\Documents\IPCC-AR6\09-FGD\Chapter9_Relative_glacier_mass_figure\INPUT_DATA\Median_and_CI_values_GLACIERMIP2\glaciermip2_regional_median_rcp85.txt');

%%

 for j =1:1:length(regions_short);
      m = regions_short(j);
      if m<13;
      median_rcp26_diff(j,:) = median_RCP26_m(:,m)'-(((global_RCP26(j,:))-median_RCP26_initial_mass(j,1))./362.5);
      median_rcp45_diff(j,:) = median_RCP45_m(:,m)'-(((global_RCP45(j,:))-median_RCP45_initial_mass(j,1))./362.5);
      median_rcp85_diff(j,:) = median_RCP85_m(:,m)'-(((global_RCP85(j,:))-median_RCP85_initial_mass(j,1))./362.5);
      
      ci_rcp26_diff(j,:) = ci_RCP26_m(:,m)'-((global_RCP26_err(j,:))./362.5);
      ci_rcp45_diff(j,:) = ci_RCP45_m(:,m)'-((global_RCP45_err(j,:))./362.5);
      ci_rcp85_diff(j,:) = ci_RCP85_m(:,m)'-((global_RCP85_err(j,:))./362.5);
      
      elseif m==13;
      median_rcp26_diff(j,:) = sum(median_RCP26_m(:,HMA),2)'-(((global_RCP26(j,:))-median_RCP26_initial_mass(j,1))./362.5);
      median_rcp45_diff(j,:) = sum(median_RCP45_m(:,HMA),2)'-(((global_RCP45(j,:))-median_RCP45_initial_mass(j,1))./362.5);
      median_rcp85_diff(j,:) = sum(median_RCP85_m(:,HMA),2)'-(((global_RCP85(j,:))-median_RCP85_initial_mass(j,1))./362.5);
      
      ci_rcp26_diff(j,:) = sqrt(sum(median_RCP26_m(:,HMA).^2,2))'-((global_RCP26_err(j,:))./362.5);
      ci_rcp45_diff(j,:) = sqrt(sum(median_RCP45_m(:,HMA).^2,2))'-((global_RCP45_err(j,:))./362.5);
      ci_rcp85_diff(j,:) = sqrt(sum(median_RCP85_m(:,HMA).^2,2))'-((global_RCP85_err(j,:))./362.5);
           
      elseif m>=16 && m<=19;
      median_rcp26_diff(j,:) = median_RCP26_m(:,m)'-(((global_RCP26(j,:))-median_RCP26_initial_mass(j,1))./362.5);
      median_rcp45_diff(j,:) = median_RCP45_m(:,m)'-(((global_RCP45(j,:))-median_RCP45_initial_mass(j,1))./362.5);
      median_rcp85_diff(j,:) = median_RCP85_m(:,m)'-(((global_RCP85(j,:))-median_RCP85_initial_mass(j,1))./362.5);
      
      ci_rcp26_diff(j,:) = ci_RCP26_m(:,m)'-((global_RCP26_err(j,:))./362.5);
      ci_rcp45_diff(j,:) = ci_RCP45_m(:,m)'-((global_RCP45_err(j,:))./362.5);
      ci_rcp85_diff(j,:) = ci_RCP85_m(:,m)'-((global_RCP85_err(j,:))./362.5);
      end
 end
           
 %%     

figure(1)

subplot(3,1,1)
plot([0,19],[0,0],'k')
hold on
boxplot(median_rcp26_diff')

set(gca,'FontSize',6,'XTick',[1:1:17],'XTickLabel',...
          regionnames(3:end),'XLim', [0 19])
 set(gca,'FontSize',6,'YTick',[-2:0.5:2],'YLim', [-2.1 2.1])
ylabel(' mm sle','FontSize',8,'FontWeight','Bold') 
xlabel('Region','FontSize',8,'FontWeight','Bold')  
title('Median RCP 2.6')

 subplot(3,1,2)
 plot([0,19],[0,0],'k')
hold on
 boxplot(median_rcp45_diff')
set(gca,'FontSize',6,'XTick',[1:1:17],'XTickLabel',...
          regionnames(3:end),'XLim', [0 19])
 set(gca,'FontSize',6,'YTick',[-2:0.5:2],'YLim', [-2.1 2.1])
ylabel(' mm sle','FontSize',8,'FontWeight','Bold') 
xlabel('Region','FontSize',8,'FontWeight','Bold')  
title('Median RCP 4.5 difference')
 
 subplot(3,1,3)
 plot([0,19],[0,0],'k')
hold on
 boxplot(median_rcp85_diff')
 set(gca,'FontSize',6,'XTick',[1:1:17],'XTickLabel',...
          regionnames(3:end),'XLim', [0 19])
 set(gca,'FontSize',6,'YTick',[-2:0.5:2],'YLim', [-2.1 2.1])
ylabel(' mm sle','FontSize',8,'FontWeight','Bold') 
xlabel('Region','FontSize',8,'FontWeight','Bold')  
title('Median RCP 8.5 difference')
 
%%

figure(2)

subplot(3,1,1)
plot([0,19],[0,0],'k')
hold on
boxplot(ci_rcp26_diff')

set(gca,'FontSize',6,'XTick',[1:1:17],'XTickLabel',...
          regionnames(3:end),'XLim', [0 19])
 set(gca,'FontSize',6,'YTick',[-4:0.5:4],'YLim', [-4.1 4.1])
ylabel(' mm sle','FontSize',8,'FontWeight','Bold') 
xlabel('Region','FontSize',8,'FontWeight','Bold')  
title('CI RCP 2.6 difference')

 subplot(3,1,2)
 plot([0,19],[0,0],'k')
hold on
 boxplot(ci_rcp45_diff')
set(gca,'FontSize',6,'XTick',[1:1:17],'XTickLabel',...
          regionnames(3:end),'XLim', [0 19])
 set(gca,'FontSize',6,'YTick',[-4:0.5:4],'YLim', [-4.1 4.1])
ylabel(' mm sle','FontSize',8,'FontWeight','Bold') 
xlabel('Region','FontSize',8,'FontWeight','Bold')  
title('CI RCP 4.5 difference')
 
 subplot(3,1,3)
 plot([0,19],[0,0],'k')
hold on
 boxplot(ci_rcp85_diff')
 set(gca,'FontSize',6,'XTick',[1:1:17],'XTickLabel',...
          regionnames(3:end),'XLim', [0 19])
 set(gca,'FontSize',6,'YTick',[-4:0.5:4],'YLim', [-4.1 4.1])
ylabel(' mm sle','FontSize',8,'FontWeight','Bold') 
xlabel('Region','FontSize',8,'FontWeight','Bold')  
title('CI RCP 8.5 difference')
 




