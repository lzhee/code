function [Zp]=APpartitionMeasurement(Z,max_distance,min_distance)
%-----------------------------------------------------------------
%This function is defined for observation partitioning by AP method
%The notations are listed as follows
%Z       The current observation set
%max_distance The max distance of observations
%min_distance The min distance of observations
%----------------------------------------------------------------
[dG,distMat]=APpartitionCompute(Z,max_distance,min_distance);
%-----------------LZHE------------------------------------------
% Reshape the distance matrix
N=size(distMat,1);
for n=1:N
    s((n-1)*(N-1)+1:n*(N-1),1)=n;
    s((n-1)*(N-1)+1:n*(N-1),2)=[1:n-1 n+1:N]';
    s((n-1)*(N-1)+1:n*(N-1),3)=distMat(n,[1:n-1 n+1:N])';
end
% replace the similarity large than mindistance and smaller than max
% index_max=find(s(:,3)>max_distance);
% s(index_max,3)=max_distance;
%-----Set the initial value of AP--------------------------
m=1;
for n=1:length(dG)
    dg=dG(n);
    n
    [P,Idx(:,n)]=APsingleV3(Z,s,dg);             %Implement the AP method  
    if n~=1
        if ~isequal(Idx(:,n),Idx(:,n-1))       %Remove the same cell
            m=m+1;
            Zp(m).P=P;
        end
    else
        Zp(m).P=P;
    end
end


