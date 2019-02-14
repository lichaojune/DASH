function[Ye, update, R] = getPSMOutput( F, Mpsm, d, t, nEns, R )

% Attempt to run the PSM
try
    
    % Run with or without R calculation
    if isnan(R)
        [Ye, R] = F.runPSM( Mpsm, d, t );
    else
        Ye = F.runPSM( Mpsm, d, t );
    end
    
    % Also check that the outputs were valid
    checkYe( Ye, nEns );
    if ~isscalar(R) || isnan(R) || isinf(R) || ~isreal(R) || R<=0
        error('R must be a real scalar that is neither NaN nor Inf and is larger than 0.');
    end
    
    % No errors were thrown, so use to update
    update = true;
    
    
% If an error was thrown, notify the user
catch ME
    fprintf(['PSM %0.f failed to run in time step %0.f with the error message: \n', ...
        ME.message, '\n', ...
        'Dash will not use observation %0.f to update the analysis in time step %0.f.\n\n'], ...
        d, t, d, t );
    
    % Block the PSM from updating the analysis
    update = false;
end

end