function draw(nest,foodLoc,antPath,Population,ret,retPath,pathIndex)
    figure(1)
    clf
    hold on
    if sum(ret) == 0        % if food has not been located and no ant is returning
        for i = 1:Population
            plot(antPath{i}(1,end),antPath{i}(2,end),'b.')
        end
    else                    % if food has been located and ants are returning
        for i = retPath     % plot the food track.
            plot(i(1),i(2),'r.')
        end
        index = find(ret);  % the index of the ants who are returning.
        for i = 1:Population
            temp = false;   %check if this ant is in return mode. temp will be determined in the for loop below.
            for j = index
                if i == j
                    position = retPath(:,pathIndex(i));
                    plot(position(1),position(2),'b.')
                    temp = true;
                    break
                end
            end
            if ~temp
                plot(antPath{i}(1,end),antPath{i}(2,end),'b.')
            end
        end
    end
    plot(nest(1),nest(2),'k.','MarkerSize',20)
    plot(foodLoc(1),foodLoc(2),'m.','MarkerSize',20)
    xlim([0 100])
    ylim([0 100])
    drawnow
end