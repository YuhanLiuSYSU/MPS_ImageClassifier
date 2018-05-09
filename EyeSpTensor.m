function Delta=EyeSpTensor(Order,Dim)
%5,6
Ele=diag(1:Dim)*ones(Dim,Order);
Delta=sptensor(Ele,ones(Dim,1));
end