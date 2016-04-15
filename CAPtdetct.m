function [XCL,YCL,X_edge,Y_edge,Locx,Locy,theta] = CAPtdetct( BW,I,P,y_d,Criteraa,L_up)
%this function detects the lowest point of the interest circle region
Contf_overpixel=2; % with how many pixels above which the contact line is detected

[col,row,ind]=size(I);
Ie=edge(I,'canny',Criteraa);   %0.6 
IMD=Ie.*BW;
imshow(I)
    
    for j=1:col
        if sum(IMD(j,:))>0
            break
        end
    end
    Ymin=j;
    
    for k=Ymin:1:col
        if sum(IMD(k,:))==0
            break
        end
    end
    
    Ymax=floor(y_d);
    
    x=[];
    y=[];
    for k=Ymin:1:Ymax
        X=find(IMD(k,:)==1);
        x=[x X];
        L=length(X);
        dy=k*ones(1,length(X));
        y=[y dy];
    end
    
    x=x(end-0.8*L_up:end-3);y=y(end-0.8*L_up:end-3);
    hold on
    plot(x,y,'c.')
    axis equal
   
    x_fr=y(1);y_fr=x(1);
    XY=[x',y'];
    Par = CircleFitByTaubin(XY);
    xc=Par(1);yc=Par(2);R=Par(3);
    
    fai0=atan((yc-y_fr)/(xc-x_fr));
    fai=fai0:0.01:fai0+2*pi;
    xf=xc+R*cos(fai-pi/2);
    yf=yc+R*sin(fai-pi/2);
    plot(xf,yf,':')
    plot(xc,yc,'m^')
    D=abs(-P(1)*xc+yc-P(2))/sqrt(P(1)^2+1);
    if D<R
            if yc>polyval(P,xc)
                if xc<max(x)
                    theta=acos(D/R)*180/pi
                    XCL=xc+R*sin(theta/180*pi);
                    YCL=yc-R*cos(theta/180*pi);
                    X_edge=XCL;
                    Y_edge=YCL;
                    plot(XCL,YCL,'*r')
                end
            else
                if xc<max(x)
                    theta=180-acos(D/R)*180/pi
                    XCL=xc+R*sin(theta/180*pi);
                    YCL=yc-R*cos(theta/180*pi);
                    X_edge=xc+R;
                    Y_edge=yc;
                    plot(XCL,YCL,'*r')
                else
                    theta=acos(D/R)*180/pi
                    XCL=xc-R*sin(theta/180*pi);
                    YCL=yc+R*cos(theta/180*pi);
                    X_edge=XCL;
                    Y_edge=YCL;
                    plot(XCL,YCL,'*r')
                end
            end
    else
        disp('No contact')
    end
    
    Locxa = x(end);
    Locy = floor(polyval(P,XCL))-Contf_overpixel;
    [Locx] = Locfit(Locxa,Locy,I,1);
    plot(Locx,Locy,'co')
    pause(0.1)
    

    
end

