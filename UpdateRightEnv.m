function Right1=UpdateRightEnv(A,Samples,Right)
Nsample=size(Samples,2);
[d2,d,d1]=size(A);

Right1=zeros(d1,Nsample);
for n=1:Nsample
    Right1(:,n)= (Samples(:,n).' * (reshape( Right(:,n).'*reshape(A,[d2,d*d1]),[d,d1] ))).';
    Right1(:,n)=Right1(:,n)/norm(Right1(:,n));
end
end