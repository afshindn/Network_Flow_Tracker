function dres = build_graph(dres,dist_thresh,corrThresh)
dnum = length(dres.x);
time1 = tic;
len1 = max(dres.fr);
minFr = min(dres.fr);
maxFr = max(dres.fr);
for fr = minFr+1:maxFr
    if toc(time1) > 2
        fprintf('%0.1f%%\n', 100*fr/len1);
        time1 = tic;
    end
    f1 = find(dres.fr == fr);     %% indices for detections on this frame
    f2 = find(dres.fr == fr-1);   %% indices for detections on the previous frame
    for i = 1:length(f1)
        
        % Check for the location of the cars
        loc1Tmp = [dres.x(f1(i)), dres.y(f1(i))];
        loc1 = repmat(loc1Tmp, length(f2),1);
        loc2 = [dres.x(f2), dres.y(f2)];
        dist  = sqrt(sum((loc1-loc2).^2,2));
        inds1 = find(dist < dist_thresh);                       
        
        
        % Check for the correlation of the velocity
        velCurrTmp = [dres.vx(f1(i)), dres.vy(f1(i))];
        velCurr1   = repmat(velCurrTmp, length(f2),1);
        velCurr2   = [dres.vx(f2), dres.vy(f2)];
        normV1  = sqrt(sum((velCurr1).^2,2));
        normV2  = sqrt(sum((velCurr2).^2,2));
        correlationVel = sum(velCurr1.*velCurr2,2)./(normV1.*normV2);
        inds2  = (correlationVel(inds1) > corrThresh);          %% we ignore transitions with large change in the size of bounding boxes.
        
        dres.nei(f1(i),1).inds  = f2(inds1(inds2))';     
    end
end

