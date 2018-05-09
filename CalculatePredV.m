function [ Right] = CalculatePredV( MPS,Sample,L_o)
Right=MPS{L_o}.'*Sample{L_o};

for i=L_o-1:-1:1
    Right=UpdateRightEnv(MPS{i},Sample{i},Right);
end
end
