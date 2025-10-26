function metrics = evaluate_features(Xtbl, SOH)
    % Evaluate six independent linear models (one per feature) vs SOH.
    
    names = Xtbl.Properties.VariableNames;
    m = numel(names);
    
    % Preallocate columns
    Feature = strings(m,1);
    RMSE    = nan(m,1);
    MAE     = nan(m,1);
    MAPE    = nan(m,1);
    R2      = nan(m,1);
    
    for j = 1:m
        Feature(j) = string(names{j});
        x = Xtbl{:,j};
    
        valid = ~isnan(x) & ~isnan(SOH);
        idx   = find(valid);
    
        % Skip if too few samples to hold out
        if numel(idx) < 10
            continue
        end
    
        cv = cvpartition(numel(idx),'HoldOut',0.3);
        tr = idx(training(cv));
        te = idx(test(cv));
    
        mdl  = fitlm(x(tr), SOH(tr));
        yhat = predict(mdl, x(te));
        err  = SOH(te) - yhat;
    
        RMSE(j) = sqrt(mean(err.^2));
        MAE(j)  = mean(abs(err));
        MAPE(j) = mean(abs(err ./ SOH(te))) * 100;
        R2(j)   = 1 - sum(err.^2) / sum((SOH(te) - mean(SOH(te))).^2);
    end
    
    % Build table once and drop rows that were skipped (all NaNs in metrics)
    metrics = table(Feature, RMSE, MAE, MAPE, R2);
    drop = isnan(RMSE) & isnan(MAE) & isnan(MAPE) & isnan(R2);
    metrics(drop,:) = [];
end