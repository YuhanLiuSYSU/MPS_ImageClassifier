function [ Env ] = Update_Env( Env,Left,Sample,Right,delta,IsEdge,varargin)

if(~IsEdge)
    if(numel(varargin)==0)
        Env_n=GetEnvTensor(Right,Sample,Left);
    else
        Env_n=GetEnvTensor(Right,Sample,Left,varargin{1});
    end
else
    if(numel(varargin)==0)
        T=Sample*(Left.'); 
        Env_n=T/max(abs(T(:)));
    else
        Nsample=size(Sample,2);
        Env_n=zeros(size(varargin{1}));
        for n=1:Nsample
            Z=Sample(:,n).'*varargin{1}*Left(:,n);
            Env_n=Env_n+Sample(:,n)*(Left(:,n).')/abs(Z);
        end
    end
end

if(abs(1-delta)>1e-14)
    Env=Env*(1-delta)+Env_n*delta;
    Env=Env/max(abs(Env(:)));
else
    Env=Env_n;
end
end

