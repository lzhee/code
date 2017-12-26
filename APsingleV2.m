function [P,idx]=APsingleV2(Z,s,dg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function is used to compute the cells of single AP implementation
%s                    distance matrix
%dg                   selected distance
%W                    cells of the current partition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dis_temp=dg;
index_temp=find(s(:,3)<dis_temp);      %Set small value equals to the current distance
s_AP=s(index_temp,:);                       %Abstract the distance less than the threshold
s_AP(:,3)=-s_AP(:,3);                     %Change to similarity matrix
s_LD=s;                                %Large distances won't perform AP
s_LD(index_temp,:)=[];
s_LD(:,3)=-s_LD(:,3);
p=median(s_AP(:,3));                      %Initial value of preference
[idx,netsim,dpsim,expref]=apclusterSparse(s_AP,p);
x=Z;
N=size(Z,2);
[idx]=const_part(s_LD,idx,N);
idx_cell=unique(idx)';                  % index of cell
for n=1:length(idx_cell)
    m=find(idx==idx_cell(n));
    W=x(:,m);
    P(n).W=W;
end