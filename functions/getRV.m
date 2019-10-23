% This function aims to obtain the realized variance of the monthly
% portfolio returns for each industry
function RV = getRV(port,date)
N=size(port,2);
YM = unique(floor(date/100));
% 'YM': all the year-month combinations
t = length(YM);
RV = zeros(t,N); % initialize the vector    
    for s = 1:t
        first = min(find(floor(date/100)==YM(s)));
        last = max(find(floor(date/100)==YM(s)));
        % find the first and last day in each combination of (year, month)
        for n = 1:N
            RV(s,n)= var(port(first:last,n))*(last-first);
        end
        % roughly, RV = \sum_{t=1}^22 [r_t-mean(r)]^2 = var(r_t)*22
    end
end