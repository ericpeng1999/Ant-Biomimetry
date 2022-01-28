function [a] = reached(X,Y)
    % X,Y are two 2*1 vector.
    % return true if the distance between X and Y are 0. false otherwise.
    if norm(X-Y) == 0
        a = true;
    else
        a = false;
    end
end