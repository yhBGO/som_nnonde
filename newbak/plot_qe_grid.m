
load som_qe_te_2s_7s
plot(nrc.^2,qe(2:end),'r*')
set(gca,'ylim',[150 200],'fontsize',15)
xlabel('pattern number','fontsize',15)
ylabel('qe','fontsize',15)
set (gcf,'PaperUnits','normal')
set(gcf, 'PaperPosition', [-0 -0 0.999 0.999]);
saveas(gcf,'qe_grid.pdf','pdf')
close


plot(nrc.^2,te(2:end),'b*')
set(gca,'fontsize',15)
xlabel('pattern number','fontsize',15)
ylabel('te','fontsize',15)
set(gcf)
set (gcf,'PaperUnits','normal')
set(gcf, 'PaperPosition', [-0 -0 0.999 0.999]);
saveas(gcf,'te_grid.pdf','pdf')
close

 

