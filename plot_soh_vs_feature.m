function hFig = plot_soh_vs_feature(Xtbl, Y, featName)
% PLOT_SOH_VS_FEATURE  Scatter + linear fit for SOH vs one feature.
% Accepts featName as string or char. Returns figure handle.

if isstring(featName), featName = char(featName); end
x = Xtbl.(featName);
valid = ~isnan(x) & ~isnan(Y);
x = x(valid); y = Y(valid);

% Guard against degenerate cases
if numel(x) < 3 || range(x)==0
    warning('Not enough variation in %s to plot a fit.', featName);
    hFig = figure('Color','w'); scatter(x, y, 'filled'); grid on
    xlabel(featName, 'Interpreter','none'); ylabel('SOH (%)');
    title(sprintf('SOH vs %s (no fit)', featName), 'Interpreter','none');
    return
end

mdl = fitlm(x, y);
xx  = linspace(min(x), max(x), 200)'; 
yy  = predict(mdl, xx);

hFig = figure('Color','w');
scatter(x, y, 'filled'); hold on
plot(xx, yy, 'LineWidth', 2)
grid on
xlabel(featName, 'Interpreter','none')
ylabel('SOH (%)')
rmse_val = sqrt(mean((y - predict(mdl, x)).^2));
title(sprintf('SOH vs %s — R^2=%.3f, RMSE=%.2f', ...
      featName, mdl.Rsquared.Ordinary, rmse_val), 'Interpreter','none');
end
