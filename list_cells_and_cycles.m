function listing = list_cells_and_cycles(S)
% Return a table of available cells and cycle names.

cells = fieldnames(S);
C = {}; Y = {};
for i = 1:numel(cells)
    cellname = cells{i};
    cyc = fieldnames(S.(cellname));
    C = [C; repmat({cellname}, numel(cyc), 1)];
    Y = [Y; cyc];
end
listing = table(string(C), string(Y), 'VariableNames', {'Cell','Cycle'});
end
