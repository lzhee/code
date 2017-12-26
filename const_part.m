function [IDx]=const_part(s,idx,N)
%---------------------------------------------------
%This function is used to construct the index of partitions. 
%s                       array of large distances
%Idx                     index of AP
%N                       Number of observations
%--------------------------------------------------------
L=zeros(N,N);                       %recording the compared components
M=size(s,1);
TT=[];
Temp=[];
IDX=1:length(idx);
for n=1:M
    T1=s(n,1);
    T2=s(n,2);
    if L(T1,T2)==0
        ID1=find(IDX==T1);                  %judge whether T1 is in idx
        ID2=find(IDX==T2);                  %
        if isempty(ID1)                     %ID1 is not in idx
            Temp=[Temp;T1];
        end
        if isempty(ID2)
            Temp=[Temp;T2];                %ID2 is not in idx
        end
        L(T1,T2)=1;L(T2,T1)=1;
    end
end
TT=unique(Temp);
TD=sort(TT);
IDx=[idx;TD];