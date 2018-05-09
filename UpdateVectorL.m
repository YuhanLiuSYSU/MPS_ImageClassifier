function [ Left ] = UpdateVectorL( MPS,Sample,Label,L_o)
Left=cell(L_o,1);
Left{1}=Label;

for i=2:L_o
    Left{i}=UpdateLeftEnv(MPS{i-1},Sample{i-1},Left{i-1});
end
end