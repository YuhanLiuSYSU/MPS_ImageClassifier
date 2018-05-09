function Env=GetEnvTensor(Right,Sample,Left,varargin)
% varargin{1} is the tensor in the MPS
Ni=numel(varargin);

[d,Nsample]=size(Sample);
d2=size(Right,1); d1=size(Left,1); 
Env=zeros(d2,d,d1);

for n=1:Nsample
    if(Ni==0)
        Env=Env+reshape( reshape(Right(:,n)*Sample(:,n).',[d2*d,1])*(Left(:,n).'),[d2,d,d1] );
    else
         Z=Right(:,n).'*reshape( reshape(varargin{1},[d2*d,d1]) * Left(:,n),[d2,d] )*Sample(:,n);
         Env=Env+reshape( reshape(Right(:,n)*Sample(:,n).',[d2*d,1])*(Left(:,n).'),[d2,d,d1] )/abs(Z);
    end
end
Env=Env/max(abs(Env(:)));
end