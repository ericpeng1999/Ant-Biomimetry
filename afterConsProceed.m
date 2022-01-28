function [ret,retPath,antPath,pathIndex,nest,foodLoc,retStatus,outTime,timeRet] = afterConsProceed(teleInfo,ret,retStatus,Population,antPath,retPath,pathIndex,nest,foodLoc,len,outTime,timeRet,timeLim)
    for i = 1:Population
        if ret(i) == 1
            loc = pathIndex(i);
            if loc == len       %check if this ant has reached the nest. If yes, turn the retStatus to 1, meaning it should go back to food.
                retStatus(i) = 1;
            elseif loc == 1
                retStatus(i) = 0;
            end
            if retStatus(i) == 0
                pathIndex(i) = loc+1;
            else
                pathIndex(i) = loc-1;
            end
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
                for j = 1:size(retPath,2)           %check if the ant is in approximity of the road starting from the foodLoc. Due to this reason, the ant can only enter the retPath at the foodLoc.
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
                        if reached(curLoc,nest)     %ant will know information of food when they returned to nest.
                            timeRet(i) = 0;
                            ret(i) = 1;
                            pathIndex(i) = len;
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