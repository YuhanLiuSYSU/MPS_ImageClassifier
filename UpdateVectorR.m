function [ VecR_1 ] = UpdateVectorR(MPS,Sample,VecR,IsEdge)
% From VecR{N}, update VecR{N-1}
if (IsEdge==0)
    VecR_1=UpdateRightEnv(MPS,Sample,VecR);
else
    mycount=size(Sample,2);
    Cnor=zeros(mycount);
    VecR_1=MPS.'*Sample;
    for n=1:mycount
        Cnor(n)=norm(VecR_1(:,n));   
        VecR_1(:,n)=VecR_1(:,n)/Cnor(n);
    end
end
end