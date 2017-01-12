function [trackInfo,trkRes] = dres2bboxes(dres)

ids = unique(dres.id);
cnt = 1;
trkRes = [];
for i=1:length(ids)
    ind = find(dres.id==ids(i));
    if (length(ind)<10)
        continue;
    end
   trackInfo(cnt).id = ids(i);
   trackInfo(cnt).fr = dres.fr(ind);
   trackInfo(cnt).x = dres.x(ind);
   trackInfo(cnt).y = dres.y(ind);
   tmp = [trackInfo(cnt).fr, dres.id(ind), trackInfo(cnt).x, trackInfo(cnt).y];
   trkRes = [trkRes;tmp];
   cnt = cnt + 1; 
end
