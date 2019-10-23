function result = getRP(input,rf,volinv,lever,benchmark)
[T,N] = size(volinv);
result.port = input - rf; % excess return
    if lever == 1 % unlever
        result.weights_unlever = nan(T,N);
        result.rpRet_unlever = nan(T,1);
        for t = 37:T
            result.weights_unlever(t,:) = volinv(t,:)./(nansum(volinv(t,:))); % exclude nan volatilies
            result.rpRet_unlever(t) = nansum(result.weights_unlever(t-1,:).*result.port(t,:));
        end
        result.rpRet_unlever(37) = nan;
    elseif lever == 2 % lever
        result.weights_lever = nan(T,N);
        result.rpRet_lever = nan(T,1);
        result.vol_benchmark = std(benchmark);
        for t = 37:T
            result.weights_lever(t,:) = volinv(t,:);
            result.rpRet_lever(t) = nansum(result.weights_lever(t-1,:).*result.port(t,:));
        end 
        result.k = result.vol_benchmark/nanstd(result.rpRet_lever); 
        % find k to reach same unconditional variance
        result.rpRet_lever = result.rpRet_lever*result.k; % normalize the returns
        result.rpRet_lever(37) = nan; % no information of inverse volatility
    end
end