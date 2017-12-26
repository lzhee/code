function [P,idx]=APsingle(Z,s,dg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function is used to compute the cells of single AP implementation
%s                    distance matrix
%dg                   selected distance
%W                    cells of the current partition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s_AP=s;
dis_temp=dg;
index_temp=find(s_AP(:,3)<dis_temp);      %Set small value equals to the current distance
s_AP(index_temp,3)=dis_temp;
s_AP(:,3)=-s_AP(:,3);                     %Change to similarity matrix
p=median(s_AP(:,3));                      %Initial value of preference
[idx,netsim,dpsim,expref]=apclusterSparse(s_AP,p,'plot');
x=Z;
idx_cell=unique(idx)';                  % index of cell
for n=1:length(idx_cell)
    m=find(idx==idx_cell(n));
    W=x(:,m);
    P(n).W=W;
end