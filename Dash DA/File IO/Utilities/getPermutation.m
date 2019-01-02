%% This gets the permutation index for two datasets
function[permDex] = getPermutation( X, Y, knownID )
%% Gets the dimension permutation ordering.

% Check that the values are all recognized
allVals = [X(:);Y(:)];
for d = 1:numel(allVals)
    if ( ~ischar(allVals{d}) && ~isstring(allVals{d}) ) || ~ismember(allVals{d},knownID)
        error('dimension ID %s is not a recognized ID.', allVals{d});
    end
end

% Get the maximum number of dims
nDim = numel(knownID);

% Create an index to order the permutation
permDex = NaN( nDim, 1 );

% Get the location of each X in Y
for d = 1:numel(Y)
    
    % Get the location of Y in X
    [~, loc] = ismember( Y{d}, X );
    
    % If empty, mark with NaN
    if loc==0
        loc = NaN;
    end
    
    % Prevent repeated dimensions
    if numel(loc)>1 || (~isnan(loc) && ismember(loc, permDex))
        error('A dimension ID is repeated.');
    end
    
    % Save the permutation index
    permDex(d) = loc;
end

% Fill in singleton dimensions
dims = 1:nDim;
permDex(isnan(permDex)) = dims( ~ismember(dims,permDex) );

end