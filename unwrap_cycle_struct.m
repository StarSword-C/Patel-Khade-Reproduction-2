function out = unwrap_cycle_struct(cycleStruct)
% UNWRAP_CYCLE_STRUCT  Flatten Oxford t,v,q,T into numeric column vectors.
% - Works if fields are tables, timetables, or numeric arrays.
% - If a table has multiple vars, it picks the first numeric one.
% - Missing or non-numeric fields become [].

    vars = {'t','v','q','T'};
    for i = 1:numel(vars)
        f = vars{i};
        out.(f) = [];                                  % default
        if ~isfield(cycleStruct, f), continue; end
    
        raw = cycleStruct.(f);
    
        % If already numeric, just vectorize
        if isnumeric(raw)
            out.(f) = raw(:);
            continue
        end
    
        % Table or timetable?
        if istable(raw) || istimetable(raw)
            cNames = raw.Properties.VariableNames;
            % Prefer the first *numeric* variable if multiple exist
            chosen = [];
            for k = 1:numel(cNames)
                col = raw.(cNames{k});
                if isnumeric(col)
                    chosen = col;
                    break
                end
            end
            if isempty(chosen)
                % Fall back to first column (may be non-numeric → will stay empty)
                if ~isempty(cNames) && isnumeric(raw.(cNames{1}))
                    chosen = raw.(cNames{1});
                end
            end
            if ~isempty(chosen)
                out.(f) = chosen(:);
            end
            continue
        end
    
        % Cell array of numeric? (rare)
        if iscell(raw) && ~isempty(raw) && isnumeric(raw{1})
            out.(f) = raw{1}(:);
            continue
        end
    
        % Otherwise leave as []
    end
end
