%% Taking data from Arena
%
% BVH is a text file which contains skeletal data, but its contents needs
% additional processing to draw the wireframe and create the animation.
clear;
addpath('./bvh-matlab');
addpath('./bvhdata');
DEG2RAD = pi/180;

%% DATA
name = './bvhdata/walk-takiguchi';
[bvh, time] = loadbvh(name);
bvhData = bvh;

%% SETTING
targetName = 'RightWrist';
for id = 1:length(bvh)
% make bvhData empty
    bvhData(id).Dxyz(:,1:end) = [];
    bvhData(id).rxyz(:,1:end) = [];
    bvhData(id).trans(:, :, 1:end) = [];
% get targetID
    if strcmp(bvh(id).name, 'RightWrist')
        targetID = id;
    end
end
% get startStep
startTime = 7.0;
for step = 1:length(time)   
    if time(step) >= startTime
        startStep = step;
        break;
    end
end

%% LOOP
for step = startStep : length(time)
    outputStep = step - startStep + 1;

    bvhT(outputStep) = time(step) - time(startStep);
    
    for id = 1:length(bvh)
        if isempty(bvh(id).Dxyz) == false
            bvhData(id).Dxyz(:, outputStep) = bvh(id).Dxyz(:, step);
        end
        if isempty(bvh(id).rxyz) == false
            bvhData(id).rxyz(:, outputStep) = bvh(id).rxyz(:, step);
        end
        if isempty(bvh(id).trans) == false
            bvhData(id).trans(:, :, outputStep) = bvh(id).trans(:, :, step);
        end
    end
    
    targetState(outputStep, :) = [bvh(targetID).Dxyz(:, step); 
                                              bvh(targetID).rxyz(:, step)*DEG2RAD]';
end












