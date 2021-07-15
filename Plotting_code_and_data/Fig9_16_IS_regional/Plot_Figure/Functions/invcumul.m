% This function inverts a cumulative series and error to a rate and rate
% error
% [trate,rate,ratesigma]=invcumul(t,delta,deltasigma)
function [trate,rate,ratesigma]=invcumul(t,delta,deltasigma)

maxdt=12;

nn=maxdt;
nnn=1;

ld=length(delta)
rate=nan*zeros(ld,nnn);
trate=nan*zeros(ld,nnn);
ratesigma=nan*zeros(ld,nnn);

%for nn=1:maxdt

%  size(rate(1:ld-(nn),nn))
%  size(sqrt(delta((nn+1):ld)-delta(1:(ld-nn)))./(t((nn+1):ld)-t(1:ld-nn)))
%  size(ratesigma(1:ld-(nn),nn))
%  size(sqrt(delta((nn+1):ld).^2-delta(1:ld-nn).^2)./(t((nn+1):ld)-t(1:ld-nn)))
  rate(1:ld-(nn),nnn)=(delta((nn+1):ld)-delta(1:ld-nn))./(t((nn+1):ld)-t(1:ld-nn));
  trate(1:ld-(nn),nnn)=(t((nn+1):ld)+t(1:ld-nn))./2;
  ratesigma(1:ld-(nn),nnn)=sqrt(deltasigma((nn+1):ld).^2-deltasigma(1:ld-nn).^2)./(t((nn+1):ld)-t(1:ld-nn));
%end
  
  