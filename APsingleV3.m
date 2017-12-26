function [P,idxx]=APsingleV3(Z,disMat,dg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function is used to compute the cells of single AP implementation
%s                    distance matrix
%dg                   selected distance
%disMat                    cells of the current partition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dis_temp=dg;
%-------Abstract the components large or less than the threshold--------
Low_dis=disMat<dis_temp;               %Acuqire the indice less than the threshold
Lar_dis=~Low_dis;
IDLo=(reshape_index(Low_dis))';        %Reshape the threshed matrix
IDLa=(reshape_index(Lar_dis))';
IDLo=sort(IDLo);
IDLa=sort(IDLa);
%--------Delete the repeated components-----------
IDLA=IDLa;
for n=1:length(IDLo)
    IDC=find(IDLA==IDLo(n));
    if ~isempty(IDC)
        IDLA(IDC)=[];
    end
end
%-----------Reconstruct the matrix for AP-----------
s=[];
for n=1:length(IDLo)
    TT=1;
    for m=1:length(IDLo)
        if m~=n                             %考虑加上距离限制？
            if disMat(IDLo(n),IDLo(m)) < dis_temp
                x(1)=n;
                x(2)=m;
                x(3)=-disMat(IDLo(n),IDLo(m));
                s=[s;x];
            end                     
        end
    end    
end
%--------------------------------------------------------
p=median(s(:,3));                      %Initial value of preference
[idx,netsim,dpsim,expref]=apclusterSparse(s,p);
%------Project the index into primitive-----
idxx=[IDLo(idx);IDLA];
%--------------------------------------------
X=[Z(:,IDLo),Z(:,IDLA)];              %Resort the observation set
N=size(Z,2);
idx_cell=unique(idxx)';                  % index of cell
for n=1:length(idx_cell)
    m=find(idxx==idx_cell(n));
    W=X(:,idxx(m));
    P(n).W=W;
end