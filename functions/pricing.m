function result = pricing(port_new,port,factor)
% set-up
[T_p,N_p] = size(port);
[T_f,N_f] = size(factor);
result.beta = zeros(N_f+2,N_p); % betas of pricing model (alpha in the first row)
result.tstat = zeros(N_f+2,N_p); % t-stat of estimated betas
result.residual = zeros(T_f,N_p); % residuals of regression
result.sig2eps = zeros(1,N_p); % error variance in regression
result.Sharpe_excess = zeros(1,N_p);
% regression analysis
for n = 1:N_p
reg_nw = NWtest(port_new(T_p-T_f+1:T_p,n),[port(T_p-T_f+1:T_p,n),factor],12);
result.beta(:,n) = reg_nw.beta;
result.tstat(:,n) = reg_nw.tstat;
result.residual(:,n) = reg_nw.residual;
% excess Sharpe ratio
index = setdiff(1:T_f,find(isnan(result.residual(:,n))));
result.sig2eps(n) = sum(result.residual(index,n).^2)/(length(index)-1-N_f);
end
result.Sharpe_excess = result.beta(1,:)./sqrt(result.sig2eps);
end