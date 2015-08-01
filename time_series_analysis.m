    clear;
    dataname='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %dataname='vwnd_NDJFM_lev250_lat0-90_lon-90-50_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %dataname='vwnd_NDJFM_lev250_lat0-90_lon120-255_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
    %dataname='vwnd_NDJFM_lev250_lat0-90_lon-90-80_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1'
   % dataname='V_GDS0_ISBL_lev250_lat0-90_lon20-130_year1979-2010M11D151fft_2-10days'
   %  dataname='V_GDS0_ISBL_DailyAnomSmClm_lev250_lat0-87_lon120-255_year1979-2010M11D151'
   %dataname='V_GDS0_ISBL_DailyAnomSmClm_lev250_lat0-87_lon20-130_year1979-2010M11D151'
   %dataname='V_GDS0_ISBL_lev250_lat0-87_lon20-130_year1979-2010M11D151daily_anomalies'
   %dataname='V_GDS0_ISBL_lev250_lat0-90_lon120-255_year1979-2010M11D151fft_2-8days'
   %dataname='V_GDS0_ISBL_lev250_lat0-90_lon20-130_year1979-2010M11D151fft_2-10days'
    name=['som_',dataname];
    
    load([dataname,'/',name,'.mat'])

  N=30;
  D=30;
  J=30;
  F=30;
  M=30;

  %N=30;
  %D=31;
  %J=31;
  %F=28;
  %M=31;


  ssd=N+D+J+F+M;
  month=['N','D','J','F','M']
  month_day=[N,D,J,F,M]
  

      
  yr=min(timeseies(:,1)):max(timeseies(:,1));
  K=20;
  
  if ~(length(find((timeseies(:,1)==min(yr))))==ssd)
      error('Check season day input')
      break
  end
  
  count_year=nan(length(yr),K);
  for p=1:K;
      for i=1:length(yr);
      count_year(i,p)...
          =length(find((timeseies(:,1)==yr(i)).*(timeseies(:,3)==p)));
      end
  end
  
%%plot 

    nrow=4, ncolum=5;
	
    addoff_w=0.026251555;
    addoff_h=0.035;%-0.020251555%0.00010;
    width=(0.98)/ncolum; height=(0.98)/nrow;
    
    figure;
	for j = 1:nrow*ncolum;       
    h= subplot('Position',[(mod(j-1,ncolum))*width+addoff_w (ncolum-ceil(j/ncolum)-1)*height+addoff_h width-addoff_w height-addoff_h]);
    bar(yr,count_year(:,j),1) %hist(y,x)
    set(gca,'xlim',[min(yr)-0.5 max(yr)-0.5],'ylim',[0,max(count_year(:))],...
        'xtick',(min(yr)+1:10:max(yr)),'xticklabel',(min(yr)+1:10:max(yr)),'ytick',0:5:max(count_year(:)),'yticklabel',0:5:max(count_year(:)),'fontsize',12);
       axis square;
       hold on
       
       plot((((min(yr)+1:10:max(yr)))'*ones(size([0,max(count_year(:))])))',(ones(size(((min(yr)+1:10:max(yr)))))'*[0,max(count_year(:))])','r');

       
        ticks=get(gca,'xtick');
 %      set(gca,'xticklabel',[]);
 %      text(ticks,ticks*0,cellstr(num2str(ticks')),'rotation',-45)%,'HorizontalAlignment','right')
    text(double(max(yr))-3,max(count_year(:))-1.5,['(',num2str(j),')'],'fontsize',12,'rotation',0,'HorizontalAlignment','right');
    end
    

    
	set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
	saveas(gcf,[dataname,'/timeseies_year_som_',dataname,'.pdf'],'pdf')

  %% month

    date_num_of_season =((1:length(timeseies(:,2)))'.*(timeseies(:,3)~=0));
    date_num_of_season(date_num_of_season==0)=[];
    date_num_of_season= mod(date_num_of_season,ssd);
    date_num_of_season(find(date_num_of_season==0))=ssd;
    nyear=length(date_num_of_season)/ssd;

   count_m_freq=zeros(length(month),K);
   for p=1:K;

        ind = find(timeseies(:,3) == p);
       for i=1:length(month);
	% count frequncy of each pattern in early or late winter
 

	if i>=2
    	count_m_freq(i,p) = length(find((date_num_of_season(ind)<= sum(month_day(1:i))).* (date_num_of_season(ind)>sum(month_day(1:i-1)) )))/(month_day(i)*nyear) ;
        end
	
	if i==1
	count_m_freq(i,p) = length(find(date_num_of_season(ind)<= sum(month_day(1:i))))/(month_day(1:i)*nyear);	
	end
	
	end	
   end
 

%%plot  month

    nrow=4, ncolum=5;
	
    addoff_w=0.036251555;
    addoff_h=0.035;%-0.020251555%0.00010;
    width=(0.98)/ncolum; height=(0.98)/nrow;
    
    figure;
	for j = 1:nrow*ncolum;       
    h= subplot('Position',[(mod(j-1,ncolum))*width+addoff_w (ncolum-ceil(j/ncolum)-1)*height+addoff_h width-addoff_w height-addoff_h]);
    bar(1:length(month),count_m_freq(:,j),1,'r') %hist(y,x)
    set(gca,'xlim',[1-0.5 length(month)+0.5],'ylim',[0,max(count_m_freq(:))],...
        'xtick',1:length(month),'xticklabel',{month(:)},'ytick',0:0.01:max(count_m_freq(:)),'yticklabel',0:0.01:max(count_m_freq(:)),'fontsize',12);
       axis square;
       hold on
 
       
        ticks=get(gca,'xtick');
 %      set(gca,'xticklabel',[]);
 %      text(ticks,ticks*0,cellstr(num2str(ticks')),'rotation',-45)%,'HorizontalAlignment','right')
    text(double(length(month)-1),max(count_m_freq(:))-0.005,['(',num2str(j),')'],'fontsize',12,'rotation',0,'HorizontalAlignment','right');
    end

 
	set(gcf, 'PaperUnits', 'normal ');
	orient Landscape
 	set(gcf, 'PaperPosition', [0 0.015 0.999 0.999]);
	saveas(gcf,[dataname,'/timeseies_seasonal_som_',dataname,'.pdf'],'pdf')

      save([dataname,'/timeseies_som_',dataname,'.mat'],'count_year','count_m_freq');
