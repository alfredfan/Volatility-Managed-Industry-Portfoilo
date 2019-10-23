function result = getVMret(input,RV,rf)
    [T,N] = size(input);
    result.port = input-rf; % 'port': original excess return
    result.VMret = zeros(T,N); % 'VMret': unadjusted volatility-managed return
    result.VMret(1,:) = nan; 
    % previous volatility of first month in sample is not available
    for t = 2:T
        result.VMret(t,:) = (result.port(t,:)-rf(t))./RV(t-1,:);
    end
    % adjusted with previous month realized variance
    result.c = zeros(1,N);
    result.var_unc = zeros(1,N); % unconditional variance
    for n = 1:N
        result.var_unc(n) = nanvar(result.port(:,n));
        result.c(n) = sqrt(result.var_unc(n)/nanvar(result.VMret(:,n)));
    end
    % constant c to normalize new returns with same unconditional variance ()
    result.port_normalize = result.VMret.*result.c; % result desired
end
