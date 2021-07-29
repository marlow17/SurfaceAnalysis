function [ind,y]=findClosestTriangle(tr,x,verbose)
% searching for the closest triangle
%
% this code will not win the beauty contest

if nargin<3, verbose=true; end

ind=nan(size(x,1),3);

ic=incenter(tr);
n=tr.faceNormal((1:tr.size(1))');

counter=[0,0,0];

for k=1:size(x,1)
    
    [dv,indV]=min(sum((tr.Points-x(k,:)).^2,2));
    if dv<1e-16
        counter(3)=counter(3)+1;
        ind(k,:)=indV;
        continue;
    end
    [dc,indC]=min(sum((ic-x(k,:)).^2,2));
    if dc<1e-16
        counter(2)=counter(2)+1;
        ind(k,:)=tr.ConnectivityList(indC,:);
        continue;
    end
        
    % project the point on the triangle surface
    w=tr.Points(tr.ConnectivityList(:,1),:)-x(k,:);
    t=sum(n.*w,2);
    delta=bsxfun(@times,t,n);
    projection=delta+x(k,:);
    D=sum(delta.^2,2);
    B=cartesianToBarycentric(tr,(1:tr.size(1))',projection);
    inTri=find(all(B>=0&B<=1,2));
    if numel(inTri)
        [~,j]=min(D(inTri));
        inTri=inTri(j);
        dt=D(inTri);
    else
        dt=[];
    end
    
    if ~isempty(dt) && dt<dc && dt<dv
        counter(1)=counter(1)+1;
        ind(k,:)=tr.ConnectivityList(inTri,:);
    elseif dc<dv
        counter(2)=counter(2)+1;
        ind(k,:)=tr.ConnectivityList(indC,:);
    else
        counter(3)=counter(3)+1;
        ind(k,:)=indV;
    end
end

if verbose
    fprintf(['%s: found %d projected points, ' ...
        '%d in-centers & %d closest vertices ...\n'],...
        mfilename,counter(1),counter(2),counter(3));
end

if nargout==2
    y=tr.Points(ind,:);
end

end

