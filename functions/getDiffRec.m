function result = getDiffRec(original,managed,rec)
port = managed - original;
[T,N] = size(port);
result = zeros(2,N); % (recession) - (non-recession)
    for n = 1:N
       beta = regress(port(:,n),[ones(T,1),rec]);
       result(2,n) = beta(1);
       result(1,n) = beta(1)+beta(2);
    end
end
% if 'difference' is positive, then it illustrates the average return 
% in recession are higher than that of non-recession