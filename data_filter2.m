function [v]=data_filter2(v0)
S=1;
switch S
    case 1
    %
        wp=0.01;ws=0.1;rp=0.1;rs=20;Fs=1;
        [N,Wn]=buttord(wp/(Fs/2),ws/(Fs/2),rp,rs);
        [b,a]=butter(N,Wn);
        [H,W]=freqz(b,a);
        Y=filtfilt(b,a,v0);
        v=Y;
    case 2
        thr=35;
        %
        [xd,cxd,lxd,prefl2]=wdencmp('gbl',v0,'db3',3,thr,'h',1);
        v=xd;

    case 3
        thr=35;
        %
        [thr,sorh,keepapp]=ddencmp('den','wv',v0);
        xd=wdencmp('gbl',v0,'db3',2,thr,sorh,keepapp);
        v=xd;

end

end