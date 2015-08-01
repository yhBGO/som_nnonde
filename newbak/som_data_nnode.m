 	clear
	
	addpath(genpath('~/third'))
	addpath('~/data_preprocessing/data_to_be_som')
	%name='vwnd_NDJFM_lev250_lat0-90_lon120-255_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
   	%name='V_GDS0_ISBL_DailyAnomSmClm_lev250_lat0-87_lon20-130_year1979-2010M11D151'
	%name='V_GDS0_ISBL_lev250_lat0-90_lon120-255_year1979-2010M11D151fft_2-8days'
	%name='V_GDS0_ISBL_lev250_lat0-87_lon20-130_year1979-2010M11D151daily_anomalies'
	 name='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %name='vwnd_NDJFM_lev250_lat0-90_lon-90-50_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %name='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    fi 	= [name,'.nc']
	varname	= 'var'
	latname = 'lat'
	lonname = 'lon'
%	levelname = 'lv_ISBL1'
	datename  = 'Time'
	
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

	if mod(length(time_YYYYMMDD),ssd)
		error('check seasonday input')
		break
	end
	if ~ssd*(yrEnd-yrStrt)==length(time_YYYYMMDD)
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

	%
	for nrc=2:7;
	nrow=nrc, ncolum=nrc;
	[pattern,pat_f,timeseies]=som_change_node(X',ssd*(yrEnd-yrStrt),yrStrt,yrEnd,[1:JFM,365-ND+1:365],nrow,ncolum)

   	%save([dataname,'/som_',name],'pattern','pat_f','timeseies')
%%	
	K = nrow*ncolum;

	for p= 1:K
 	% Remove the latitude weighting
	Map_clusterW(:,:,p) = reshape(pattern(p,:),nlon,nlat);
    	for i = 1:nlat 
        Map_clusterT(:,i,p) = Map_clusterW(:,i,p) ./ sqrt(cosd(datalat(i)));
    	end	    
    	Map_cluster(:,:,p)=Map_clusterT(:,:,p)'; %transpose of the matrix
	end

	%som time seires and count frequncy
	timeseies_YYYYMMDD=time_YYYYMMDD;
	for p = 1:K
      	% count frequncy of each pattern in early or late winter
    	ind = find(timeseies(:,3) == p);
    	ind_ND = find((timeseies(:,3) == p).*(timeseies(:,2) <=ND)); %61
    	ind_FM = find((timeseies(:,3) == p).*(timeseies(:,2) >=365-FM+1)); %FM=59
    	pat_f_ND(p) = length(find( timeseies(ind,2) <= ND))/length(find(timeseies(:,2)<=ND));
    	pat_f_FM(p) = length(find( timeseies(ind,2) >= 365-FM+1))/...
        length(find(timeseies(:,2)>=365-FM+1)); 
	end
	
     %% Plot ready
  %   load(['som_',name,'.mat']) 
	[x,y] = meshgrid(datalon,datalat);

	load coast;
	lat = [lat; NaN; lat];
	long = [long; NaN; long+360];
	coast_lat = lat;  coast_lon = long;
	clear lat long;

	close;

    	%%----------plot the som map    
    	%subaxis(4,5,p);
	%nrow=4, ncolum=5;
	
    addoff_w=0;%0.026251555;
    addoff_h=-0.000000001;%-0.020251555%0.00010;
    width=(0.95)/ncolum; height=(0.95)/nrow;
	%nscale=0.2;
	%Paperwidth=(datalon(end)-datalon(1))*nscale
	%Paperheight=(datalat(end)-datalat(1))*nscale

    cnint=2;
    plotmax=ceil(max(abs(Map_cluster(:)))/cnint)*cnint;
    
 %%
    
	for p = 1:nrow*ncolum
            
    h= subplot('Position',[(mod(p-1,ncolum))*width+addoff_w (ncolum-ceil(p/ncolum))*height+addoff_h width height]);
       
    critical_value=4;
    [pattern_max,imax]=extrema2(abs(squeeze(Map_cluster(:,:,p))));
    [iimax,ijmax]=ind2sub(size(squeeze(Map_cluster(:,:,p))),imax);
    ilon=datalon(ijmax(pattern_max>critical_value));
    ilat=datalat(iimax(pattern_max>critical_value));

    ilat((ilon==datalon(1))|(ilon==datalon(end)))=[];
    ilon((ilon==datalon(1))|(ilon==datalon(end)))=[];

    ilon((ilat==datalat(1))|(ilat==datalat(end)))=[];
    ilat((ilat==datalat(1))|(ilat==datalat(end)))=[];

    % barolinic wave split judge
    %[x_point,index]=sort(ilon);
    %y_point=ilat(index);
    
    %st_num=ones(1,length(x_point)); %flag , the number of wave guide
    %k=2;
    %split_judge=10;
    %for i=2:length(x_point);
        %if y_point(i)-y_point(i-1)>split_judge;
            %st_num(i)=st_num(i-1)+1;%st_num(i-1)+1
        %end
        %if y_point(i)-y_point(i-1)<-split_judge;
            %st_num(i)=st_num(i-1)-1;
        %end
        %if abs(y_point(i)-y_point(i-1))<=split_judge;
            %st_num(i)=st_num(i-1);
        %end
    %end
    
    %track_we_x=datalon;
    %track_we_y=nan(max(st_num)-min(st_num)+1,length(datalon));%west-east
    %for i=min(st_num):max(st_num)
    %track_we_y(i-min(st_num)+1,:)=mean(y_point(st_num==i)).*ones(1,length(datalon));
    %%track_we_y(2,:)=mean(y_point(st_num==2)).*ones(1,length(datalon));
    %end
            
  
 
                %colormap()
		imagesc(datalon,datalat,Map_cluster(:,:,p))%,-plotmax:cnint:plotmax)%,'LineStyle','none')
		set(gca,'YDir','normal'); 		
             	%contourf(x,y,Map_cluster(:,:,p),-plotmax:cnint:plotmax,'LineStyle','none')%,'linestyle','--','linecolor','b','linewidth',1);  
                caxis([-plotmax plotmax])%([cmin cmax])
                
        %contour(x,y,Map_cluster(:,:,p),2:2:80,'linestyle','-','linecolor','r','linewidth',1); %Not Fill in the color contours		
     	%hold on
     	%contour(x,y,Map_cluster(:,:,p),-80:2:-2,'linestyle','--','linecolor','b','linewidth',1); %Not Fill in the color contours
       		hold on;  
        	%axis square%equal
         	set(gca,'DataAspectRatio',[1*(max(datalon)-min(datalon))/(255-150),1,1])

        	set(gca, 'xlim', [datalon(1) datalon(end)], 'ylim', [datalat(1) datalat(end)-3],'ytick',datalat(1):20:datalat(end),...
        'yticklabel',datalat(1):20:datalat(end),...
        'xtick',datalon(1):30:(datalon(end)),...%,'xticklabel',{'20E','50E','80E','110E','140E'},...%
          'fontsize',12);

     	plot(coast_lon, coast_lat, 'linewidth', 0.6, 'color', [0.6 0.6 0.6]);hold on;
  
        %title(['(',num2str(p),')',sprintf('%3.1f',100*pat_f(p)),'%','|ND',sprintf('%3.1f',100*pat_f_ND(p)),'%|','FM',sprintf('%3.1f',100*pat_f_FM(p)),'%',],'fontsize',12);
    	text(double(datalon(1)-5),double(datalat(end)+5),['(',num2str(p),')',sprintf('%3.1f',100*pat_f(p)),'%','|ND',sprintf('%3.1f',100*pat_f_ND(p)),'%|','FM',sprintf('%3.1f',100*pat_f_FM(p)),'%',],'fontsize',12);
        plot(ilon,ilat,'k*');
        %plot(track_we_x,track_we_y,'c');
   %     plot(x_point,y_point,'co');
        set(gca, 'XColor', [1 1 1], 'YColor', [1 1 1]);
	hold off
	end

%colorbar('XTick',-plotmax:cnint:plotmax,'XTickLabel',-plotmax:cnint:plotmax)%();
%caxis([-plotmax plotmax])%([cmin cmax])
hp4 = get(h,'Position');
 %load BlWhRe.rgb
 %BlWhRe=BlWhRe/255;
 load MPL_bwr.rgb
 colormap(MPL_bwr);
colorbar('Position', [hp4(1)+width-addoff_w+0.0151  0.5-0.3  0.011  0.3*2],...
    'YTick',-plotmax:cnint:plotmax,'YTickLabel',-plotmax:cnint:plotmax,...
    'fontsize',10)


if ~isdir(name)
mkdir(name)
end

%save figure
% 	set(gcf, 'PaperPositionMode', 'manual');
% 	set(gcf,'PaperType','A4')
	set(gcf, 'PaperUnits', 'normal ');

	orient Landscape
	set(gcf, 'PaperPosition', [-0 -0 1 1]);
	saveas(gcf,[name,'/plot_som_',num2str(nrc),'_sqrid_',name,'.pdf'],'pdf')
close


%save som result
    	save([name,'/som_',num2str(nrc),'_sqgrid_',name,'.mat'],'Map_cluster','pat_f','pat_f_ND','pat_f_FM','timeseies','time_YYYYMMDD','datalon','datalat')%,'dataplev')
	end
