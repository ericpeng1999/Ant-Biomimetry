function [ret] = Direction(lastLoc,curLoc)
    while true      %this code will contitnue running until the next movement will not result to a return to the previous location.
        dir = zeros(2,2);
        dir(randi(4)) = (-1)^(randi(2));
        if sum(dir(:,2)) == 0
            x = dir(:,1);
        else
            x = dir(:,2);
        end
        ret = x+curLoc;
        if ~isequal(ret,lastLoc)
            break
        end
    end
end