function [Zp] = partitionMeasurementSet_4(Z,max_distance,min_distance)

if isempty(Z)
    Zp = [];
elseif size(Z,2) == 1
    Zp(1).P(1).W = Z;
    dG = 0;
else
    [Zp,dG] = partition(Z,max_distance,min_distance);
end

figure(6),clf,whitebg('k')
for p = 1:numel(Zp)
    W = numel(Zp(p).P);
    col = jet(W);
    subplot(ceil(numel(Zp)/4),4,p)
    hold on, axis equal
    for w = 1:W
        plot(Zp(p).P(w).W(1,:),Zp(p).P(w).W(2,:),'*','color',col(w,:))
        title(['d = ' num2str(dG(p))])
        xlabel('X [m]')
        ylabel('Y [m]')
        Xmax = max(Zp(p).P(w).W,[],2);
        Xmin = min(Zp(p).P(w).W,[],2);
        e = 10;
        plot([Xmin(1)-e Xmin(1)-e Xmax(1)+e Xmax(1)+e Xmin(1)-e],...
            [Xmin(2)-e Xmax(2)+e Xmax(2)+e Xmin(2)-e Xmin(2)-e],'w')
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Zp,dG] = partition(Z,max_distance,min_distance)

% Number of points in measurement set
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

% Counter for the number of partitions
P = 0;
dM = distMat;
for idG = 1:length(dG)
    % Increment the number of partitions
    P = P+1;
    clear segment
    % Counter for the number of segments
    W = 1;
    % Index from which to start picking out points
    segment(W).i = 1;
    % Index to the points that were last added to the segment
    segment(W).iLast = 1;
    % Index containing the points that have not been asigned to a subgroup yet
    I = 2:N;
    % Iterate while there are points that have not been assigned.
    while ~isempty(I)
        % Pick out the distances to compare to
        dist = dM(I,segment(W).iLast);
        % Find the ones that are shorter than the threshold
        idx = (sum(dist<=dG(idG),2)>0);
        % Obtain point indexes
        idx = I(idx);
        % Check if any points are within the right distance
        if isempty(idx)
            % Store the points that are included in the subgroup
            Zp(P).P(W).W = Z(:,segment(W).i);
            W = W+1; % Start new segment
            % Take the "next" point in the laser sweep
            segment(W).i = I(1);
            segment(W).iLast = segment(W).i;
            % Remove from the total set
            I = I(2:end);
            if isempty(I)
                Zp(P).P(W).W = Z(:,segment(W).i);
                W = W+1;
                break
            end
        else % If some points are within the right distance
            % Change the last added point index
            segment(W).iLast = idx;
            % Add to the current subgroup
            segment(W).i = [segment(W).i idx];
            % Remove the points from the group of unassigned points.
            I = setdiff(I,idx);
            % If there are no more to assign
            if isempty(I)
                % Store the points
                Zp(P).P(W).W = Z(:,segment(W).i);
            end
        end
    end
end
