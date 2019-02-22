function[sampDex] = eraseRepeat( sampDex, nSeq, ensDex )
%% Removes a sequence overlap
%
% sampDex: Ensemble draws
%
% nSeq: Size of a sequence
%
% ----- Written By -----
% Jonathan King, University of Arizona, 2019

% Find the indices of draws with repeat elements
repeat = find( isrepeat( sampDex, 'rows', 'stable' ) );
repeat = unique( ceil( repeat / nSeq ) );
repeat = ( (repeat-1)*nSeq ) + (1:nSeq);
repeat = repeat(:);

% Erase repeats
sampDex(repeat,:) = NaN;

% Get the set of non-repeats
allDex = (1:size(sampDex,1))';
nonrep = allDex( ~ismember( allDex, repeat ) );

% Rearrange so that NaN values are at the end
sampDex = sampDex( [nonrep; repeat], : );

end