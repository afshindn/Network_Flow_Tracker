function dres = bboxes2dres(bboxes)

dres.x  = bboxes(:,2);
dres.y  = bboxes(:,3);
dres.vx = bboxes(:,4);
dres.vy = bboxes(:,5);
dres.s  = bboxes(:,6);
dres.fr = bboxes(:,1);






