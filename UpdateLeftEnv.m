function Left1=UpdateLeftEnv(A,Samples,Left)
Nsample=size(Samples,2);
[d2,d,d1]=size(A);

Left1=zeros(d2,Nsample);

for n=1:Nsample
    Left1(:,n)=reshape( reshape(A,[d2*d,d1])*Left(:,n),[d2,d] )*Samples(:,n);
    Left1(:,n)=Left1(:,n)/norm(Left1(:,n));
end
end