function [antPath,antcount,n,ret,retPath,pathIndex,ConsFinished,outTime,timeRet] = Proceed(teleInfo,antPath,antcount,n,foodLoc,ret,retPath,pathIndex,nest,ConsFinished,outTime,timeRet,timeLim)
    % proceed all the ant that is in motion. If it's in returning mode,
    % don't proceed it.(haven't implemented the returning mode)
    moving = find(antcount);    %the index of ant that is permitted to move
    if n == 0   % no ant has get near to food
        for i = moving
            curLoc = antPath{i}(:,end);
            if CheckDis(curLoc,foodLoc)
                n = i;
                outTime(i) = 0;
                timeRet(i) = 0;
            elseif timeRet(i) == 1
                if reached(curLoc,nest)
                    timeRet(i) = 0;
                    antcount(i) = 0;
                    antPath{i} = [nest nest];
                else
                    antPath{i} = [antPath{i}, pointToPoint(curLoc,nest)];
                end
            elseif outTime(i) == timeLim
                outTime(i) = 0;
                timeRet(i) = 1;
                antPath{i} = [antPath{i}, pointToPoint(curLoc,nest)];
            else
                lastLoc = antPath{i}(:,end-1);
                antPath{i} = [antPath{i}, Direction(lastLoc,curLoc)];
                outTime(i) = outTime(i)+1;
            end
        end
    elseif sum(ret) == 0    % ant has found the food and is approaching.
        for i = moving
            curLoc = antPath{i}(:,end);
            if i == n
                if reached(curLoc,foodLoc)
                    ret(i) = 1;
                    retPath(:,1) = foodLoc;
                    pathIndex(i) = 1;
                else
                    antPath{i} = [antPath{i}, pointToPoint(curLoc,foodLoc)];
                end
            elseif timeRet(i) == 1
                if reached(curLoc,nest)
                    timeRet(i) = 0;
                    antcount(i) = 0;
                    antPath{i} = [nest nest];
                else
                    antPath{i} = [antPath{i}, pointToPoint(curLoc,nest)];
                end
            elseif outTime(i) == timeLim
                outTime(i) = 0;
                timeRet(i) = 1;
                antPath{i} = [antPath{i}, pointToPoint(curLoc,nest)];
            else
                lastLoc = antPath{i}(:,end-1);
                antPath{i} = [antPath{i}, Direction(lastLoc,curLoc)];
                outTime(i) = outTime(i)+1;
            end
        end
    else                    % one ant has found the food and is returning directly to home. The return path is under construction.
        for i = moving
            if i == n       % if this ant is the ant who found the food and is returning.
                curLoc = retPath(:,end);
                retPath(:,end+1) = pointToPoint(curLoc,nest);
                pathIndex(i) = pathIndex(i)+1;
                if reached(nest,retPath(:,end))
                    ConsFinished = true;
                end
            elseif ret(i) == 1              %if this ant is already in return mode
                pathIndex(i) = pathIndex(i)+1;
            else                % check if this ant can get the information of the food. Two mode options based on teleInfo.
                curLoc = antPath{i}(:,end);
                temp = false;  %check if this ant has proceeded within the for loop.
                if teleInfo     % teleInfo available. The ant can sense pheromone to get the food location.
                    % check if this ant is in approximity of the path. If yes, follow the path to the food location. Note that this section of code won't register the ant into the retPath unless it has reached the food location.
                    if reached(curLoc,retPath(:,1))     %check if the ant has already reached the food.
                        ret(i) = 1;
                        pathIndex(i) = 1;
                        continue
                    end
                    for j = 1:size(retPath,2)   %check if the ant is in approximity of the road starting from the foodLoc. Due to this reason, the ant can only enter the retPath at the foodLoc.
                        if CheckDis(curLoc,retPath(:,j))
                            antPath{i} = [antPath{i}, pointToPoint(curLoc,retPath(:,j))];
                            outTime(i) = 0;
                            timeRet(i) = 0;
                            temp = true;
                            break
                        end
                    end
                    if ~temp    %if the ant has not proceeded through the previous steps, meaning they are still free roaming.
                        if timeRet(i) == 1
                            if reached(curLoc,nest)
                                timeRet(i) = 0;
                                antcount(i) = 0;
                                antPath{i} = [nest nest];
                            else
                                antPath{i} = [antPath{i}, pointToPoint(curLoc,nest)];
                            end
                        elseif outTime(i) == timeLim
                            outTime(i) = 0;
                            timeRet(i) = 1;
                            antPath{i} = [antPath{i}, pointToPoint(curLoc,nest)];
                        else
                            lastLoc = antPath{i}(:,end-1);
                            antPath{i} = [antPath{i}, Direction(lastLoc,curLoc)];
                            outTime(i) = outTime(i)+1;
                        end
                    end
                else        %teleInfo is off. The ant can only communicate with each other through physical contanct
                    % check if this ant has contacted the ant that knows foodLoc. If yes, follow the path to the food location. Note that this section of code will register the ant into the retPath from various locations.
                    for j = find(ret)
                        if reached(curLoc,retPath(:,pathIndex(j))) %if the ant has physical contanct with ants that know foodLoc
                            ret(i) = 1;
                            pathIndex(i) = pathIndex(j);
                            outTime(i) = 0;
                            timeRet(i) = 0;
                            temp = true;
                            break
                        end
                    end
                    if ~temp    %if the ant has not proceeded through the previous steps, meaning they are still free roaming.
                        if timeRet(i) == 1
                            if reached(curLoc,nest)
                                timeRet(i) = 0;
                                antcount(i) = 0;
                                antPath{i} = [nest nest];
                            else
                                antPath{i} = [antPath{i}, pointToPoint(curLoc,nest)];
                            end
                        elseif outTime(i) == timeLim
                            outTime(i) = 0;
                            timeRet(i) = 1;
                            antPath{i} = [antPath{i}, pointToPoint(curLoc,nest)];
                        else
                            lastLoc = antPath{i}(:,end-1);
                            antPath{i} = [antPath{i}, Direction(lastLoc,curLoc)];
                            outTime(i) = outTime(i)+1;
                        end
                    end
                end
            end
        end
    end
end