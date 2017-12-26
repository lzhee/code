clear all;clc;
load meas;
Zk=cluttMeas(15).p; %Select time 12 for example
%---
[dG,disMat]=APpartitionCompute(Zk,max_distance,min_distance);
N=size(disMat,1);
for n=1:N
    s((n-1)*(N-1)+1:n*(N-1),1)=n;
    s((n-1)*(N-1)+1:n*(N-1),2)=[1:n-1 n+1:N]';
    s((n-1)*(N-1)+1:n*(N-1),3)=disMat(n,[1:n-1 n+1:N])';
end

index_max=find(s(:,3)>max_distance);
s(index_max,3)=max_distance;
%------²âÊÔ²¿·Ö-----
s_AP=s;
dis_temp=dG(6);
index_temp=find(s_AP(:,3)>dis_temp);      %Set small value equals to the current distance
s_AP(index_temp,:)=[];
s_AP(:,3)=-s_AP(:,3);
s_LD=s(index_temp,:);
s_LD(:,3)=-s_LD(:,3);
% s_AP(1:9,:)=[];
% IND=find(s_AP(:,2)==1);
% s_AP(IND,:)=[];
% s_AP(9:10,:)=[];
% IND2=find(s_AP(:,2)==3);
% s_AP(IND2,:)=[];
p=median(s_AP(:,3));
[idx,netsim,dpsim,expref]=apclusterSparse(s_AP,p,'plot');
[idx]=const_part(s_LD,idx,N)
x=Zk;
idx_cell=unique(idx)';                  % index of cell
for n=1:length(idx_cell)
    m=find(idx==idx_cell(n));
    W{n}=x(:,m);
end
    
fprintf('Number of clusters: %d\n',length(unique(idx)));
fprintf('Fitness (net similarity): %f\n',netsim);
x=Zk';
figure; % Make a figures showing the data and the clusters
for i=unique(idx)'
  ii=find(idx==i); h=plot(x(ii,1),x(ii,2),'o'); hold on;
  col=rand(1,3); set(h,'Color',col,'MarkerFaceColor',col);
  xi1=x(i,1)*ones(size(ii)); xi2=x(i,2)*ones(size(ii)); 
  line([x(ii,1),xi1]',[x(ii,2),xi2]','Color',col);
end;