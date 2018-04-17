function F=IntervalFeature(ECG,time,Fs)
% time in min
samples=(time-1)*60*Fs+1:time*60*Fs;
ECG_=ECG(samples);
%% detect qrs using Pan-Tompkin algorithm or Other
ECG_=ECG_/max(ECG_);
[qrs_amp_raw,qrs_i_raw]=findpeaks(ECG_,'MinPeakDistance',Fs/2,'MinPeakHeight',.3*max(ECG_));
figure(1)
clf
plot(ECG_); hold on; plot(qrs_i_raw,qrs_amp_raw,'o')
pause(.001);
% [qrs_amp_raw,qrs_i_raw]=pan_tompkin(ECG_,Fs,1);
RR_Interval=diff(qrs_i_raw);
%% Interval Extraction
ib=1;
ie=numel(RR_Interval);
PossibleLength=2:2:ie;
k=1;
Segments={};
for starting_at=ib:ie
    for len=PossibleLength
        if len+starting_at<=ie
            Segments{k}.data=RR_Interval(starting_at:starting_at+len);
            Segments{k}.ie=starting_at+len;
            Segments{k}.ib=starting_at;
            k=k+1;
        end
    end
end
%% Features
MEAN=[];
STD=[];
COV=[];
for i=1:numel(Segments)
    ie=Segments{i}.ie;
    ib=Segments{i}.ib;
    u=mean(Segments{i}.data);
    MEAN=[MEAN  u ];
    STD=[STD std(Segments{i}.data)];
    cov=(1/(ie-ib+1))*((ib:ie).*Segments{i}.data)-u*(ib+ie)/2;
    COV=[COV cov];
end
F=[MEAN STD COV];
% F=[mean(MEAN), mean(STD),mean(COV)];
end