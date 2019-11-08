classdef gridFile
    % Provides methods for creating and editing .grid files. These are
    % containers for various data sources, including NetCDF files, .mat
    % files, and MATLAB workspace arrays.
    %
    % gridFile Methods:
    %   defineMetadata - Creates a metadata structure for a .grid file, or gridded data source.
    %   new - Creates a new .grid file.
    %   addData - Adds data to a .grid file.
    %   meta - Returns the metadata for a .grid file.
    %   expand - Increases the size of a dimension in a .grid file
    %   rewriteMetadata - Rewrites metadata for a dimension in a .grid file.
    
    % ----- Written By -----
    % Jonathan King, University of Arizona, 2019
    
    properties
        source; % A vector of data sources
        dimOrder; % The internal dimensional order used by the .grid file
        dimLimit; % The index limits of each data source in each dimension (nDim x 2 x nSource)
        metadata; % The metadata along each dimension and data attributes
        gridSize; % The total size of the gridded metadata.
    end
    
    % Static user methods
    methods (Static)
        
        % Create a metadata structure for a grid or gridded data
        [meta] = defineMetadata( varargin )
        
        % Create new grid file
        new( filename, type, source, varName, dimOrder, atts, varargin );
        
        % Adds data to a .grid file
        addData( file, type, source, varName, dimOrder, meta );
        
        % Exract metadata from existing .grid file
        [meta, dimID, gridSize] = meta( file );
        
        % Increase the size of a dimension in a .grid file.
        expand( file, dim, newMeta );
        
        % Change metadata along a dimension
        rewriteMetadata( file, dim, newMeta );
        
    end
   
   % Error checking
   methods (Static)
       
       % Check file existence / extension / correct fields
       fileCheck( file, flag );
       
       % Check that dimensions are recognized
       [dims] = checkDimList( dims, errName );
       
       % Check that dimensions are recognized and non-duplicate
       [sourceDims] = checkSourceDims( sourceDims );
       
       % Check that metadata is allowed
       checkMetadata( meta );
       
       % Indicate whether type is allowed for metadata
       [tf] = ismetadatatype( value );
       
       % Whether data overlaps existing data
       checkOverlap( dimLimit, gridLimit );
       
       % Permutes source grid data to match grid order
       [X] = permuteSource( X, sourceOrder, gridOrder );
       
       % Returns requested data from sources
       [X, passVals] = read( file, start, count, stride );
       
       % Reorders grid scs for source grid order
       [scs] = reorderSCS( scs, gridOrder, sourceOrder )
       
   end
        
end  
        
        