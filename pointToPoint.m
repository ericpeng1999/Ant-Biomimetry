function [x] = pointToPoint(curLoc,nest)
    % a function that helps the ant construct a retPath when it find the
    % food. It will return a point that is 1 length closer to nest than
    % curLoc. But basicly, it will lead the ant to the second place
    if nest(1)-curLoc(1)>0 && nest(2)-curLoc(2)>0
        temp = zeros(2,1);
        temp(randi(2)) = 1;
        x = curLoc+temp;
    elseif nest(1)-curLoc(1)<0 && nest(2)-curLoc(2)<0
        temp = zeros(2,1);
        temp(randi(2)) = -1;
        x = curLoc+temp;
    elseif nest(1)-curLoc(1)>0 && nest(2)-curLoc(2)<0
        temp = zeros(2,1);
        n = randi(2);
        temp(n) = (-1)^(n+1);
        x = curLoc+temp;
    elseif nest(1)-curLoc(1)<0 && nest(2)-curLoc(2)>0
        temp = zeros(2,1);
        n = randi(2);
        temp(n) = (-1)^(n);
        x = curLoc+temp;
    elseif nest(1)-curLoc(1) == 0
        if nest(2)-curLoc(2)>0
            x = curLoc+[0;1];
        else
            x = curLoc+[0;-1];
        end
    else
        if nest(1)-curLoc(1)>0
            x = curLoc+[1;0];
        else
            x = curLoc+[-1;0];
        end
    end
end