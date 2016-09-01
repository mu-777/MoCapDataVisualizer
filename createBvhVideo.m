%% Taking data from Arena
%
% BVH is a text file which contains skeletal data, but its contents needs
% additional processing to draw the wireframe and create the animation.
clear;
addpath('./bvh-matlab');
addpath('./bvhdata');

%%
name = './bvhdata/walk-takiguchi';
[bvh, T] = loadbvh(name);

%%
movie = [];
write_video = true;
baseAxisSize = [ -1000, 1000, -1000, 1000, -1000, 1000];
% Prepare the new video file.

stepPerFrame = 5;
figObj = figure('Position', [50, 50, 640, 480]); 
for step = 1:stepPerFrame:length(T) %#ok<FORPF>
    clf; hold on;  grid on;
    title(sprintf('%1.2f seconds',T(step)))
%     set(figObj, 'color', 'white', 'Position', [50, 50, 640, 480])
         axis on;
    % From the BVH model exported by arena, it's clear that "y" is vertical
    % and "z" is medial-lateral. (From the "offsets" between the joints.)
    % Therefore, flip Y and Z when plotting to have Matlab's "vertical" z-axis
    % match up.
    
    for id = 1:length(bvh)
        
        currentAxisSize = baseAxisSize + [ bvh(1).Dxyz(1, id), bvh(1).Dxyz(1, id), bvh(1).Dxyz(3, id), bvh(1).Dxyz(3, id), bvh(1).Dxyz(2, id), bvh(1).Dxyz(2, id)];
        axis(round(currentAxisSize));
        
        parent = bvh(id).parent;
        plot3(0, 0, 0, '.', 'markersize', 40, 'Color', 'r')
        
        if strcmp(bvh(id).name, 'RightWrist')
            plot3(bvh(id).Dxyz(1,step),bvh(id).Dxyz(3,step),bvh(id).Dxyz(2,step),'.','markersize',20,  'Color', 'r')
        elseif parent > 0 && strcmp(bvh(parent).name, 'RightWrist')
            plot3(bvh(id).Dxyz(1,step),bvh(id).Dxyz(3,step),bvh(id).Dxyz(2,step),'.','markersize',20,  'Color', 'g')
        else
            plot3(bvh(id).Dxyz(1,step),bvh(id).Dxyz(3,step),bvh(id).Dxyz(2,step),'.','markersize',20,  'Color', 'b')
        end
        
        if parent > 0
            plot3([bvh(parent).Dxyz(1,step) bvh(id).Dxyz(1,step)],...
                [bvh(parent).Dxyz(3,step) bvh(id).Dxyz(3,step)],...
                [bvh(parent).Dxyz(2,step) bvh(id).Dxyz(2,step)])
        end
        
    end
    
    view(-30,30)
    axis equal off
    drawnow
    
    if write_video,    frame = getframe(figObj);    movie = [movie; frame]; end
    
end
hold off;   grid off;
if write_video
    vidTitle = strcat('sim_', datestr(now, 'yyyymmdd_HHMM'), '.mp4');
    vidObj = VideoWriter(vidTitle, 'mpeg-4'); 
    vidObj.FrameRate = 30;
    open(vidObj); 
    writeVideo(vidObj, movie);
    close(vidObj);
    close all hidden;
end






