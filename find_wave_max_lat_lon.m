clear
 somdata=['vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1']
 load([somdata,'/som_',somdata,'.mat']);


%%- north south wave lat

 lat_north_mean=nan(1,20);
 lat_south_mean=nan(1,20);

 for p=1:20

    critical_value=ceil(max(abs(Map_cluster(:)))/5)

    [pattern_max,imax]=extrema2(abs(squeeze(Map_cluster(:,:,p))));
    [iimax,ijmax]=ind2sub(size(squeeze(Map_cluster(:,:,p))),imax);

    ilon=datalon(ijmax(pattern_max>critical_value));
    ilat=datalat(iimax(pattern_max>critical_value));%remove the small fluculation under the critical level
    %--	
    ilat((ilon==datalon(1))|(ilon==datalon(end)))=[];
    ilon((ilon==datalon(1))|(ilon==datalon(end)))=[];

    ilon((ilat==datalat(1))|(ilat==datalat(end)))=[];
    ilat((ilat==datalat(1))|(ilat==datalat(end)))=[];%remove the boundary points


    [x_point,index]=sort(ilon);
    y_point=ilat(index);

    y_point_north=y_point(y_point>=45)	;
    x_point_north=x_point(y_point>=45)  ;

    y_point_south=y_point(y_point<45)	;
    x_point_south=x_point(y_point<45)   ;
    
    disp(p)
    disp('north')
    disp([x_point_north,y_point_north])
    disp('south:')
    disp([x_point_south,y_point_south])

    lat_north_mean(1,p)=mean(y_point_north);
    lat_south_mean(1,p)=mean(y_point_south);

end

   save([somdata,'/','lat_mean.mat'],'lat_north_mean','lat_south_mean')

  %%-  wave lon

  	critical_value=ceil(max(abs(Map_cluster(:)))/5);  
	disp(['critical_level: ',num2str(critical_value)])
	
	lon_wave_max=nan(1,20);
	lon_phase_mean=nan(5,20);
   for p=1:20

    [pattern_max,imax]=extrema2(abs(squeeze(Map_cluster(:,:,p))));
    [iimax,ijmax]=ind2sub(size(squeeze(Map_cluster(:,:,p))),imax);

    ilon=datalon(ijmax(pattern_max>critical_value));
    ilat=datalat(iimax(pattern_max>critical_value));%remove the small fluculation under the critical level
    %--	
    ilat((ilon==datalon(1))|(ilon==datalon(end)))=[];
    ilon((ilon==datalon(1))|(ilon==datalon(end)))=[];

    ilon((ilat==datalat(1))|(ilat==datalat(end)))=[];
    ilat((ilat==datalat(1))|(ilat==datalat(end)))=[];%remove the boundary points

    disp(['pattern=',num2str(p)])
    disp('max')
    disp([ilon(1),ilat(1)]) % the most strong point
    lon_wave_max(p)=ilon(1);
    %disp([ilon(2),ilat(2)]) % the second strong point

    [x_point,index]=sort(ilon);
    y_point=ilat(index);

    
    	j=1;
 	for k=1:(length(x_point)-1)
	if x_point(k+1)-x_point(k)<=7.5
	disp('north south')
	%disp([x_point(k),y_point(k);x_point(k+1) , y_point(k+1)])
	lon_phase_mean(j,p)=mean([x_point(k),x_point(k+1)]);
	j=j+1;
	end
	end
	j=j-1;	disp(lon_phase_mean);
	

    %disp('sort');
    %disp( [x_point,y_point]);

	end

	 save([somdata,'/','lon_mean.mat'],'lon_phase_mean','lon_wave_max')

