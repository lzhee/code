function IDX=reshape_index(Dis_thresh)
%--------------------------------------------------
%This function is used to reshape the theshed distance matrix
%Dis_thresh                       The theshed matrix
%IDX                              Save the index of premitive index
%-----------------------------------------------------
N=size(Dis_thresh,1);
IDX=[];
for n=1:N-1
    T1=find(IDX==n);
    if isempty(T1)                       %n is not in the index set
        IDX=[IDX n];
    end
    id1=find(Dis_thresh(n,n:N));
    if ~isempty(id1)
        for m=1:length(id1)
            T2=find(IDX==id1(m));
            if isempty(T2)                 %id1(m) is not in the index set
                IDX=[IDX,id1(m)];
            end
        end
    end
end