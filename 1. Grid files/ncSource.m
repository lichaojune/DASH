classdef ncSource < dataSource
    %% Implements a NetCDF data source
    
    % Constructor
    methods
        function obj = ncSource(file, var, dims)
            
            % First call the data source constructor for initial error
            % checking and to save the input args
            obj@dataSource(file, var, dims);
            
            % Check the file is actually a NetCDF
            try
                info = ncinfo( obj.file );
            catch
                error('The file %s is not a valid NetCDF file.', obj.file );
            end
            
            % Check that the variable is in the file
            nVars = numel(info.Variables);
            fileVariables = cell(nVars,1);
            [fileVariables{:}] = deal( info.Variables.Name );
            obj.checkVariable( fileVariables );
            
            % Get the data type and size of the array
            [~,v] = ismember(obj.var, fileVariables);
            obj.dataType = info.Variables(v).Datatype;
            obj.unmergedSize = info.Variables(v).Size;
        end
    end
    
end
            