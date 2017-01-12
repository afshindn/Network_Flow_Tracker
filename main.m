clear;clc;close all;

%% input/output files 
detPath = 'detections.txt';
outRes = './';


%% Read detections 
detRes  = dlmread(detPath);

%% setting parameters for tracking
c_en        = 20;   %% birth cost
c_ex        = 20;   %% death cost
c_ij        = 0;    %% transition cost
betta       = -1;   %% betta
max_it      = inf;  %% max number of iterations (max number of tracks)
thr_cost    = 10;   %% max acceptable cost for a track (increase it to have more tracks.)
dist_thresh = 12;   %% Distance threshold between two neighboring detection
corrThresh  = 0.65; %% Correlation threshold for associating two detection

%% Build the association graph
dres = bboxes2dres(detRes);
dres = build_graph(dres,dist_thresh,corrThresh);

%% Running tracking algorithms
display('in DP tracking ...')

tic
display('in DP tracking with nms in the loop...')
dres_dp_nms   = tracking_dp(dres, c_en, c_ex, c_ij, betta, thr_cost, max_it, 0);
dres_dp_nms.r = -dres_dp_nms.id;
toc

fnum = max(dres.fr);
[trackInfo,trkRes] = dres2bboxes(dres_dp_nms);  %% we are visualizing the "DP with NMS in the lop" results. Can be changed to show the results of DP or push relabel algorithm.
dlmwrite([outRes, sprintf('tracking_NF_dist_%d_corr_%0.2f.txt',dist_thresh,corrThresh)],trkRes);
save([outRes, sprintf('tracking_NF_dist_%d_corr_%0.2f.mat',dist_thresh,corrThresh)],'trackInfo');

%% Visualization
cc = lines(100);
cnt=1;
for iTrack=1:length(trackInfo)
    xCurr   = trackInfo(iTrack).x;
    yCurr   = trackInfo(iTrack).y;
    idCurr  = trackInfo(iTrack).id;
    plot(xCurr, yCurr, '-', 'color',cc(mod(idCurr,100)+1,:),'lineWidth',3);hold on;
    xlim([0 800]);
    ylim([0 477]);
    grid on;
    cnt = cnt+1;
    hold on;
    pause(0.01);
end



