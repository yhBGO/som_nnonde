     %% Plot ready
  %   load(['som_',name,'.mat']) 
    clear;

    addpath(genpath('~/workdata/third'))
    dataname='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %dataname='V_GDS0_ISBL_DailyAnomSmClm_lev250_lat0-87_lon120-255_year1979-2010M11D151'
    %dataname='V_GDS0_ISBL_DailyAnomSmClm_lev250_lat0-87_lon120-255_year1979-2010M11D151'
    %dataname='V_GDS0_ISBL_lev250_lat0-90_lon20-130_year1979-2010M11D151fft_2-10days'
    %dataname='V_GDS0_ISBL_lev250_lat0-90_lon20-130_year1979-2010M11D151fft_2-10days'
    %dataname='V_GDS0_ISBL_DailyAnomSmClm_lev250_lat0-87_lon20-130_year1979-2010M11D151'



    %if  exist([dataname,'/plot_som_',dataname,'.pdf'],'file')
	    %error([dataname,'/plot_som_',dataname,'.pdf',  '  already exist'])
    %else
    %for nrc=2:7;
    for nrc=7;
    name=['som_',num2str(nrc),'_sqgrid_',dataname]; 

    	load([dataname,'/',name,'.mat'])

	nlon = length(datalon); % length of latitude
	nlat = length(datalat); % length of longitude

	[x,y] = meshgrid(double(datalon),double(datalat));
	

	load coast;
	lat = [lat; NaN; lat];
	long = [long; NaN; long+360];
	coast_lat = lat;  coast_lon = long;
	clear lat long;

	close;

    	%plot the som map    
    	%subaxis(4,5,p);
	nrow=nrc;
	ncolum=nrc;
	
    addoff_w=0.026251555;
    addoff_h=0.01;%-0.020251555%0.00010;
    width=(0.95)/ncolum; height=(1.0)/nrow;
	%nscale=0.2;
	%Paperwidth=(datalon(end)-datalon(1))*nscale
	%Paperheight=(datalat(end)-datalat(1))*nscale

    cnint=2;
    plotmax=ceil(max(abs(Map_cluster(:)))/cnint)*cnint;
    
 
    disp(['ploting ', num2str(nrc),'grid point' ]) 
	for p = 1:nrow*ncolum
            
    h= subplot('Position',[(mod(p-1,ncolum))*width+addoff_w (ncolum-ceil(p/ncolum))*height+addoff_h width-addoff_w height-addoff_h]);
       
    critical_value=ceil(max(abs(Map_cluster(:)))/5);
    [pattern_max,imax]=extrema2(abs(squeeze(Map_cluster(:,:,p))));
    [iimax,ijmax]=ind2sub(size(squeeze(Map_cluster(:,:,p))),imax);
    ilon=datalon(ijmax(pattern_max>critical_value));
    ilat=datalat(iimax(pattern_max>critical_value));

    ilat((ilon==datalon(1))|(ilon==datalon(end)))=[];
    ilon((ilon==datalon(1))|(ilon==datalon(end)))=[];

    ilon((ilat==datalat(1))|(ilat==datalat(end)))=[];
    ilat((ilat==datalat(1))|(ilat==datalat(end)))=[];

    
    [x_point,index]=sort(ilon);
    y_point=ilat(index);
    
    st_num=ones(1,length(x_point)); %flag , the number of wave guide
    k=2;
    split_judge=10;
    for i=2:length(x_point);
        if y_point(i)-y_point(i-1)>split_judge;
            st_num(i)=st_num(i-1)+1;%st_num(i-1)+1
        end
        if y_point(i)-y_point(i-1)<-split_judge;
            st_num(i)=st_num(i-1)-1;
        end
        if abs(y_point(i)-y_point(i-1))<=split_judge;
            st_num(i)=st_num(i-1);
        end
    end
    
    track_we_x=datalon;
    track_we_y=nan(max(st_num)-min(st_num)+1,length(datalon));%west-east
    for i=min(st_num):max(st_num)
    track_we_y(i-min(st_num)+1,:)=mean(y_point(st_num==i)).*ones(1,length(datalon));
    %track_we_y(2,:)=mean(y_point(st_num==2)).*ones(1,length(datalon));
    end
            
  
 
                %colormap()
	%	imagesc(datalon,datalat,Map_cluster(:,:,p))%,-plotmax:cnint:plotmax)%,'LineStyle','none')
		set(gca,'YDir','normal'); 
             	H=pcolor(x,y,double(Map_cluster(:,:,p)));%,'edgecolor','none');
		set(H,'edgecolor','none')
		%,-plotmax:cnint:plotmax,'LineStyle','none')%,'linestyle','--','linecolor','b','linewidth',1);  
		
             	%contourf(x,y,Map_cluster(:,:,p),-plotmax:cnint:plotmax,'LineStyle','none')%,'linestyle','--','linecolor','b','linewidth',1);  
                caxis([-plotmax plotmax])%([cmin cmax])
                
     %   contour(x,y,Map_cluster(:,:,p),2:2:80,'linestyle','-','linecolor','r','linewidth',0.8); %Not Fill in the color contours
     	hold on
     %	contour(x,y,Map_cluster(:,:,p),-80:2:-2,'linestyle','--','linecolor','b','linewidth',0.8); %Not Fill in the color contours
       hold on;  
        %axis square%equal
         set(gca,'DataAspectRatio',[1*(max(datalon)-min(datalon))/(255-150),1,1])

        set(gca, 'xlim', [datalon(1) datalon(end)], 'ylim', [datalat(1) datalat(end)-3],'ytick',datalat(1):20:datalat(end),...
        'yticklabel',datalat(1):20:datalat(end),...
        'xtick',datalon(1):30:(datalon(end)),... %,'xticklabel',{'20E','50E','80E','110E','140E'},...%...%{'EQ','20N','40N','60N','80N'},...
          'fontsize',8);

     	plot(coast_lon, coast_lat, 'linewidth', 0.8, 'color', [0.6 0.6 0.6]);hold on;
  
        %title(['(',num2str(p),')',sprintf('%3.1f',100*pat_f(p)),'%','|ND',sprintf('%3.1f',100*pat_f_ND(p)),'%|','FM',sprintf('%3.1f',100*pat_f_FM(p)),'%',],'fontsize',12);
    	text(double(datalon(1)),double(datalat(end)-5),['(',num2str(p),')',sprintf('%3.1f',100*pat_f(p)),'%','|ND',sprintf('%3.1f',100*pat_f_ND(p)),'%|','FM',sprintf('%3.1f',100*pat_f_FM(p)),'%',],'fontsize',8);
        plot(ilon,ilat,'k*');
        %plot(track_we_x,track_we_y,'c');
   %     plot(x_point,y_point,'co');
        set(gca, 'XColor', [1 1 1], 'YColor', [1 1 1]);
	hold off
	end

%%colorbar('XTick',-plotmax:cnint:plotmax,'XTickLabel',-plotmax:cnint:plotmax)%();
%%caxis([-plotmax plotmax])%([cmin cmax])
 hp4 = get(h,'Position');
 load BlWhRe.rgb
 BlWhRe=BlWhRe/255;
 colormap(BlWhRe);
 %load MPL_bwr.rgb
 %colormap(MPL_bwr);
colorbar('Position', [hp4(1)+width-addoff_w+0.0151  0.5-0.3  0.011  0.3*2],...
    'Clim',[-plotmax , plotmax],...
    'YTick',-plotmax:cnint:plotmax,'YTickLabel',-plotmax:cnint:plotmax,...
    'fontsize',9)

%save figure
% 	set(gcf, 'PaperPositionMode', 'manual');
% 	set(gcf,'PaperType','A4')
	set(gcf, 'PaperUnits', 'normal ');
%    set(gcf,'PaperSize',[(datalon(end)-datalon(1)),datalat(end)-datalat(1)])
	%orient Landscape%Portrait
 	%set(gcf, 'PaperPosition', [-0 -0 0.999 0.999]);%Paperheight/Paperwidth*0.97
	%saveas(gcf,[dataname,'/plot_som_',dataname,'_contour.eps'],'psc2')
	orient Landscape
	set(gcf, 'PaperPosition', [-0 -0 0.999 0.999]);
	saveas(gcf,[dataname,'/plot_som_',num2str(nrc),'_sqgrid_',dataname,'_contour.pdf'],'pdf')
close

end
%%save som result
    	%save([dataname,'/som_',dataname,'.mat'],'Map_cluster','pattern','pat_f','pat_f_ND','pat_f_FM','timeseies','datalon','datalat')%,'dataplev')


