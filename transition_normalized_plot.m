	clear;

	dataname='vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1';
    	name=['som_',dataname]	 

	load([dataname,'/transition_',dataname,'.mat'])
 	
	%========plot==========

    	plotdata= pattern_transition_normalized;
   	%plotmax=ceil(max(abs(plotdata(:)))/cnint)*cnint;
    	plotmax=max(plotdata(:));
    
    	figure;
    
     	color='MPL_PuRd.rgb';
	%color=money;
     	color=load(color);
     	if max(color(:))>1
	     color=color/255;
     	end
%	MPL_PuRd=color;
	color=flipud(pink(5))
	labels=1:1:20;%20;%num2str(pattern_number);
	heatmap(plotdata*100,labels,labels,'%0.1f%%','GridLines',':','TextColor','k','fontsize',4,'Colormap',color)%,'ShowAllTicks',true)
	caxis([0 100])
 %       colormap(flipud(pink(5)))
	h=colorbar;
%	set(h, 'fontsize',4);
	
	xlabel('Pattern Number (Lag Day = 0)','fontsize',13);
	ylabel('Pattern Number (Lag Day = +1)','fontsize',13);

	set(gcf, 'Units', 'pixels');
	set(gcf, 'Papersize',[800,800])
 	set(gcf, 'Position', [3 3 797 797]);
	saveas(gcf,[dataname,'/transition_normalized',dataname,'.eps'],'psc2')







































