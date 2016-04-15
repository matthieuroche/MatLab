%This script enables to calculate either the STATIC/DYNAMIC contact angle 
%and three contact line positions, which are extracted by different critia,
%with regards to time.

%Notice: the droplet is partly fitted into a circle, the scale of fitting
%makes a difference. besides, if the contact point is taken directly from
%the edge, be careful of the number of pixel which indicates the position
%above the substrate surface that is designated by hand.

% XCL    :  Circle Fitted CL Position
% x_CLP  :  Local CL Position
% x_CLP_f:  Local Gaussian Fit CL Position

%By Menghua ZHAO
%22.11.2015
%@MSC, PARIS DIDEROT UNIVERSITY ET @SIMM, ESPCI-PARISTECH

%%
%Initialization
clear
clc
close all


FileLength = 453; %Number of Frames
Namelength = 455; %Number of Frames+2 (c'est ce que dit Menghua)
filename='PurePEG_results_3mL.mat'; %Fichier de stockage des résultats
SBL=200;  % the frame to find the substrate

Calibration=0.0136; % mm/pixel
Fps=30;  % speed of capturing, unit: frame per second
Dirtr1 = ['/Users/matthieu/Documents/MATLAB/Avec Babette/PurePEG test/'];% Répertoire où sont stockées les images
L_in = 100;  % number of the sampling pixel inside the droplet
L_out= 20; % number of the sampling pixel outside the droplet
L_up = 100; % number of the sampling pixel upwards the contact point
Timeinterval= 1/Fps; 
delta_L = Calibration;

%names of dynamic wetting pictures
for i=1:Namelength
    if i<10
        Filename{i}=['PurePEG_3mLmin0007_1000',num2str(i),'.bmp'];
    elseif i>9&&i<100
        Filename{i}=['PurePEG_3mLmin0007_100',num2str(i),'.bmp'];
    elseif  i>99&&i<1000
        Filename{i}=['PurePEG_3mLmin0007_10',num2str(i),'.bmp'];
    elseif  i>999
        Filename{i}=['PurePEG_3mLmin0007_1',num2str(i),'.bmp'];
    end
end

% to give a proper threshold to the edge detection technique
    for ii=1:100
        Criteraa = input('Please input the Critera value(0-1)for the edge detection = ')
        for j=1:20:FileLength
            IV=imread([Dirtr1,Filename{j}]);
            imshow(edge(IV,'canny',Criteraa)); hold on
            pause(0.01)
        end
        CDT = input('the value is proper or not [yes(1), no(0)]  =  ' )
        if CDT ==1
            break
        end
    
    end

%Substrate
figure
IL = imread([Dirtr1,Filename{SBL}]);
imshow(IL)
title('Please select the substrate line')
[XL,YL]=ginput
xs=min(XL):1:max(XL)
P=polyfit(XL,YL,1)
z=polyval(P,xs)
hold on
plot(xs,z,'w:','LineWidth',2)

%Region Of Interest
%Drop
I = imread([Dirtr1,Filename{1}]);
imshow(I);
title('Please select the region containing the edge of the droplet')
hold on
[BW, XR, YR]=roipoly;

x_l=min(XR);x_r=max(XR);y_u=min(YR);y_d=min(polyval(P,x_l),polyval(P,x_r));
c=[x_l x_r x_r x_l];
r=[y_u y_u y_d y_d];
BW=roipoly(I,c,r);
[XCL(1),YCL(1),X_edge(1),Y_edge(1),Locx(1),Locy(1),CA(1)]=CAPtdetct(BW,I,P,y_d,Criteraa,L_up);
%%
hold on
plot(xs,z,'c:','LineWidth',2)
for i=1:1:FileLength
    
    if ~rem(i,200)
        mmm=1;
    end
    
    if ~rem(i,10)
        close all
    end
    

    I = imread([Dirtr1,Filename{i}]);
    I =medfilt2(I,[2,2]);
    % moving mask
    if i==1
        c=[Locx(1)-L_in Locx(1)+L_out Locx(1)+L_out Locx(1)-L_in];
        r=[Locy(1)-L_up Locy(1)-L_up y_d y_d];
    else
        y_d=min(polyval(P,XCL(i-1)),YCL(i-1));
        c=[XCL(i-1)-L_in XCL(i-1)+L_out XCL(i-1)+L_out XCL(i-1)-L_in];
        r=[YCL(i-1)-L_up YCL(i-1)-L_up y_d-2 y_d-2];
    end
    BW=roipoly(I,c,r);
    [XCL(i),YCL(i),X_edge(i),Y_edge(i),Locx(i),Locy(i),CA(i)]=CAPtdetct(BW,I,P,y_d,Criteraa,L_up);
end
%%
%Unit Conversion
XCL=Calibration*XCL(1:end-1);
YCL=Calibration*YCL(1:end-1);
X_edge=Calibration*X_edge(1:end-1);
Y_edge=Calibration*Y_edge(1:end-1);
CA=CA(1:end-1);
T=Timeinterval*(1:length(CA));
V=diff(-XCL)/Timeinterval;
Vf=diff(-Calibration*Locx)/Timeinterval;
%%
figure
subplot(121),plotyy(T,CA,T(1:end-1),V),xlabel('Time  /s'),ylabel('\theta');
legend('Contact angle  degree',' Velocity  mm/s')
subplot(122),plot(T, XCL,'b'),hold on,plot(T,X_edge,'c')
xlabel('Time  /s'),ylabel('Position  /mm')
legend('Contact Point Position /mm','Shading Edge Position')

figure,plot(Vf,CA,'.')
xlabel('Receding velocity [mm/s]'),ylabel('Contact Angle [¡ã]')
% !!!! Modify the filename everytime
save(filename)

% 
% % 
% for i=1:1:length(Vf)
% %     axis([300 650 430 433])
%     plot(Locx(i),Locy(i),'ro'),pause(0.1);plot(Locx(i),Locy(i),'bo')
%     hold on
%  SS(i)=getframe;
% end

