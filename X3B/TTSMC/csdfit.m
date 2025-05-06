function [x, nll]=csdfit(stim,respC,b,res)
% 2015 Massachusetts Eye and Ear Infirmary.  All rights reserved.
%
%CSDfit Fit a confidence response model.
%   as described in detail by Yi and Merfeld in their Journal of 
%   Neurophysiology paper entitled:
%   Perceptual threshold estimation can be markedly improved by recording 
%   and modeling confidence"
%
%   X = CSDFIT(STIM,RESPC,INI,RES) fits a generalized linear model using the
%   stimulus matrix STIM, confidence response RESPC, 
%   initial value for the optimization INI, and resolution RES. 
%   The result X is a vector of coefficient estimates.  Acceptable values 
%   for INI are 2*1(or 1*2) or 3*1(or 1*3) matrix.  Acceptable values 
%   for RES are bigger than 0 and smaller than 1(or 100). 
%
%   STIM is a matrix with rows corresponding to observations, and columns to
%   predictor variables. RESPC is a vector of response values. 
%
%   [X,NLL] = CSDFIT(...) returns the negative log-likelihood of the fit.
%
%   References:

%   Copyright 2015 Massachusetts Eye and Ear Infirmary.
%   $Revision: 0.9.8.15 $  $Date: 2015/09/30 12:10:00 $

    if res>1,   res=res/100;   end
    delta=res/2;  
    respCR=(round(respC/res))*res;

    if length(b)==2
        x0 = [-b(1)/b(2) 1/b(2)]; 
        if x0(2)<=0, x0=[0 1]; end
        x_lb = [x0(1)-5*x0(2) 0.2*x0(2)];    x_ub = [x0(1)+5*x0(2) 5*x0(2)];
    elseif length(b)==3
        x0 = [-b(1)/b(2) 1/b(2) 1/b(3)]; 
        if x0(2)<=0, x0=[0 1 1]; end
        x_lb = [x0(1)-5*x0(2) 0.2*x0(2) 0.2*x0(3)];	x_ub = [x0(1)+5*x0(2) 5*x0(2) 5*x0(3)] ;        
    end

    options = optimset('Display','off','Algorithm','interior-point');
    [x, nll, ~, ~] = fmincon(@NegLogLikelihood, x0, [], [], [], [], x_lb, x_ub, [], options, stim, respCR, delta);

end

function nll = NegLogLikelihood(x, tstim, respCR, delta)

    probC = dist_SDT(x, tstim, respCR, delta);
    logpC=log(probC);
    if ~isempty(logpC(probC~=0))
    logpC(logpC==-inf)=min(logpC(probC~=0))*1.5;
    end
    nll = -nansum(logpC);     
    penalty = 1.0e20;
    if ~isreal(nll) || isinf(nll), nll = penalty; end
    if abs(nll)<1, nll = penalty; end
    if x(3)/x(2)>10, nll = penalty; end
    
end

function probC = dist_SDT(x, tstim, respCR, delta)
    
    for ii=1:length(respCR)
        if length(x)==2
            x_upper=norminv(respCR(ii)+delta,x(1),x(2));
            x_lower=norminv(respCR(ii)-delta,x(1),x(2));
        elseif length(x)==3
            x_upper=norminv(respCR(ii)+delta,x(1),x(3));
            x_lower=norminv(respCR(ii)-delta,x(1),x(3));
        end
        
        cdf_upper=normcdf(x_upper,tstim(ii),x(2));
        cdf_lower=normcdf(x_lower,tstim(ii),x(2));

        if isnan(cdf_upper), cdf_upper=1; end
        if isnan(cdf_lower), cdf_lower=0; end
                
        probC(ii)=cdf_upper-cdf_lower;
    end
    
end
