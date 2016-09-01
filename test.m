
clear;
addpath('./bvh-matlab');
addpath('./bvhdata');
videoFlag = true;

name = 'louise';
[bvh, T] = loadbvh(name);
%% config
baseAxisSize = [ -1000, 1000, -1000, 1000, -1000, 1000];
figObj = figure('Position', [50, 50, 640, 480]);
figure(figObj);

%% ‰Šú’l
fps = 10;
stepPerFrame = round(size(T, 1)/(fps*T(end))); %1frame‚ ‚½‚èSTEP”

movie = [];

%% Loop
for step = 1 : stepPerFrame : length(T)
    clf;
    hold on;    grid on;    view(3);    %view([-20,90]);
    currentAxisSize = baseAxisSize + [ bvh(1).Dxyz(1, step), bvh(1).Dxyz(1, step), bvh(1).Dxyz(3, step), bvh(1).Dxyz(3, step), bvh(1).Dxyz(3, step), bvh(1).Dxyz(step, M+1)];
    axis(round(currentAxisSize));
    
    for id = 1:length(bvh)
        plot3(bvh(id).Dxyz(1,step), bvh(id).Dxyz(3,step), bvh(id).Dxyz(2,step),'.' , 'markersize', 20);
        
        parent = skeleton(nn).parent;
        if parent > 0
            plot3( [bvh(parent).Dxyz(1, step) bvh(id).Dxyz(1, step)],...
                [bvh(parent).Dxyz(3, step) bvh(id).Dxyz(3, step)],...
                [bvh(parent).Dxyz(2, step) bvh(id).Dxyz(2, step)]);
        end
    end
    drawnow
    if videoFlag
        frame = getframe(figObj);
        movie = [movie; frame];
    end
end

if videoFlag
    title = strcat('sim_', datestr(now, 'yyyymmdd_HHMM'), '.mp4');
    writerObj = VideoWriter(title, 'mpeg-4');
    writerObj.FrameRate = 30;
    open(writerObj);
    writeVideo(writerObj, movie);
    close(writerObj);
end

%%








