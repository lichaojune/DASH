%% This is a custom structure that stores an array of variable designs and 
% allows indexing by variable name.
classdef stateDesign < handle
    
    properties
        % Variable properties
        varDesign;  % The array of variable designs
        var;        % The variable names. Used for indexing.
        
        % Coupler properties
        isCoupled;  % Whether ensemble indices are coupled.
        coupleState;   % Whether state indices are coupled
        coupleSeq;   % Whether sequence indices are coupled
        coupleMean;  % Whether mean indices are coupled
    end
    
    methods
        %% Constructor
        function obj = stateDesign( varDesign, var )
            obj.errorCheck(varDesign, var);
            obj.varDesign = varDesign;
            obj.var = {var};
            
            % Initialize the coupler properties.
            obj.isCoupled = false;
            obj.coupleState = false;
            obj.coupleSeq = false;
            obj.coupleMean = false;
        end
        
        %% Adds another variable
        function[obj] = addVar( obj, varDesign, var )
            
            % Error check
            obj.errorCheck(varDesign, var);
            
            % Check that the variable is not a repeat
            if ismember(var, obj.var)
                error('Cannot repeat variable names.');
            end
            
            % Add the variable
            obj.varDesign = [obj.varDesign; varDesign];
            obj.var = [obj.var; {var}];
            
            % Adds coupler indices
            obj.isCoupled(end+1,end+1) = false;
            obj.coupleState(end+1,end+1) = false;
            obj.coupleSeq(end+1,end+1) = false;
            obj.coupleMean(end+1,end+1) = false;
        end 
    end
    
    methods (Static = true)
        %% Error checks the inputs
        function[] = errorCheck( varDesign, var )
            if ~isa(varDesign, 'varDesign')
                error('varDesign must be of the ''varDesign'' class.');
            elseif ~(isstring(var) && isscalar(var)) && ~(ischar(var) && isvector(var))
                error('var must be a string.');
            end
        end 
    end
end