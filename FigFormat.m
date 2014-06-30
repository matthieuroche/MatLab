function FigFormat(fig_handle,nline)
set(gcf,'WindowStyle','normal')
set(gcf,'Units','centimeters')
set(gcf,'Position',[10 10 18.3 nline*5.69])
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperSize',[18.3 nline*5.69])
set(fig_handle,'Color','white');
children_Figure=get(fig_handle,'children')
size_Children=size(children_Figure,1)

for i=1:size_Children
    i
    children_Figure(i)
    set(children_Figure(i),'Units','centimeters')
    set(children_Figure(i),'XTickLabelMode','manual');
    set(children_Figure(i),'YTickLabelMode','manual');
    set(children_Figure(i),'FontSize',7);set(gca,'FontName','Helvetica LT Std');
    set(children_Figure(i),'XTickLabelMode','auto');
    set(children_Figure(i),'YTickLabelMode','auto');
       
    left_Position=(i-1)*9.15+1.5
    set(gca,'Position',[left_Position 1 7 4.5])
       
end
end
