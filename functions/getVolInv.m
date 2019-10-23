function vol_inv = getVolInv(input,rf)
    port = input - rf; % excess return
    [T,N] = size(port);
    vol = zeros(T,N); % initialize the vector
    for n = 1:N
        index = find(isnan(port(:,n))==0,1,'first');
        vol(1:index+35,n) = nan;
        for t = index+36:T
        vol(t,n) = nanstd(port(t-36:t-1,n)); % 3-year rolling volatility
        end
    end
    vol_inv = 1./vol; % inverse of volatility
end