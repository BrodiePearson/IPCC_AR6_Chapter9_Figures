% This file makes fig 9.1b, the map figure.

close all

addpath ../../Matlab_Functions/

% Ocean Speed -1 0
OSmin=-1;
OSmax=-0;
% Glaciers=0-1
GLmin=0;
GLmax=1;
% Permafrost=0.5
PF=1.5;
% Sea Ice=2:3
SImin=2;
SImax=3;
% Snow=3:4
SWmin=3;
SWmax=4;
% Ice Sheets=4-5
ISmin=4.5;
ISmax=5;

%Total range
% 1/6 ocean, 5/6 Cryosphere

speed=IPCC_Get_Colorbar('wind_d');
speed=speed([1:64 (64+16+128):end],:);

x=linspace(0,1,length(speed(:,1)));

sped2=zeros(40,3);
sped2(:,1)=interp1(x,speed(:,1),linspace(0,1,40));
sped2(:,2)=interp1(x,speed(:,2),linspace(0,1,40));
sped2(:,3)=interp1(x,speed(:,3),linspace(0,1,40));

% Glaciers
%glacc=IPCC_Get_Colorbar('cryo_nd');
%glacc=glacc(1:100,:);
glacc=[221 79 97;245 119 42]/255;
x=linspace(0,1,length(glacc(:,1)));
glac2=zeros(40,3);
glac2(:,1)=interp1(x,glacc(:,1),linspace(0,1,40));
glac2(:,2)=interp1(x,glacc(:,2),linspace(0,1,40));
glac2(:,3)=interp1(x,glacc(:,3),linspace(0,1,40));

%Permafrost
%permc=IPCC_Get_Colorbar('wind_nd');
%permc=[233, 222, 202;233, 222, 202]./255;  %Prev. 78 188 249
%permc=[78 188 249;78 188 249]./255;  %Prev. 78 188 249
permc=[0.5020    0.6980    0.7608;0.5020    0.6980    0.7608];  %Prev. 78 188 249
%permc=[0.8431    0.8431    0.6902;0.8431    0.8431    0.6902];
x=linspace(0,1,length(permc(:,1)));
perm2=zeros(40,3);
perm2(:,1)=interp1(x,permc(:,1),linspace(0,1,40));
perm2(:,2)=interp1(x,permc(:,2),linspace(0,1,40));
perm2(:,3)=interp1(x,permc(:,3),linspace(0,1,40));

%Sea Ice
cryoc=IPCC_Get_Colorbar('cryo_d');
cryoc=cryoc((end-90):-1:80,:);
cryoc=cryoc(1:end/3,:);

x=linspace(0,1,length(cryoc(:,1)));

cryo2=zeros(40,3);
cryo2(:,1)=interp1(x,cryoc(:,1),linspace(0,1,40));
cryo2(:,2)=interp1(x,cryoc(:,2),linspace(0,1,40));
cryo2(:,3)=interp1(x,cryoc(:,3),linspace(0,1,40));

%Snow
cryoc=IPCC_Get_Colorbar('cryo_d');
cryoc=cryoc((end-110):-1:110,:);
cryoc=[230 230 230;180 180 180]/255;

x=linspace(0,1,length(cryoc(:,1)));

cryo3=zeros(40,3);
cryo3(:,1)=interp1(x,cryoc(:,1),linspace(0,1,40));
cryo3(:,2)=interp1(x,cryoc(:,2),linspace(0,1,40));
cryo3(:,3)=interp1(x,cryoc(:,3),linspace(0,1,40));

%Ice Sheet
cryoc=IPCC_Get_Colorbar('cryo_d');
cryoc=cryoc((end-110):-1:110,:);
cryoc=cryoc((end/2-1):(end/2),:);
cryoc=[1 1 1;1 1 1];

x=linspace(0,1,length(cryoc(:,1)));

cryo4=zeros(40,3);
cryo4(:,1)=interp1(x,cryoc(:,1),linspace(0,1,40));
cryo4(:,2)=interp1(x,cryoc(:,2),linspace(0,1,40));
cryo4(:,3)=interp1(x,cryoc(:,3),linspace(0,1,40));


cm=[sped2;glac2;perm2;cryo2;cryo3;cryo4];

%unix('rm *.mat')

if ~isfile('Data/oscar.mat')

% OSCAR 1993-2018 average velocities
% ESR. 2009. OSCAR third degree resolution ocean surface currents. Ver. 1. PO.DAAC, CA, USA. Dataset accessed [YYYY-MM-DD] at https://doi.org/10.5067/OSCAR-03D01.
% Bonjean, F., and G. S. E. Lagerloef, 2002. Diagnostic model and analysis of the surface currents in the tropical Pacific Ocean. J. Phys. Oceanogr., vol. 32, pg. 2938-2954.

fname='Data/netcdfs/avg.oscar_vel1993-2018.nc';
readncfile

oscar=log10(0.5*(um.^2+vm.^2))/4*(OSmax-OSmin);  %range from -1 to 0 (roughly)).
oscar(oscar<-1)=-1;
[oscarlat,oscarlon]=meshgrid(latitude(:),wrapTo180(longitude(:)));
[toteslat,toteslon]=meshgrid([latitude(2:30)+10;latitude(:);latitude(end-29:end-1)-10],wrapTo180(longitude(:)));
oscar=griddata(double(oscarlat(:)),double(oscarlon(:)),double(oscar(:)),toteslat(:),toteslon(:),'nearest');
oscar=reshape(oscar,size(toteslat));

fname='Data/netcdfs/etopo20.nc';
readncfile

[latitude,longitude]=meshgrid(ETOPO20Y,wrapTo180(ETOPO20XN59_1021));
z=griddata(double(latitude(:)),double(longitude(:)),double(ROSE(:)),toteslat(:),toteslon(:),'nearest');
z=reshape(z,size(toteslat));

oscar(isnan(oscar)&(z<0))=-1;  % This is cheating, should really use model or other estimate

IPCC_Plot_Mesh2(oscar,toteslat,toteslon,[-1 5], cm, 'Oscar',1);

save Data/oscar.mat oscar toteslat toteslon
else
    load Data/oscar.mat
end

% unix('rm perma.mat')

if ~isfile('Data/perma.mat')

% Gerhard Permafrost Map
fname='Data/netcdfs/llipa_masks.nc';
readncfile
% 

perma=double((continuous_permafrost+discontinuous_permafrost+isolated_permafrost+sporadic_permafrost)>0);   
perma=double((continuous_permafrost+discontinuous_permafrost)>0);   

perma(perma==0)=nan;
[permalat,permalon]=meshgrid(latitude(:),wrapTo180(longitude(:)));

perma=griddata(double(permalat(:)),double(permalon(:)),double(perma(:)),toteslat(:),toteslon(:),'nearest');

% Here is where the permafrost color is set to PF;
perma(perma>0.99&perma<1.01)=PF;
perma=reshape(perma,size(toteslat));

IPCC_Plot_Mesh2(perma,toteslat,toteslon,[-1 5], cm, 'Permafrost',2);

save Data/perma.mat perma toteslat toteslon
else
    load Data/perma.mat
end

% unix('rm snow.mat')

if ~isfile('Data/snow.mat')

% SWE Data: 
% Brodzik, M. J., R. Armstrong, and M. Savoie. 2007. Global EASE-Grid 8-day Blended SSM/I and MODIS Snow Cover, Version 1. [Indicate subset used]. Boulder, Colorado USA. NASA National Snow and Ice Data Center Distributed Active Archive Center. doi: https://doi.org/10.5067/KIGGFNVROX9V. [Date Accessed].

fname='Data/netcdfs/NL.avg.nc';
readncfile

SWE(SWE==0)=nan;
SWE(SWE>0)=SWmin+(SWmax-SWmin)*(SWE(SWE>0)-min(SWE(SWE>0)))./(max(SWE(SWE>0))-min(SWE(SWE>0)));
SWE(SWE==-300)=4.5;  %ICE SHEETS
SWE(SWE<0)=nan;

latituden=latitude(~isnan(longitude));
SWEN=double(SWE(~isnan(longitude)));
longituden=wrapTo180(longitude(~isnan(longitude)));

ISEN=nan*SWEN;
ISEN(SWEN>4)=SWEN(SWEN>4);
SWEN(SWEN>4)=nan;

swen = griddata(latituden(:),longituden(:),SWEN(:),toteslat(:),toteslon(:),'nearest');
swen = reshape(swen,size(toteslat));

isn = griddata(latituden(:),longituden(:),ISEN(:),toteslat(:),toteslon(:),'nearest');
isn = reshape(isn,size(toteslat));

fname='Data/netcdfs/SL.avg.nc';
readncfile

SWE(SWE==0)=nan;
SWE(SWE>0)=SWmin+(SWmax-SWmin)*(SWE(SWE>0)-min(SWE(SWE>0)))./(max(SWE(SWE>0))-min(SWE(SWE>0)));
SWE(SWE==-300)=4.5;  %ICE SHEETS
SWE(SWE<0)=nan;

latitude=latitude(~isnan(longitude));
SWE=double(SWE(~isnan(longitude)));
longitude=wrapTo180(longitude(~isnan(longitude)));

ISE=nan*SWE;
ISE(SWE>4)=SWE(SWE>4);
SWE(SWE>4)=nan;

swe = griddata(latitude,longitude,SWE,toteslat(:),toteslon(:),'nearest');
swe = reshape(swe,size(toteslat));

swe(~isnan(swen))=swen(~isnan(swen));

is = griddata(latitude(:),longitude(:),ISE(:),toteslat(:),toteslon(:),'nearest');
is = reshape(is,size(toteslat));

is(~isnan(isn))=isn(~isnan(isn));

[y,x]=meshgrid(-89:.15:89,-180:.15:180);

is2 = griddata(toteslat(:),toteslon(:),is(:),y,x,'linear');

is = griddata(y(:),x(:),is2(:),toteslat(:),toteslon(:),'linear');
is = reshape(is,size(toteslat));

 
IPCC_Plot_Mesh2(is,toteslat,toteslon,[-1 5], cm, 'Ice Sheets and Snow',3);
IPCC_Plot_Mesh2(swe,toteslat,toteslon,[-1 5], cm, 'Ice Sheets and Snow',4);

drawnow
snow=nan*swe;
%snow(~isnan(swe))=swe(~isnan(swe));
snow(~isnan(swen))=swen(~isnan(swen));

save Data/snow.mat snow toteslat toteslon swe swen is isn

else 
    load Data/snow.mat
end

%unix('rm seaice.mat')

if ~isfile('Data/seaice.mat')
    
% Seaice Data: average from 1979-2018, 2-3
% Meier, W. N., F. Fetterer, M. Savoie, S. Mallory, R. Duerr, and J. Stroeve. 2017. NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration, Version 3. [Indicate subset used]. Boulder, Colorado USA. NSIDC: National Snow and Ice Data Center. doi: https://doi.org/10.7265/N59P2ZTG. [Date Accessed].
% Peng, G., W. N. Meier, D. Scott, and M. Savoie. 2013. A long-term and reproducible passive microwave sea ice concentration data record for climate studies and monitoring, Earth Syst. Sci. Data. 5. 311-318. https://doi.org/10.5194/essd-5-311-2013

fname='Data/netcdfs/seaice_conc_monthly_nh.nc';
readncfile

cutoff=0.001;

seaice_nh0=seaice_conc_monthly_cdr;
latnh=latitude;
lonnh=wrapTo180(longitude);

seaice_nh0(seaice_nh0<=cutoff)=nan;

seaice_nh=griddata(double(latnh(:)),double(lonnh(:)),seaice_nh0(:),toteslat(:),toteslon(:),'linear');
seaice_nh=reshape(seaice_nh,size(toteslat));

fname='Data/netcdfs/seaice_conc_monthly_sh.nc';
readncfile

seaice_sh0=seaice_conc_monthly_cdr;
latsh=latitude;
lonsh=wrapTo180(longitude);

seaice_sh0(seaice_sh0<=cutoff)=nan;

seaice_sh=griddata(double(latsh(:)),double(lonsh(:)),seaice_sh0(:),toteslat(:),toteslon(:),'linear');
seaice_sh=reshape(seaice_sh,size(toteslat));

seaice=nan*toteslat;
seaice(~isnan(seaice_nh))=seaice_nh(~isnan(seaice_nh));
seaice(~isnan(seaice_sh))=seaice_sh(~isnan(seaice_sh));

seaice_nh=SImin+(SImax-SImin)*(seaice_nh-min(seaice(:)))./(max(seaice(:))-min(seaice(:)));
seaice_sh=SImin+(SImax-SImin)*(seaice_sh-min(seaice(:)))./(max(seaice(:))-min(seaice(:)));
seaice=SImin+(SImax-SImin)*(seaice-min(seaice(:)))./(max(seaice(:))-min(seaice(:)));

IPCC_Plot_Mesh2(seaice_nh,toteslat,toteslon,[-1 5], cm, 'Sea Ice',5);
IPCC_Plot_Mesh2(seaice_sh,toteslat,toteslon,[-1 5], cm, 'Sea Ice',6);

save Data/seaice.mat seaice seaice_sh seaice_nh toteslat toteslon

else
   load Data/seaice.mat 
end

if ~isfile('Data/glaciers.mat')
    
% Glacier Data:
% Randolf Glacier Inventory

fname='Data/netcdfs/glaciers.nc';
readncfile

S=shaperead('Data/GlacReg_2017/GTN-G_glacier_regions_201707.shp')

glaciers=z;
[lat,lon]=meshgrid(y,x);

glaciers(glaciers==0)=nan;

glaciers=GLmin+(GLmax-GLmin)*(glaciers-min(glaciers(:)))./(max(glaciers(:))-min(glaciers(:)));

glac(:)=griddata(lat(:),lon(:),glaciers(:),toteslat(:),toteslon(:),'nearest');

glac=reshape(glac,size(toteslat));

save Data/glaciers.mat glac toteslat toteslon S

IPCC_Plot_Mesh2(glac,toteslat,toteslon,[-1 5], cm, 'Glaciers',7);

else
   load Data/glaciers.mat 
end

unix('rm Data/totes.mat')

if ~isfile('Data/totes.mat')

totes=nan*toteslat;
totes(~isnan(oscar))=oscar(~isnan(oscar));
totes(~isnan(perma))=perma(~isnan(perma));  % 2
totes(~isnan(seaice))=seaice(~isnan(seaice)); % 2 to 3
totes(~isnan(snow))=snow(~isnan(snow)); % 3 to 4 
totes(~isnan(glac))=glac(~isnan(glac)); % 0 to 1
totes(~isnan(is))=is(~isnan(is)); % 4.5

save Data/totes.mat toteslat toteslon totes oscar snow perma
else 
    load Data/totes.mat
end

%IPCC_Plot_Mesh(totes,toteslat,toteslon,[-1 5], cm, 'The Ocean and Cryosphere',10);
IPCC_Plot_Mesh2(totes,toteslat,toteslon,[-1 5], cm, [],10,15,0,'',perma>0);

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 10 6];

for ff=[1]
 figure(ff)
 for gg=[1 3:10 12:21]
  ll=mean(S(gg).BoundingBox)
  if gg==1
      ll(1)=ll(1)-1; % move region 1 to uncluttered place
      ll(2)=ll(2)-5; % move region 1 to uncluttered place
  elseif S(gg).RGI_CODE>11&S(gg).RGI_CODE<16
      ll(2)=ll(2)-5; % move region to uncluttered place
  end
  if S(gg).RGI_CODE==13
      ll(2)=ll(2)+10; % move region to uncluttered place
  end
  if S(gg).RGI_CODE==16
      ll(1)=-75; % move region to representative place
  end
  if S(gg).RGI_CODE==18
      ll(1)=ll(1)-13; % move region to uncluttered place
  end
  
  if S(gg).RGI_CODE==19
      ll(1)=ll(1)-55; % move region to representative place
  end
  textm(ll(2),ll(1),num2str(S(gg).RGI_CODE),'fontweight','bold','color',[245 119 42]/255, 'fontsize',14,'verticalalignment','middle','backgroundcolor','none')
 end
end


print('../PNGs/OceanCryo1','-dpng','-r1000', '-painters')

%IPCC_Plot_Polar(totes,toteslat,toteslon,[-1 5], cm, 'The Ocean and Cryosphere',11,1,15,0);
IPCC_Plot_Polar2(totes,toteslat,toteslon,[-1 5], cm, [],11,1,15,0,'',perma>0);

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 10 6];

for ff=[2]
 figure(ff)
 for gg=[1 3:10 12:21]
  ll=mean(S(gg).BoundingBox)
  if gg==1
      ll(1)=ll(1)-1; % move region 1 to uncluttered place
      ll(2)=ll(2)+1; % move region 1 to uncluttered place
  end
  if S(gg).RGI_CODE==3
      ll(1)=ll(1)-10; % move region to uncluttered place
  end

  textm(ll(2),ll(1),num2str(S(gg).RGI_CODE),'fontweight','bold','color',[245 119 42]/255, 'fontsize',14,'verticalalignment','middle','backgroundcolor','white')
 end
end


print('../PNGs/OceanCryo2','-dpng','-r1000', '-painters')

%IPCC_Plot_Polar(totes,toteslat,toteslon,[-1 5], cm, 'The Ocean and Cryosphere',12,-1,15,0);
IPCC_Plot_Polar2(totes,toteslat,toteslon,[-1 5], cm, [],12,-1,15,0,'',perma>0);

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 10 6];

for ff=[3]
 figure(ff)
 for gg=[1 3:10 12:21]
  ll=mean(S(gg).BoundingBox)
  if gg==1
      ll(1)=ll(1)-1; % move region 1 to uncluttered place
      ll(2)=ll(2)+1; % move region 1 to uncluttered place
  end
  if S(gg).RGI_CODE==17
      ll(1)=ll(1)+3; % move region to representative place
  end
  if S(gg).RGI_CODE==19
      ll(1)=ll(1)-55; % move region to representative place
  end
  textm(ll(2),ll(1),num2str(S(gg).RGI_CODE),'fontweight','bold','color',[245 119 42]/255, 'fontsize',14,'verticalalignment','middle','backgroundcolor','none')
 end
end

print('../PNGs/OceanCryo3','-dpng','-r1000', '-painters')

h=colorbar;
set(h,'Ticks',[-0.5 0.5 1.5 2.5 3.5 4.5])

set(h,'TickLabels',{'Ocean (Speed)','Glaciers','Permafrost','Sea Ice','Snow','Ice Sheet'})

print('../PNGs/OceanCryo3colorbar','-dpng','-r1000', '-painters')

% hperma = surfacem(oscarlat,oscarlon,perma)
% uistack(hperma,'bottom')
% caxis([0 2])
% colormap(cryoc);

