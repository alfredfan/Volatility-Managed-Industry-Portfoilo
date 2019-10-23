%% notes of data
% 'FF3': monthly Fama-French five factors, 1926/07-2018/12
% order of variables: 'rmrf','smb','hml','rf'
% 'FF5': monthly Fama-French five factors, 1967/07-2018/12
% order of variables: 'rmrf','smb','hml','rmw','cma','rf'
% 'ind_equal_daily': daily equal-weighted returns of 48 industry portfolios
% 'ind_equal': monthly equal-weighted returns of 48 industry portfolios
% 'NBER_rec': NBER recession indicator in the same sample period
addpath('./functions');
%% part 2 excess return of volatility-managed portfolios
% 2.1 realized variance of each month
RV_equal = getRV(ind_equal_daily,date);
% 2.2 volatility-managed excessreturn
VMret_equal = getVMret(ind_equal,RV_equal,FF3(:,4)); % excess return
%% part 3 comparison between managed & original portfolios
rf = FF3(:,4);
FF1_ind_managed2 = pricing(VMret_equal.port_normalize-rf,ind_equal-rf,FF3(:,1));
FF3_ind_managed2 = pricing(VMret_equal.port_normalize-rf,ind_equal-rf,FF3(:,1:3));
FF5_ind_managed2 = pricing(VMret_equal.port_normalize-rf,ind_equal-rf,FF5(:,1:5));
%% 3.3 excess Sharpe ratio and utility gain
Sharpe_equal = getSharpe(ind_equal,VMret_equal.port_normalize,mean(FF3(:,4)));
%% 3.4 return difference during NBER defined recession
DiffRec_equal = getDiffRec(ind_equal,VMret_equal.port_normalize,NBER_rec);
%% 3.5 efficient frontier of original/managed portfolios
EF_equal_original = mvp(nanmean(ind_equal), ...
    cov(ind_equal,'partialrows'), mean(FF3(:,4)), 1,...
    'equal-weighted original industry portfolio', 'EF_equal_original');
EF_equal_managed = mvp(nanmean(VMret_equal.port_normalize), ...
    cov(VMret_equal.port_normalize,'partialrows'), mean(FF3(:,4)), 1,...
    'equal-weighted managed industry portfolio', 'EF_equal_managed');
%% part 4 risk-parity portfolio
% 4.1 inverse of three-year rolling volatility (use original portfolio)
volinv_equal = getVolInv(ind_equal,FF3(:,4)); 
% 4.2 construct risk parity portfolio (use original portfolio)
retRP1_equal = getRP(ind_equal,FF3(:,4),volinv_equal,1,FF3(:,1)); % unlever
retRP2_equal = getRP(ind_equal,FF3(:,4),volinv_equal,2,FF3(:,1)); % lever
% 4.3 inverse of three-year rolling volatility (use managed portfolio)
volinv_equalVM = getVolInv(ind_equal,FF3(:,4)); 
% 4.4 construct risk parity portfolio (use managed portfolio)
retRP1_equalVM = getRP(VMret_equal.port_normalize,FF3(:,4),...
    volinv_equalVM,1,FF3(:,1)); % unlever
retRP2_equalVM = getRP(VMret_equal.port_normalize,FF3(:,4),...
    volinv_equalVM,2,FF3(:,1)); % lever
%% 4.5 CAPM, FF3 and FF5 pricing on risk-parity using original returns
% levered risk parity portfolios
FF1_rp1_equal_original = pricing([FF3(:,1),FF3(:,4)],retRP1_equal.rpRet_unlever,1,0);
FF3_rp1_equal_original = pricing(FF3,retRP1_equal.rpRet_unlever,3,0);
FF5_rp1_equal_original = pricing(FF5,retRP1_equal.rpRet_unlever,5,0);
% unlevered risk parity portfolios
FF1_rp2_equal_original = pricing([FF3(:,1),FF3(:,4)],retRP2_equal.rpRet_lever,1,0);
FF3_rp2_equal_original = pricing(FF3,retRP2_equal.rpRet_lever,3,0);
FF5_rp2_equal_original = pricing(FF5,retRP2_equal.rpRet_lever,5,0);
% 4.6 CAPM, FF3 and FF5 pricing on risk-parity using original returns
% levered risk parity portfolios
FF1_rp1_equal_managed = pricing([FF3(:,1),FF3(:,4)],retRP1_equalVM.rpRet_unlever,1,0);
FF3_rp1_equal_managed = pricing(FF3,retRP1_equalVM.rpRet_unlever,3,0);
FF5_rp1_equal_managed = pricing(FF5,retRP1_equalVM.rpRet_unlever,5,0);
% unlevered risk parity portfolios
FF1_rp2_equal_managed = pricing([FF3(:,1),FF3(:,4)],retRP2_equalVM.rpRet_lever,1,0);
FF3_rp2_equal_managed = pricing(FF3,retRP2_equalVM.rpRet_lever,3,0);
FF5_rp2_equal_managed = pricing(FF5,retRP2_equalVM.rpRet_lever,5,0);