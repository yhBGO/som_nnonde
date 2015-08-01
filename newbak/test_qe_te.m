function [pats, pat_freq, timeseries,aqe,te]=som_change_node(X,TotDays, year_begin, year_end, season_days,num_rows,num_cols)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this subroutine performs the SOM analysis
% pats          the spacial pattern of SOMs
% pat_freq      the occurrence frequency of each som pattern
% timeseries    num_obs x 4 matrix, where the first two columns are year
%               and calendar day number, the third is the best-matching 
%               cluster pattern number, and the fourth is the rms error 
%               corresponding to that day.
% X             the analysed data
% TotDays       the total length of time for X
% year_begin    the year when data begin
% year_end      the year when data end
% season_days   the days that used in a year. e.g. for the winter season
%               DJF: season_days=[1:59, 305:365]
%num_rows	number of rows in SOM
%num_cols	number of columns in SOM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%num_rows = 4; % number of rows in SOM
%num_cols = 5; % number of columns in SOM
init = 1; % 1 = linear initialization, 0 = random initialization.  
lattice = 'rect'; % 'rect' for rectangular or 'hexa' for hexagonal
shape = 'sheet'; % 'sheet', 'cyl', or 'toroid'
neighborhood_fct = 'ep'; % choice of neighborhood function: 'gaussian', 
    % 'cutgauss', 'bubble', or 'ep'
rad_ini = 3; % initial neighborhood radius used in the training of the 
    % SOM (around the size of the minimum or maximum dimension should be 
    % fine for most maps)  
rad_fin = 1; % final neighborhood radius at the end of SOM training (1 
    % usually provides a good fit and good final ordering, 0 provides the 
    % maximum fit, but possibly at the expense of ordering and with a
    % greater risk of overfitting - depending on the purpose, that might
    % not be a major drawback)
trainlen_rough = 50; % Number of training iterations during the rough 
    % initial phase to achieve a broad ordering
trainlen_finetune = 300; % Number of training iterations during the 
    % finetuning phase 
    
        % Establish the data struct, as described in the SOM toolbox manual
        sD = som_data_struct(X);

        % Initialize the map
        if init == 1
            sMap = som_lininit(sD, 'msize', [num_cols num_rows], lattice, shape);
        elseif init == 0
            sMap = som_randinit(sD, 'msize', [num_cols num_rows], lattice, shape);
        else
            disp('Improper SOM initialization assignment')
        end
    
        % Train the map with the batch version.  First do a broad ordering 
        % with relatively large neighborhood radius and a small number of 
        % training interations.
        sTrain = som_train_struct('train', sD);
        sTrain.neigh = neighborhood_fct; % Set the neighborhood function
        sTrain.radius_ini = rad_ini; % Set the initial neighborhood radius
        % Perform the initial training
        sMap = som_batchtrain(sMap, sD, sTrain, 'trainlen',...
            trainlen_rough);

        % Finetune in the second phase of training
        sTrain.radius_ini = rad_fin + 2; 
        sTrain.radius_fin = rad_fin;
        [sMap, sTopol] = som_batchtrain(sMap,sD, sTrain, 'trainlen',...
            trainlen_finetune);

        % Get the average quantization (rms) error and topographic error 
        % as measures of quality
        [aqe, te] = som_quality(sMap,sD); % aqe is the average quantization
        % error, and te is the topographic error
     
        [bmus, qerrs] = som_bmus(sMap, sD); % bmus is the SOM pattern time 
        % series, and qerrs is the quantization error time series.
        % Place the dates, best-matching pattern, and quantization errors 
        % in one time series array
        clear sD
        timeseries = NaN(TotDays,4); 
        timeseries(:,3) = bmus;
        timeseries(:,4) = qerrs;
        % Add the years and calendar days with loops
        d = 0;
        for y = year_begin:year_end
            for c_day = 1:length(season_days)
                
                d = d + 1;
                timeseries(d,1) = y;
                timeseries(d,2) = season_days(c_day);
                
            end
        end
        
        % Determine the frequency of occurrence of each pattern
        K = num_rows*num_cols; % Number of SOM patterns
        
        pat_freq = zeros(1,K);

	num_obs=TotDays;

        for p = 1:K
            
            ind = find(timeseries(:,3) == p);
            pat_freq(p) = length(ind)/num_obs; 
            
        end

        % Get the SOM pattern matrix from the codebook
        pats = sMap.codebook;


