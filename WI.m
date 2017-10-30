function[p_val]=WI(Y,X)
    % function to compute the p_value from the Wald test in simple linear
    % regression.
    % H_0: \beta_1 = 0 
    n = size(Y,1);
    YY = Y - mean(Y);
    XX = X - mean(X);
    beta = XX'*Y/(XX'*XX);
    MSE = (YY-XX*beta)'*(YY-XX*beta)/(n-2);
    T = beta^2/MSE;
    p_val = 1-chi2cdf(T,2);
end
