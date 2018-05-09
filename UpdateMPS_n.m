function [MPS] = UpdateMPS_n(T,IsEdge)
if (IsEdge==0)
    S=size(T);
    Tuni=reshape(T,[prod(S(1:2)),S(3)]);
    [Tuni,~,V]=svd(double(Tuni),0);
    MPS=reshape(Tuni*(V'),S);
else
    S=size(T);
    Tuni=reshape(T,S(1:2));
    [Tuni,~,V]=svd(Tuni,0);
    MPS=reshape(Tuni*(V'),S);
end