function test()
    data1=importdata('phantom1_data.txt');
    data2=importdata('phantom2_data.txt');
    data3=importdata('phantom3_data.txt');
    data4=importdata('phantom4_data.txt');
    data5=importdata('phantom5_data.txt');
    data6=importdata('phantom6_data.txt');
    data7=importdata('phantom7_data.txt');
    data8=importdata('phantom8_data.txt');
    data9=importdata('phantom9_data.txt');
    data10=importdata('phantom10_data.txt');
    data11=importdata('phantom11_data.txt');
    data12=importdata('phantom12_data.txt');
    data13=importdata('phantom13_data.txt');
    data14=importdata('phantom14_data.txt');
    data15=importdata('phantom15_data.txt');
    dataShort=importdata('short_data.txt');
    
   


    [freqs1,reZ1,imZ1,Zs1]=parsedata(data1);
    [freqs2,reZ2,imZ2,Zs2]=parsedata(data2);
    [freqs3,reZ3,imZ3,Zs3]=parsedata(data3);
    [freqs4,reZ4,imZ4,Zs4]=parsedata(data4);
    [freqs5,reZ5,imZ5,Zs5]=parsedata(data5);
    [freqs6,reZ6,imZ6,Zs6]=parsedata(data6);
    [freqs7,reZ7,imZ7,Zs7]=parsedata(data7);
    [freqs8,reZ8,imZ8,Zs8]=parsedata(data8);
    [freqs9,reZ9,imZ9,Zs9]=parsedata(data9);
    [freqs10,reZ10,imZ10,Zs10]=parsedata(data10);
    [freqs11,reZ11,imZ11,Zs11]=parsedata(data11);
    [freqs12,reZ12,imZ12,Zs12]=parsedata(data12);
    [freqs13,reZ13,imZ13,Zs13]=parsedata(data13);
    [freqs14,reZ14,imZ14,Zs14]=parsedata(data14);
    [freqs15,reZ15,imZ15,Zs15]=parsedata(data15);
    [freqsS,reZS,imZS,ZsS]=parsedata(dataShort);

    figure()
    plot(freqs1,Zs1)
    hold on
%     plot(freqs2,Zs2)
%     hold on
%     plot(freqs3,Zs3)
%     hold on
%     plot(freqs4,Zs4)
%     hold on
    plot(freqs5,Zs5)
    hold on
    plot(freqs6,Zs6)
    legend('1','5','6')
    

    function [freqs,reZ,imZ,Zs]=parsedata(data)
        for a=1:length(data)
            dat=data(a);
            dat=dat{1};
            ou=split(dat);
            if length(ou)==3
                tmp=ou{1};
                freq=sscanf(tmp,'%f');
                if ~isempty(sscanf(tmp,'%f'))
                    fs(a)=freq;
                end
                tmp=ou{2};
                comp=sscanf(tmp,'R=%f/I=%f');
                if ~isempty(comp)
                    RI(:,a)=comp;
                end
                tmp=ou{3};
                z=sscanf(tmp,'|Z|=%f');
                if ~isempty(comp)
                    zs(a)=z;
                end
            end
        end
        freqs=fs;
        reZ=RI(1,:);
        imZ=RI(2,:);
        Zs=zs;
    end
end
