function [CleanData, Outliers] = removeOutliers(Data, eps1, eps2)
% Clean the data by removing outliers. A point is considered an outlier if
% the distance to its two neighbors is greater than eps.
    
    
    % Initialization of the output arrays
    CleanData = [];
    Outliers = [];
    
    % Extraction of the data
    t = Data(:,1);
    x = Data(:,2);
    n_data = size(t,1); % number of pairs (t,x) in the dataset
    
    % Define a metric
    dist = @(x1,x2) abs(abs(x1)-abs(x2));
    
    
    for i = 1:n_data
        
        if x(i) < 25 && x(i) > -25
            eps = eps2; % Most of the spikes (i.e. outliers) occur for values of x close to 0. The limits have therefore been defined in a more restrictive way for these points.
        else
            eps = eps1;
        end
        
        if i == 1
            if dist(x(i),x(i+1)) > eps
                Outliers = [Outliers ; t(i),x(i)];
            else
                CleanData = [CleanData ; t(i),x(i)];
            end
        
        elseif i == n_data
            if dist(x(i),x(i-1)) > eps
                Outliers = [Outliers ; t(i),x(i)];
            else
                CleanData = [CleanData ; t(i),x(i)];
            end
        
        else
            if dist(x(i),x(i-1)) > eps && dist(x(i),x(i+1)) > eps
                Outliers = [Outliers ; t(i),x(i)];
            else
                CleanData = [CleanData ; t(i),x(i)];
            end
        
        end
        
    end
    
end