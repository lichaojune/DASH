function[varargout] = parseInputs( inArgs, flags, defaults, nPrev )
%% Parses inputs for flag, value input pairs. 
%
% [values] = dash.parseInputs( inArgs, flags, defaults, switches )
%
% ----- Inputs -----
%
% inArgs: Typically, varargin for a function call. A cell vector.
%
% flags: All the possible string flags. A string vector or cellstring
%    vector.
%
% defaults: A cell vector. Must have one element for each flag. Each
%    element contains the default value for the corresponding flag.
%
% nPrev: The number of previous input arguments.
%
% ----- Outputs -----
%
% values: The parsed values. A cell vector. Has one element for each flag.

% Error check the inputs
assertCellVector(inArgs, "inArgs");
dash.assertStrList(flags, "flags");
assertCellVector(defaults, "defaults");

flags = string(flags);
nFlags = numel(flags);
if nFlags > numel(unique(flags))
    error('flags contains duplicate values');
elseif numel(defaults) ~= nFlags
    error('The number of elements in defaults (%.f) does not match the number of flags (%.f)', numel(defaults), nFlags);
elseif mod(numel(inArgs),2)~=0
    error('You must provide an even number of ''name'', value input arguments after the first %.f inputs.', nPrev);
end

% Initialize output to default values
varargout = defaults;

% If there are inputs to parse, check that values are not set multiple times
if ~isempty(inArgs)
    setValue = false(nFlags, 1);
    
    % Check that the input flags are strings and recognized
    for k = 1:2:numel(inArgs)
        dash.assertStrFlag(inArgs{k}, sprintf('Input %.f', k+nPrev));
        f = strcmp(inArgs{k}, flags);
        if sum(f)==0
            error('Input %.f is not a recognized flag. Allowed flags are %s.', k+nPrev, dash.errorStringList(flags));
        elseif setValue(f)
            error('The %s flag is set multiple times.', flags(f));
        end
        
        % Set the value
        setValue(f) = true;
        varargout{f} = inArgs{k+1};
    end
end

end

function[] = assertCellVector(input, name)
    if ~iscell(input) || ~isvector(name)
        error('%s must be a cell vector.', name);
    end
end