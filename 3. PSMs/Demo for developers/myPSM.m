%% This is a verbose template for designing a new PSM

% The first line of code says that this file describes a 'myPSM' object
% 
% The "myPSM < PSM" section says that the 'myPSM' object is a specific type
% of PSM. This means that "myPSM" is required to implement all the
% functions from the PSM interface.
%
% To create your own PSM, change "myPSM" to the desired name of your PSM.
classdef myPSM < PSM
    
    % This section describes the properties of myPSM
    %
    % These are the variables that are stored in each individual instance
    % of a myPSM. If I make multiple myPSM objects (because I have multiple
    % proxies that use a myPSM), every myPSM object will have these
    % variables. However, the values stored in these variables can be
    % different for each individual myPSM object.
    %
    % For example, I might make two myPSM objects, one for site A and one
    % for site B. Say I make a "coordinates" property. Then myPSM A and 
    % myPSM B will both store values associated with the coordinates of a
    % site. But the actual coordinates stored by myPSM A will be different
    % from the coordinates stored by myPSM B.
    %
    % (A note on terminology: from this point onward, I will refer to
    % individual PSM objects as an "instance" of a particular PSM.)
    %
    % In this template, I list some possible properties. However, these are
    % non-exhaustive and only suggestions. The specific properties needed
    % for each PSM will vary.
    properties
        
        coordinates;     % Site coordinates (Used to select optimal sites from the state vector)
        
        myProp1;   % Some properties needed to run a myPSM
        myProp2;
        myProp3;
        
        % You can set a default value for a property by setting it equal to
        % the default value in the "properties" block.
        myPropX = 100;    % A property with a default value of 100 
    end
    
    % This next section describes the methods of a myPSM
    %
    % These are the individual functions specific to a myPSM. They MUST
    % include the functions specified by the "PSM" interface, but can also
    % include other functions needed to make the PSM work.
    methods
        
        % CONSTRUCTOR
        %
        % All PSMs must include a special function called a constructor.
        % This is a function with the same name as the myPSM. It is
        % responsible for actually creating and initializing each instance
        % of a myPSM. It returns a single output (traditionally named "obj"
        % (for "object"), which is the specific instance of a myPSM.
        function obj = myPSM( coord, propVal1, input3, varargin )
            
            % The primary responsibility of the constructor method is to
            % intialize all the properties for the PSM. Let's do that now
            %
            % Use dot indexing to access the value in a property or to
            % change the value in a property. This is very similar to a
            % "struct" object (a structure).
            obj.coordinates = coord;
            obj.myProp1 = propVal1;
            
            % Get the value of myProp2, which requires some additional
            % calculations.
            obj.myProp2 = myFunction( input3 );
            
            % Say the value of myProp3 depends in some way on running the
            % forward model on the prior model ensemble. For example,
            % "myProp3" could be a standardization determined by running
            % the PSM on the first model time step.
            %
            % We'll want to calculate myProp3 later, so we'll just
            % initialize it as empty now.
            obj.myProp3 = [];
            
            % This is also a good place to change any default properties.
            % Here is an example of some code that could change the default
            % value in myProp3.
            %
            % If the user gives a 5th input, it will replace the default
            % value of myPropX.
            if ~isempty(varargin)
                obj.myPropX = varargin;
            end
        end
        
        % Let's say we still need to determine the value of myProp3. Here
        % is a method that will do that.
        %
        % To run a method, we will use dot indexing. This is a little
        % different from normal functions.
        % To run "myMethod", we will need to create an actual instance of a
        % "myPSM" (using the constructor), and then call the function using
        % dot indexing, so
        %
        % >> A = myPSM( coord, propVal1, input3 )
        % >> A.myMethod( input1, input2, input3)
        %
        % Looking at the function line, we can see that there is a fourth
        % input called "obj", but that I did not give "myMethod" an input
        % named "obj" when I called the method. This is because "obj" is a
        % reference to A, the specific instance of a "myPSM" that called
        % the method.
        %
        % The "obj" input, the reference to the PSM that called the method,
        % is automatically sent to ALL METHODS (with the exception of the
        % constructor) as the first input. So when writing a method, the
        % first input must always be "obj".
        %
        % Looking at the function line, we can see that there are no
        % outputs. This is because "myProp3" is a property of "myPSM".
        % Essentially, it is a saved variable. By running this method, we
        % will save the variable in the "myProp3" property and not need to
        % return anything.
        function[] = myMethod( obj, input1, input2, input3 )
        
            % We can call functions within the method
            value = myFunction( input1, input2 );
            
            % We can reference properties using dot indexing
            value2 = myFunction2( obj.propVal2 );
            
            % And we can call other methods, also using dot-indexing
            value3 = obj.anotherMethod( input3 );
            
            % Finally, we'll want to set the value of propVal3
            obj.propVal3 = value3;
        end
             
        
        % GET STATE INDICES
        %
        % This is one of the functions required by the PSM interface.
        % This function decides which elements in the state vector should
        % be used to run the PSM. Specifically, it saves the indices of the
        % desired elements within the state vector (hence 'state indices').
        %
        % The specifics of this will be different for each PSM. However, I
        % have provided a general function to select state indices based on
        % lat-lon coordinates that should be sufficient for most simple
        % PSMs.
        %
        % Again, note that the first input is the mandatory "obj". You can
        % use a different name than "obj" if you prefer a different name,
        % but naming the reference "obj" is a standard convention for
        % object-oriented programming with MATLAB.
        %
        % This method has no outputs because the state indices will be
        % saved in the "H" property. You may notice that I did not create
        % an "H" property in the myPSM. This is because "PSM" the interface
        % that describes all PSMs, declares "H" as a property. So all PSMs
        % will have the "H" property created automatically.
        %
        % It is strongly recommended that you always save the state indices
        % in the same order for each instance of a PSM. For example, if
        % your PSM needed temperature and precipitation values from June,
        % July, and August, you should always save the state indices in the
        % same order, perhaps:
        %
        % >> obj.H = [T-June, T-July, T-Aug, P-June, P-July, P-Aug]
        %
        % regardless of the order of the variables in the ensemble, and
        % regardless of the order of any inputs given to the method.
        function[] = getStateIndices( obj, ensMeta, var1Name, var2Name, varargin )
            obj.H = someFunction( ensMeta, varNames, varargin );
        end
        
        
        
        % ERROR CHECK PSM
        %
        % This is a method required by the PSM interface. It is used to
        % error check a PSM and ensure that it is ready for data
        % assimilation.
        %
        % You shouldn't change the inputs to this method because it is
        % built in to the data assimilation code with no input (excepting
        % "obj")
        function[] = errorCheckPSM( obj )
            
            % Do error checking on values specific to the PSM
            if obj.propVal1 < 0
                error('propVal1 should be positive!');
            elseif isnan( obj.propValX )
                error('propValX cannott be NaN!');
            elseif isempty( obj.propVal2)
                error('propVal2 cannot be empty!');
            end
            
            % Etcetera
        end
            
            
        
        % RUN FORWARD MODEL
        %
        % This is the final method required by the PSM interface. It 
        % does the heavy lifting of actually running a PSM. It has two
        % outputs: Ye - The proxy estimate for each ensemble member, and
        % R - Estimated observation error.
        %
        % Note that "R" is an optional output. Dash will only ask for "R"
        % if the user does not specify R at the beginning of data
        % assimilation. So it's fine to not include any code that
        % calculates R in the PSM; this will simply require the user to
        % always specify R.
        %
        % The inputs are "obj", M - the values in the ensemble at the
        % sampling values, t - the particular time step being processed in
        % the data assimilation, and d - the index of the proxy being
        % estimated.
        %
        % Most PSMs will not need the d input. If you are a developer
        % wishing to utilize the "handle" properties of a PSMs, see the
        % developer documentation.
        %
        % Using the "t" input is also
        % uncommon, but could be necessary if your PSM is time dependent.
        % For example, if you wanted to incorporate the effects of
        % evolution on a biological calibration curve over time, you may wish to know
        % the current time step in order to select the appropriate curve.
        %
        % Overwhelmingly, most PSMs should only need the "M" input, so that
        % is the setup for this demo. We don't need the "t" and "d" inputs
        % for this method, but the PSM interface requires that this method
        % accepts four inputs. We can use the tilde operator (~) as a
        % placeholder for inputs that we don't need for our function.
        function[Ye, R] = runForwardModel( obj, M, ~, ~ )
            
            % Run the PSM forward model via some function.
            [Ye, R] = myForwardModel( M );
        end
    end
end