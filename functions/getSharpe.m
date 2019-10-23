function result = getSharpe(original,managed,rf)
    [T,N] = size(original);
    result.beta = zeros(2,N); % esimated beta on managed-origianl regression
    result.sig2eps = zeros(1,N); % error of variance used for excess Sharpe
    for n = 1:N
        [result.beta(:,n),~,~,~,stat] = regress(managed(:,n),...
            [ones(T,1),original(:,n)]);
        result.sig2eps(n) = stat(4);
    end
    % run regression on managed and original data, record the error variance
    result.appraisal = sqrt(12)*result.beta(1,:)./(sqrt(result.sig2eps));
    % excess Sharpe ratio
    result.Sharpe_old = sqrt(12)*(nanmean(original)-rf)./(nanstd(original));
    % Sharpe ratio calculated by original data
    result.UV = (result.appraisal./result.Sharpe_old).^2;
    % equivalent form of utility gain
end