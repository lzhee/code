function [dG,distMat]=APpartitionCompute(Z,max_distance,min_distance)
N = size(Z,2);
% X and Y positions
X = Z(1,:);
Y = Z(2,:);
% Matrix with point to point distances
distMat = sqrt((repmat(X,N,1)-repmat(X',1,N)).^2+...
    (repmat(Y,N,1)-repmat(Y',1,N)).^2);
% Get sorted list with point to point distances
[dMsort_tmp, idxSort_tmp] = sort(distMat(:));
% Get unique distances
[dMsort,uniIdx,tmp] = unique(dMsort_tmp);
% Get unique indexes
idxSort = idxSort_tmp(uniIdx);
% Find idx to distance larger than max_distance
dMidx = find(dMsort > max_distance,1,'first');
% Extract the distances
if isempty(dMidx)
    dG = dMsort(1:end);
else
    dG = dMsort(1:dMidx);
end
% Obtain the point to point correnspondences of idxSort
[I,J] = ind2sub(size(distMat),idxSort);
% Extract the short ones, exclude first which is zero distance
I = I(1:dMidx-1);
J = J(1:dMidx-1);
% Allocate memory for which points are in the same cluster
cluster = zeros(size(distMat));

distG = 0;
for k = 2:dMidx-1
    % Make sure both points not already included
    if ~cluster(I(k),J(k)) % if one, then already in the same
        % Save this distance
        distG = [distG (dG(k)+dG(k+1))/2];
        % Index to points that I and J have previously been clustered to
        Iprev = find(cluster(I(k),:));
        Jprev = find(cluster(J(k),:));
        % Set those points to one
        cluster(J(k),Iprev) = 1; cluster(Iprev,J(k)) = 1;
        cluster(I(k),Jprev) = 1; cluster(Jprev,I(k)) = 1;
        cluster(Iprev,Jprev) = 1; cluster(Jprev,Iprev) = 1;
        % Set the new point
        cluster(I(k),J(k)) = 1; cluster(J(k),I(k)) = 1;
    end
end
dG = distG;
% Take the distances larger than min_distance
dG = dG(dG>=min_distance);

% Must have at least one distance
if isempty(dG)
    dG = min_distance;
end