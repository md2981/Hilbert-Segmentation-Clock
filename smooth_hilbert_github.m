data=importdata();
win_size=10;

%1st column is time in hours, each subsequent column is one cell. No column titles


[n_row,n_col]=size(data);

dt = data(2,1)-data(1,1);
Fs = 1/dt;
x = data(:,1);
x1=data((1:n_row-1),1);

out_data_smooth=zeros(n_row,n_col);
out_data_smooth(:,1)=x;

out_data_regular=zeros(n_row,n_col);
out_data_regular(:,1)=x;

for i=2:n_col
    y = data(:,i);
    y2 = sgolayfilt(y,3,11);
    out_data_smooth(:,i)=y2;
    if win_size~=0
        y1=y2-movmean(y2,win_size);
        y1=sgolayfilt(y1,3,11);
        y1=smoothdata(y1);
        out_data_smooth(:,i)=y2;
        out_data_regular(:,i)=y1;
        figure()
        plot(x,y, 'r')
        hold on
        plot(x,y1, 'g')
        hold on
        plot(x,y2, 'b')
    end
    
end

out_data_amplitude=zeros(n_row,n_col);
out_data_amplitude(:,1)=x;


for i=2:n_col
    y = out_data_regular(:,i);
    y = hilbert(y);
    inst_amplitude = abs(y);
    out_data_amplitude(:,i)=inst_amplitude;


end


out_data_period=zeros((n_row-1),n_col);
out_data_period(:,1)=x1;

for i=2:n_col
    y = out_data_regular(:,i);
    y = hilbert(y);
    inst_phase=unwrap(angle(y));
    inst_freq=diff(inst_phase)/(2*pi)*Fs;
    inst_period=(1)./(inst_freq);
    out_data_period(:,i)=inst_period;


end


