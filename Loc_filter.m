function [v]=Loc_filter(v)

wp=10;ws=50;rp=0.5;rs=10;Fs=2000;
[N,Wn]=buttord(wp/(Fs/2),ws/(Fs/2),rp,rs);
[b,a]=butter(N,Wn);
[H,W]=freqz(b,a);
Y=filtfilt(b,a,v);
v=Y;

end