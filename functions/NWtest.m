function result = NWtest(y,x,maxlag)
[result.V,result.se,result.beta]=hac(x,y,'bandwidth',...
    maxlag+1,'display','off');
result.tstat = result.beta./result.se;
T = length(x);
result.residual = zeros(T,1);
result.residual = y-[ones(T,1),x]*result.beta;
end