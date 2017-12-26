clear all;clc;
load data_zk;
% Zk=cluttMeas(15).p; %Select time 12 for example
%---
[dG,disMat]=APpartitionCompute(Zk,max_distance,min_distance);
Low_dis=disMat<dG(9);
Lar_dis=~Low_dis;
IDLo=(reshape_index(Low_dis))';        %Reshape the threshed matrix
IDLo=sort(IDLo);
IDLa=reshape_index(Lar_dis);
%--------剔除重复元素--
IDLA=IDLa;
for n=1:length(IDLo)
    IDC=find(IDLA==IDLo(n));
    if ~isempty(IDC)
        IDLA(IDC)=[];
    end
end
%----------------------
s=[];
for n=1:length(IDLo)
    TT=1;
    for m=1:length(IDLo)
        if m~=n                             %考虑加上距离限制？
            if disMat(IDLo(n),IDLo(m)) < dG(9)
                x(1)=n;
                x(2)=m;
                x(3)=-disMat(IDLo(n),IDLo(m));
                s=[s;x];
            end            
%             if disMat(IDLo(n),IDLo(m)) <dG(6)
%                 x(3)=-disMat(IDLo(n),IDLo(m));
%             else
%                 x(3)=-max_distance;
%             end           
        end
    end    
end
%------测试部分-----
p=median(s(:,3));
[idx,netsim,dpsim,expref]=apclusterSparse(s,p,'plot');
idxx=IDLo(idx);
idxx=[idxx;IDLA'];
x=[Zk(:,IDLo),Zk(:,IDLA)];
% x=Zk;
idx_cell=unique(idxx)';                  % index of cell
for n=1:length(idx_cell)
    m=find(idxx==idx_cell(n));
    W{n}=x(:,idxx(m));
end
    
fprintf('Number of clusters: %d\n',length(unique(idx)));
fprintf('Fitness (net similarity): %f\n',netsim);
x=Zk';
figure; % Make a figures showing the data and the clusters
for i=1:length(idx_cell)
  ii=find(idxx==idx_cell(i)); h=plot(x(idxx(ii),1),x(idxx(ii),2),'o'); hold on;
  col=rand(1,3); set(h,'Color',col,'MarkerFaceColor',col);
  xi1=x(idx_cell(i),1)*ones(size(ii)); xi2=x(idx_cell(i),2)*ones(size(ii)); 
  line([x(idxx(ii),1),xi1]',[x(idxx(ii),2),xi2]','Color',col);
end;