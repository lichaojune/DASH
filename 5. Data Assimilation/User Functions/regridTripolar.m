function[rA, dimID] = regridTripolar( A, var, ensMeta, design, ocnDex, gridSize, varargin )
%% Regrids a tripolar variable from a particular time step for a DA analysis.
%
% [rA, dimID] = regridTripolar( A, var, ensMeta, design, ocnDex, gridSize )
% Regrids a variable on a tripolar grid. Removes any singleton dimensions.
%
% [rA, dimID] = regridTripolar( ..., 'nosqueeze' )
% Preserves all singleton dimensions.
%
% ----- Inputs -----
%
% A: The mean or variance state vector from a particular time step of an
%   udpate analysis. (nState x 1)
%
% var: The name of a variable. Must be a string.
%
% ensMeta: Ensemble metadata
%
% design: A state vector design.
%
% ocnDex: A set of logical indices that point to non-nan indices on a
% tripolar grid. (nTripole x 1)
%
% gridSize: size of the original tripolar grid. (2 x 1)
%
% ----- Outputs -----
%
% rA: A regridded analysis for one variable.
%
% dimID: The dimensional ordering of the regridded variable.

% ----- Written by -----
% Jonathan King, University of Arizona, 2019

% Check that gridsize is allowed
if ~islogical(ocnDex) || ~isvector(ocnDex)
    error('ocnDex must be a logical vector the size of the tripolar dimension.');
elseif numel(gridSize)~=2 || any(gridSize<1) || any(mod(gridSize,1)~=0) || ...
        prod(gridSize)~=numel(ocnDex)
    error('gridSize must be a 2-element vector with the size of the original tripolar spatial grid.');
end

% First, regrid the analysis
[A, dimID] = regridAnalysis( A, var, ensMeta, design, varargin{:} );

% Get the tripole dimension
[~,~,triDim] = getKnownIDs;
d = find( strcmp(dimID, triDim) );

% Preallocate the full grid including land
siz = size(A);
siz(d) = numel(ocnDex);
rA = NaN(siz);

% Get the indices of the ocean grids
allDex = repmat( {':'}, [numel(dimID),1] );
allDex{d} = ocnDex;

% Add the values of the ocean grids
rA(allDex{:}) = A;

% Get the size of the regridded analysis
siz = siz([1:d, d:end]);
siz(d) = gridSize(1);
siz(d+1) = gridSize(2);

% Reshape to original size
rA = reshape( rA, siz );

% Update the dimension IDs
dimID = dimID([1:d, d:end]);
dimID{d} = 'tri1';
dimID{d+1} = 'tri2';

end