 	clear
	
	addpath(genpath('~/third/'))
	addpath('~/data_preprocessing/data_to_be_som')
	%name='vwnd_NDJFM_lev250_lat0-90_lon120-255_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
   	%name='V_GDS0_ISBL_DailyAnomSmClm_lev250_lat0-87_lon20-130_year1979-2010M11D151'
	%name='V_GDS0_ISBL_lev250_lat0-90_lon120-255_year1979-2010M11D151fft_2-8days'
	%name='V_GDS0_ISBL_lev250_lat0-87_lon20-130_year1979-2010M11D151daily_anomalies'
	name='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2014deseasonal3-bandpassNwgt31-2-10day'
    %name='vwnd_NDJFM_lev250_lat0-90_lon-90-50_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %name='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    fi 	= [name,'.nc'];
	varname	= 'var';
	latname = 'lat';
	lonname = 'lon';
%	levelname = 'lv_ISBL1'
	timename  = 'time';
	YMDname   = 'time_yyyymmdd'	
 	%latname = 'g0_lat_2'
 	%lonname = 'g0_lon_3'
 	%levelname = 'lv_ISBL1'
	%datename  = 'time_YYYYMMDD' 

	datalon	= ncread(fi,lonname);
	datalat	= ncread(fi,latname);
	dataplev= ncread(fi,levelname);
	time_YYYYMMDD = ncread(fi,YMDname);
	time= ncread(fi,timename);
        time_units=ncreadatt(fi,timename,'units')
	
 	x       = ncread(fi,varname);
    	size(x)

	nlat    = length(datalat);
	nlon	= length(datalon);

    	% the latitude weighting
    	for i = 1:nlat 
        %x_weight(:,i,:,:) = x(:,i,:,:) .*sqrt(cosd(datalat(i)));
	x_weight(:,i,:) = x(:,i,:) .*sqrt(cosd(datalat(i)));
    	end
        size(x_weight)
%%
	X = double(reshape(x_weight,length(datalon)*length(datalat),length(time_YYYYMMDD)));
	
	%som

	%
	nrc = 2;
	%for nrc=2:7
	nrow=nrc;
	ncolum=nrc;
	disp(['som calculation'])
	[pattern,pat_f,timeseries,qe,te]=som_function(X',time_YYYYMMDD,nrow,ncolum)

	display(['qe=',	num2str(qe(nrc))])
	display(['te=',num2str(te(nrc))])

	save(['~/workdata/result/som_nn_data/',name,'/som_',num2str(nrc),'_sqgrid_',name,'.mat'],'Map_cluster','timeseries','time_YYYYMMDD','datalon','datalat','dataplev','qe','te')
	%%

%	end
	
%	disp('saving data')
%	nrc=2:7;
%   	save([name,'/som_qe_te_2s_7s'],'qe','te','nrc')

