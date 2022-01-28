% we use map size as 100*100
close all; clear;

%handles
x = 50;
y = 50;
nest = [x;y];       %nest position
teleInfo = true;   %the switch whether ant can communicate through pheromone in the air.
Population = 50;    %ant population
antPerReleaseTime = 5;      %how many ant leaves nest per minute. antPerMin must be smaller than Population in order to work correctly.
releaseAntTime = 20;
timeLim = 150;      %the maximum time an ant can roam outside without finding of food.
%random foodLoc:
%foodLoc = [round(rand*40)+30;round(rand*40)+30];
%specific foodLoc to test performance:
foodLoc = [38;38];


%variables program will generate based on handle
antPath = [ones(1,Population)*x;ones(1,Population)*y];
antPath = mat2cell(antPath,2,ones(1,Population));       %initialize antPath as cell
for i = 1:Population
    antPath{i} = [antPath{i},antPath{i}];       %let ant Path start with length 2 with duplicated position, such that the first location can be used as old location and be compared in function Direction.
end
ret = zeros(1,Population);          %an array to see if the ant is returning.
retStatus = zeros(1,Population);    %an array indicating which direction the ant is moving in the retPath. 1 is toward the food. 0 is returning to the nest. Since the only way to enter the retPath in this code is at the food location, every ant with have a default 0 as they get into return mode.
antcount = zeros(1,Population);     %count how many ant has left the nest.

n = 0;                  %the index of the ant that find food.
pathIndex = zeros(1,Population);    %record the location of each ant on the retPath. index 1 meaning the ant is at the food source. 0 means it has not enetered the return mode yet.
ConsFinished = false;   %check if the retPath has been constructed, meaning if the leading ant has returned to nest.
retPath = [0;0];

firstTime = true;       %this is a trigger that prevents the program from repeatedly saying 90% of ant know the food location.
timeCount = 0;          %time count since the program has started. Each proceed is counted as 1 second.

outTime = zeros(1,Population);      %an array to record the roaming time of each ant.
timeRet = zeros(1,Population);      %an array that record if this ant is returning due to roaming time restriction.

while ~ConsFinished
    if timeCount >= 500
        break
    end
    if sum(antcount) <= Population-antPerReleaseTime
        for i = 1:antPerReleaseTime
            check = true;
            k = 1;
            while check
                if antcount(k) == 0
                    antcount(k) = 1;
                    check = false;
                end
                k = k+1;
            end
        end
    end
    for i = 1:releaseAntTime
        if ~ConsFinished
            [antPath,antcount,n,ret,retPath,pathIndex,ConsFinished,outTime,timeRet] = Proceed(teleInfo,antPath,antcount,n,foodLoc,ret,retPath,pathIndex,nest,ConsFinished,outTime,timeRet,timeLim);
            timeCount = timeCount + 1;
            if firstTime && sum(ret) >= 0.9*Population
                firstTime = false;
                disp('90% of ant know the foodlocation at t = ' + string(timeCount) + 's')
            end
        else
            break
        end
        draw(nest,foodLoc,antPath,Population,ret,retPath,pathIndex)
        pause(0.1)
    end
end
len = size(retPath,2);          %the length of the retPath
for i = 1:Population            %activate the ants who has not left the nest.
    if size(antPath{i},2) == 2
        ret(i) = 1;
        pathIndex(i) = len;
    end
end
while true
    if timeCount >= 500
        disp('program end due to the time limit.')
        break
    end
    timeCount = timeCount + 1;
    [ret,retPath,antPath,pathIndex,nest,foodLoc,retStatus,outTime,timeRet] = afterConsProceed(teleInfo,ret,retStatus,Population,antPath,retPath,pathIndex,nest,foodLoc,len,outTime,timeRet,timeLim);
    if firstTime && sum(ret) >= 0.9*Population
        firstTime = false;
        disp('90% of ant know the foodlocation at t = ' + string(timeCount) + 's')
    end
    draw(nest,foodLoc,antPath,Population,ret,retPath,pathIndex)
    pause(0.1)
end





