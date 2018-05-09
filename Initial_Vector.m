function [ Left,Right] = Initial_Vector( MPS,Sample,Label,L_o)
Right=cell(L_o,1); 

Right{L_o}=MPS{L_o}.'*Sample{L_o};
for i=L_o-1:-1:1
    Right{i}=UpdateRightEnv(MPS{i},Sample{i},Right{i+1});
end

Left=cell(L_o,1);
Left{1}=Label;

for i=2:L_o
    Left{i}=UpdateLeftEnv(MPS{i-1},Sample{i-1},Left{i-1});
end

% Env=cell(L_o,1);
% for i=1:L_o-1
%     Env{i}=GetEnvTensor(Right{i+1},Sample{i},Left{i});
% end
% T=Sample{L_o}*(Left{L_o}.');
% Env{L_o}=T/max(abs(T(:)));
end
