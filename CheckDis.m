function [a] = CheckDis(X,Y)
    %X,Y are two 2*1 matrix. Return true if the distance is too close.
    dis = 8;
    if norm(X-Y) <= dis
        a = true;
    else
        a = false;
    end
end