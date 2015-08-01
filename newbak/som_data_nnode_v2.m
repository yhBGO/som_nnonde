 	clear
	
	addpath(genpath('~/workdata/third'))
	addpath('../../StormTrack/data_preprocess/data_to_be_som')
	%name='vwnd_NDJFM_lev250_lat0-90_lon120-255_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
   	%name='V_GDS0_ISBL_DailyAnomSmClm_lev250_lat0-87_lon20-130_year1979-2010M11D151'
	%name='V_GDS0_ISBL_lev250_lat0-90_lon120-255_year1979-2010M11D151fft_2-8days'
	%name='V_GDS0_ISBL_lev250_lat0-87_lon20-130_year1979-2010M11D151daily_anomalies'
	 name='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %name='vwnd_NDJFM_lev250_lat0-90_lon-90-50_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %name='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    fi 	= [name,'.nc'];
	varname	= 'var';
	latname = 'lat';
	lonname = 'lon';
%	levelname = 'lv_ISBL1'
	datename  = 'Time';
	
	yrStrt	= 1979;
	yrEnd	= 2010;
	ssd	= 150 ;
	JFM	= 30+30+30;%31+28+31;
	ND	=  30+30;%30+31;
	FM=30+30;
	
	%varname	= 'V_GDS0_ISBL'
 	%latname = 'g0_lat_2'
 	%lonname = 'g0_lon_3'
 	%levelname = 'lv_ISBL1'
	%datename  = 'time_YYYYMMDD' 


	%yrStrt	= 1979;
	%yrEnd	= 2010;
	%ssd	= 151 ;
	%JFM	= 31+28+31;
	%FM	= 28+31;
	%ND	= 30+31;


	datalon	= ncread(fi,lonname);
	datalat	= ncread(fi,latname);
%	dataplev= ncread(fi,levelname);

	time_YYYYMMDD = ncread(fi,datename);

	if mod(length(time_YYYYMMDD),ssd);
		error('check seasonday input')
		break
	end
	if ~ssd*(yrEnd-yrStrt)==length(time_YYYYMMDD);
		error('file date length does not match the input year start or end  ')
	end

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
	for nrc=2:7
	nrow=nrc;
	ncolum=nrc;
	disp(['som calculation'])
	[pattern,pat_f,timeseies,qe(nrc),te(nrc)]=test_qe_te(X',ssd*(yrEnd-yrStrt),yrStrt,yrEnd,[1:JFM,365-ND+1:365],nrow,ncolum)

	display(['qe=',	num2str(qe(nrc))])
	display(['te=',num2str(te(nrc))])
%%	
	end
	
	disp('saving data')
	nrc=2:7;
   	save([name,'/som_qe_te_2s_7s'],'qe','te','nrc')

