function [ Loc] = Locfit(M,K,AA,Method)

AA=double(AA);
hold on
L=25;
Lf=5;

DX=(M-L):(M+L-1);
D = data_filter2(AA(K,M-L:M+L));
Diff = diff(D);

[mm,nn]= max(Diff);
Mf=(M-L)+nn-1;

DXf=(Mf-Lf):(Mf+Lf-1);
Difff = Diff(nn-Lf:nn+Lf-1);
%Gaussian Fit
xdata=DXf';
ydata=Difff';
Y=log(ydata+exp(1));
X=xdata;
f=polyfit(X,Y,2);
Loc=-f(2)/(2*f(1));




end

