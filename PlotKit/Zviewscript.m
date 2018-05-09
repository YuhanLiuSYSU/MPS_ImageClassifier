for i=0:8
    for j=i+1:9
       load(['data/MPSreal/MPS_Class(',num2str(i),'-',num2str(j),')_d(2,16)_Map1.mat']);
       tstring=[num2str(i),'-',num2str(j),' classifier'];
       PlotEntropyZview(SEE,tstring);

    end
end
