function cap_ref = find_cell_capacity_ref(CellStruct)
% FIND_CELL_CAPACITY_REF  Return first available C1dc capacity (mAh) for a cell.
%   If none found, returns NaN.

    cap_ref = NaN;
    cycNames = fieldnames(CellStruct);
    for jj = 1:numel(cycNames)
        cyc = cycNames{jj};
        if isfield(CellStruct.(cyc),'C1dc')
            dc0 = unwrap_cycle_struct(CellStruct.(cyc).C1dc);
            if ~isempty(dc0.q)
                cap_ref = max(dc0.q) - min(dc0.q);
                return
            end
        end
    end
end
