function [cap_mAh, soh_pct] = soh_from_C1dc(dc, cap_nominal_mAh, cap_ref_mAh)
% Compute capacity (mAh) and SOH (%) for a characterization discharge trace.
% cap_ref_mAh: reference capacity (e.g., first characterization for that cell).
% If cap_ref_mAh is provided and finite, SOH is relative to that; otherwise vs nominal.

    q = dc.q(:);
    if isempty(q)
        cap_mAh = NaN; soh_pct = NaN; return;
    end
    
    cap_mAh = max(q) - min(q);
    if nargin >= 3 && isfinite(cap_ref_mAh)
        soh_pct = 100 * (cap_mAh / cap_ref_mAh);
    else
        soh_pct = 100 * (cap_mAh / cap_nominal_mAh);
    end
end
