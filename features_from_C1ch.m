function F = features_from_C1ch(ch, Vthr, dV_knee)
    % Compute [F1..F6], where F1 will be filled by caller (cycle index).
    % F2 = CC duration (s); F3 = CV duration (s)
    % F4..F6 = times to Vthr(1:3) (s) from charge start.
    % Inputs:
    %   ch.t (s), ch.v (V) as numeric vectors
    %   Vthr = [3.9 4.0 4.1] (default in caller)
    %   dV_knee = e.g., 0.05 V below Vmax
    
    t = ch.t(:); v = ch.v(:);
    F = nan(1,6);
    if isempty(t) || isempty(v) || numel(t) < 2, return; end
    
    t0 = t(1);  tEnd = t(end);
    Vmax = max(v);
    % Knee: first time voltage approaches the top plateau (Vmax - dV_knee)
    iKnee = find(v >= Vmax - dV_knee, 1, 'first');
    if isempty(iKnee), iKnee = numel(v); end
    
    F(2) = t(iKnee) - t0;     % CC duration
    F(3) = tEnd - t(iKnee);   % CV duration
    
    % Time-to-voltage thresholds
    for k = 1:numel(Vthr)
        idx = find(v >= Vthr(k), 1, 'first');
        if ~isempty(idx), F(3+k) = t(idx) - t0; end
    end
end
