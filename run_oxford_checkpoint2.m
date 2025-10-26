%% run_oxford_checkpoint2.m
% End-to-end pipeline for Patel & Khade-style SOH reproduction using
% Oxford Battery Degradation Dataset 1 (.mat workspace).
% Two-pass design (no array growth in loops).

clear; clc;

%% ---- Config ----
mat_file = 'Oxford_Battery_Degradation_Dataset_1.mat'; % change if needed
cap_nominal_mAh = 740;     % Kokam 740 mAh pouch cells (dataset nominal)
save_prefix = 'oxford_cp2'; % prefix for output files

% Feature thresholds (Patel & Khade use 3.9, 4.0, 4.1 V)
Vthr = [3.9 4.0 4.1];   % volts
dV_knee = 0.05;         % 50 mV below Vmax to approximate CC→CV knee

%% ---- Load & enumerate ----
S = load(mat_file);
cells = fieldnames(S);
listing = list_cells_and_cycles(S);

fprintf('Found %d cells.\n', numel(cells));
disp(listing(1:min(height(listing),8), :)); % preview

%% ---- Pass 1: count valid rows & collect per-cell reference capacity ----
N = 0;
% store per-cell reference capacities
capRefByCell = containers.Map('KeyType','char','ValueType','double');

for c = 1:numel(cells)
    cellname = cells{c};
    C = S.(cellname);

    % find first available C1dc capacity as reference for this cell
    cap_ref = find_cell_capacity_ref(C);
    capRefByCell(cellname) = cap_ref;

    cycNames = fieldnames(C);
    for j = 1:numel(cycNames)
        cyc = cycNames{j};
        if ~isfield(C.(cyc),'C1ch') || ~isfield(C.(cyc),'C1dc')
            continue
        end
        ch = unwrap_cycle_struct(C.(cyc).C1ch);
        dc = unwrap_cycle_struct(C.(cyc).C1dc);
        if isempty(ch.t) || isempty(ch.v) || isempty(dc.q)
            continue
        end
        % row is valid
        N = N + 1;
    end
end

fprintf('Planned rows after filtering: %d\n', N);

%% ---- Pass 2: preallocate & fill ----
X = nan(N, 6);            % features [F1..F6]
Y = nan(N, 1);            % SOH (%)
Cell_col  = strings(N,1); % for meta table
Cycle_col = nan(N,1);
Cap_col   = nan(N,1);

p = 0; % write pointer

for c = 1:numel(cells)
    cellname = cells{c};
    C = S.(cellname);
    cap_ref = capRefByCell(cellname);
    cycNames = fieldnames(C);

    for j = 1:numel(cycNames)
        cyc = cycNames{j};
        if ~isfield(C.(cyc),'C1ch') || ~isfield(C.(cyc),'C1dc')
            continue
        end

        ch = unwrap_cycle_struct(C.(cyc).C1ch);
        dc = unwrap_cycle_struct(C.(cyc).C1dc);

        % require at least time+voltage for features and q for capacity
        if isempty(ch.t) || isempty(ch.v) || isempty(dc.q)
            continue
        end

        % features from charge (F2..F6)
        F = features_from_C1ch(ch, Vthr, dV_knee);
        cycNum = sscanf(cyc,'cyc%u'); if isempty(cycNum), cycNum = NaN; end
        F(1) = cycNum;

        % target from discharge (SOH vs cell reference capacity)
        [cap_mAh, soh_pct] = soh_from_C1dc(dc, cap_nominal_mAh, cap_ref);

        % write once
        p = p + 1;
        X(p,:)       = F;
        Y(p)         = soh_pct;
        Cell_col(p)  = string(cellname);
        Cycle_col(p) = cycNum;
        Cap_col(p)   = cap_mAh;
    end
end

% If any preallocated rows were unused (shouldn't happen), trim:
if p < N
    X = X(1:p,:); Y = Y(1:p); Cell_col = Cell_col(1:p);
    Cycle_col = Cycle_col(1:p); Cap_col = Cap_col(1:p);
end

% Build meta table once
meta = table(Cell_col, Cycle_col, Cap_col, ...
    'VariableNames', {'Cell','Cycle','Capacity_mAh'});

%% ---- Wrap features into a table & keep rows with a target ----
Xtbl = array2table(X, 'VariableNames', {'F1','F2','F3','F4','F5','F6'});
rowHasY = ~isnan(Y);
Xtbl = Xtbl(rowHasY,:);  Y = Y(rowHasY);  meta = meta(rowHasY,:);

fprintf('Assembled %d samples across cells/cycles.\n', height(Xtbl));

%% ---- Evaluate single-feature linear models (F1..F6) ----
metrics = evaluate_features(Xtbl, Y);
disp(metrics);

% Save metrics
writetable(metrics, [save_prefix '_metrics.csv']);

%% ---- Plot SOH vs best feature ----
[~,ix] = max(metrics.R2);
bestFeature = metrics.Feature(ix);
fprintf('Best feature: %s (R^2=%.3f, RMSE=%.2f)\n', bestFeature, metrics.R2(ix), metrics.RMSE(ix));
hFig = plot_soh_vs_feature(Xtbl, Y, bestFeature);
exportgraphics(hFig, [save_prefix '_soh_vs_' char(bestFeature) '.png'], 'Resolution', 200);

%% ---- Save a tidy dataset for later analysis ----
T = [meta, Xtbl, table(Y,'VariableNames',{'SOH_pct'})];
writetable(T, [save_prefix '_tidy.csv']);

fprintf('Done. Outputs:\n  - %s_metrics.csv\n  - %s_soh_vs_%s.png\n  - %s_tidy.csv\n', ...
    save_prefix, save_prefix, char(bestFeature), save_prefix);
