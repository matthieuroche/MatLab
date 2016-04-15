% This script enables to calculate the contact angle by selecting the
% droplet edge and substrate surface by hand.

%Methodology
%The droplet is fitted into a circle
%The substrate surface is fitted into a line.

%By Menghua ZHAO
%12.1.2015
%@MSC, PARIS DIDROT UNIVERSITY

%%
clear
clc
close all
Calibration=0.013;
I=imread('F:\Experimental data\28thSep\CONTACT ANGLE\SS16\RCD5.bmp');
imshow(I);
title('please select the center of the droplet')
[XC0,YC0]=ginput(1);hold on,plot(XC0,YC0,'RO')
WD=50;
S=I(round(YC0)-WD:round(YC0)+WD,round(XC0)-WD:round(XC0)+WD);
figure;imshow(S); hold on
%%
%calculate the drop size
title('Please select the edge point to indicate the dropsize')
[XC1,YC1]=ginput(1);hold on,plot(XC1,YC1,'RO')
[XC2,YC2]=ginput(1);hold on,plot(XC2,YC2,'RO');plot([XC1,XC2],[YC1,YC2],'R-')
Dis=Calibration*sqrt((XC2-XC1)^2+(YC2-YC1)^2)

%%
%select the droplet interface

%by hand
% title('Please select the drop edge')
% [X,Y]=ginput;
% hold on
% plot(X,Y,'o')

%by edge detection
IE=edge(S,'canny',0.5);
title('Please select the region containing the edge of the droplet')
hold on
BWD=roipoly;
IMD=IE.*BWD;
[Y,X]=find(IMD==1);
%%
[xc,yc,R,a] = circfit(X,Y);
x=xc-R:1:xc+R;
y1=yc+(R^2-(x-xc).^2).^(1/2);
y2=yc-(R^2-(x-xc).^2).^(1/2);
hold on
plot(x,y1,':')
plot(x,y2,':')

title('Please select the substrate line')
[XL,YL]=ginput;
P=polyfit(XL,YL,1);
z=polyval(P,x);
hold on
plot(x,z,':')
D=abs(-P(1)*xc+yc-P(2))/sqrt(P(1)^2+1);
if yc<z(1)   
    disp('the hydrophobic contact angle:')
    theta=180-acos(D/R)*180/pi
else
    disp('the hydrophilic contact angle:')
    theta=acos(D/R)*180/pi
end