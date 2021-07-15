function [t1,h1,clusterdata]=dailymax(t,h,N)
cnt=1;
dailymax=[];
while cnt<N+1
    kk = [cnt:cnt+23]';
    h4=h(kk);
    t4=t(kk);
    dmax=nanmax(h4);
    if isnan(dmax)==0
        i=find(dmax==h4);
        dailymax=[dailymax; t4(i(1)) dmax];
    else
        dailymax=[dailymax; t4(1) dmax];
    end
    cnt=cnt+24;
end
h1=dailymax(:,2);
t1=dailymax(:,1);

sortdm=sortrows(dailymax,-2);
sorth=sortdm(:,2);
sortt=sortdm(:,1);
c=datevec(sortt);
tdata=[];
newdata=[];
for j=1:length(sortt)
    c1=c(j,:);
    if isnan(c1(1))==1
    else
        c0=c1; c0(3)=c0(3)-1.5;
        c2=c1; c2(3)=c2(3)+1.5;
        cc0=datevec(datenum(c0));
        cc2=datevec(datenum(c2));
        p=find(sortt>datenum(c0) & sortt<datenum(c2));
        hmax=max(sorth(p));
        if isnan(hmax)==0
            ii=p(find(sorth(p)==hmax));
            tmax=sortt(ii(1));
            if isempty(intersect(tmax,tdata))==1
                if length(p)==1
                    newdata=[newdata;hmax];
                    tdata=[tdata;tmax];
                else
                    newdata=[newdata;hmax];
                    tdata=[tdata;tmax];
                    [pi,pi1,pi2]=intersect(p,ii(1));
                    p(pi1)=[];
                    sortt(p)=nan; sorth(p)=nan;
                    c(p,:)=nan;
                end
            end
        end
    end
end
clusterdata=[tdata newdata];

