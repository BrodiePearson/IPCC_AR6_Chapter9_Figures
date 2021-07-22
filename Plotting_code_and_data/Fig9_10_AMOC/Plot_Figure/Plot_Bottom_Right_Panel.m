% This code was written by Baylor Fox-Kemper, 2020
% Following a python code template by Laura Jackson, 2019
% Dr. Jackson extracted the data used in this figure
% from the relevant literature.

figure('Position', [10 10 510 310])

%Open the CSV file
A=readmatrix('Data/moc_fw.csv'); % This has the numbers
B=readtable('Data/moc_fw.csv'); % This has the strings

colors=[221 84 46
33 52 219
53 165 197
170 24 24
8 46 114
50 127 81
128 54 168]./255;


sverdrups=sqrt(A(:,5));
duration=A(:,6);
hose=A(:,7);
damoc=A(:,8);
damoc(isnan(damoc))=0;

'Yin and Stouffer, 2007'
ii=[1]; 
col=colors(1,:);
scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'v','MarkerEdgeColor',col,'MarkerFaceColor',col);
hold on;
ii=[2]; 
h1=scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'o','MarkerEdgeColor',col,'MarkerFaceColor',col);

'Liu and Liu, 2013'
ii=[3]; 
col=colors(2,:);
scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'^','MarkerEdgeColor',col,'MarkerFaceColor',col);

% Just for legend
h2=scatter(-hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'o','MarkerEdgeColor',col,'MarkerFaceColor',col);

ii=[4]; 
scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'v','MarkerEdgeColor',col,'MarkerFaceColor',col);

'Haskins et al, 2019'
ii=[5]; 
col=colors(3,:);
h3=scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'o','MarkerEdgeColor',col,'MarkerFaceColor',col);

ii=[6]; 
scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'o','MarkerEdgeColor',col,'MarkerFaceColor',col);

'Jackson and Wood, 2018'  
col=colors(4,:);
ii=[7:12];
h4=scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'o','MarkerEdgeColor',col,'MarkerFaceColor',col);

ii=[13];
scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'v','MarkerEdgeColor',col,'MarkerFaceColor',col);

'De Vries and Weber, 2005'
col=colors(5,:);
ii=[14:17];
scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'^','MarkerEdgeColor',col,'MarkerFaceColor',col);

% Just for legend
h5=scatter(-hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'o','MarkerEdgeColor',col,'MarkerFaceColor',col);


ii=[18];
scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'v','MarkerEdgeColor',col,'MarkerFaceColor',col);

'Jackson 2013'
col=colors(6,:);
ii=[19];
h6=scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'o','MarkerEdgeColor',col,'MarkerFaceColor',col);

ii=[20];
scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'^','MarkerEdgeColor',col,'MarkerFaceColor',col);

'Stouffer et al, 2006' 
col=colors(7,:);
ii=[21:35 37:38];
h7=scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'o','MarkerEdgeColor',col,'MarkerFaceColor',col);

ii=[36 39];
scatter(hose(ii)*100,damoc(ii)*100,sverdrups(ii)*300,col,'v','MarkerEdgeColor',col,'MarkerFaceColor',col);

% For Legend only

col=[1 1 1];
ii=[]
h8=scatter(-1*100,-1*100,500,'k','o','MarkerEdgeColor','k','MarkerFaceColor','k');
h9=scatter(-1*100,-1*100,500,'k','^','MarkerEdgeColor','k','MarkerFaceColor','k');
h10=scatter(-1*100,-1*100,500,'k','v','MarkerEdgeColor','k','MarkerFaceColor','k');

xlim([0 500]);
ylim([-100 50])

hold off;

legend([h1, h2, h3, h4, h5, h6, h7, h8, h9, h10],'Yin and Stouffer, 2007','Liu and Liu, 2013','Haskins et al, 2019','Jackson and Wood, 2018','De Vries and Weber, 2005','Jackson 2013','Stouffer et al, 2006','Recovers within 200 years', 'Recovers after 200 years', 'No recovery by 200 years','FontSize',10)

box on
set(gca,'FontSize',18)
ylabel('Percent AMOC Change','FontSize',20)
xlabel('Fresh Water Added (10^{4} Gt)','FontSize',20)

saveas(gcf,'../PNGs/Jacksonv2.png')
