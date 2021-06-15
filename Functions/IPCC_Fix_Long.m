function  [mapped_variable0, latitude0, longitude0]=IPCC_Fix_Long(mapped_variable, latitude, longitude, cent_longitude)
% Fix Longitude
% To improve on the results of projected maps, this function cyclically
% permutes the mapped_variable, latitude, and longitude so that 
% the breakpoint in longitude occurs at break_longitude
%
% It can manage lat and lon in meshgrid or vector.

if ~exist('cent_longitude')
    cent_longitude=210;
end

break_longitude0=wrapTo360(cent_longitude+180);
longitude0=wrapTo360(longitude);

if logical(prod(size(longitude)==size(mapped_variable)))
    % This is meshgrid
    
    ndx=find(longitude0(:,1)==min(longitude0(:,1)));
    longitude0=longitude0([ndx:end 1:ndx(1)-1],:);
    mapped_variable0=mapped_variable([ndx:end 1:ndx(1)-1],:);
    
    thresh=zeros(size(longitude(1,:)));
    for ii=1:length(longitude(1,:)) 
        thresh(ii)=min(find(longitude0(:,ii)>break_longitude0));
    end
    thresh=round(median(thresh(:)));
    slon=size(longitude);
    longitude0=longitude0([thresh:end 1:thresh-1],:);
    lnth=length(thresh:slon(1));
    longitude0(1:lnth,:)=longitude0(1:lnth,:)-360;
    latitude0=latitude([thresh:end 1:thresh-1],:);
    mapped_variable0=mapped_variable([thresh:end 1:thresh-1],:);
    
else
    ndx=find(longitude0==min(longitude0));
    longitude0=longitude0([ndx:end 1:ndx(1)-1]);
    mapped_variable0=mapped_variable(:,[ndx:end 1:ndx(1)-1]);
    
    % This is vector coords
    ndx=find(longitude0>break_longitude0);
    ndx=ndx(:)';
    if ndx(1)>1
       longitude0=longitude0([ndx 1:ndx(1)-1]);
       longitude0([1:length(ndx)])=longitude0([1:length(ndx)])-360;
       latitude0=latitude;
       mapped_variable0=mapped_variable(:,[ndx 1:ndx(1)-1]);
    end
end