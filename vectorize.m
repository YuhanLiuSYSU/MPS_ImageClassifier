function[VImages]=vectorize(Images,d,L,IsVec,Angel)
S=size(Images);

% Rearrange the angel to [Angel(1) - Angel(2)]

if(IsVec)
    VImages=zeros(S(1),d);
    Lc=numel(Images);
    %d=2;
    for s=1:d
        fac=sqrt(nchoosek(d-1,s-1));
        for u=1:Lc
            Theta=pi/2*((Angel(2)-Angel(1))*Images(u)+Angel(1));
            VImages(u,s)=fac*(cos(Theta))^(2-s)*(sin(Theta))^(s-1);
        end
    end
else
    VImages=zeros(S(1),S(2),d);
    for s=1:d
        fac=sqrt(nchoosek(d-1,s-1));
        for u1=1:L
            for u2=1:L
                Theta=pi/2*((Angel(2)-Angel(1))*Images(u1,u2)+Angel(1));
                VImages(u1,u2,s)=fac*(cos(Theta))^(2-s)*(sin(Theta))^(s-1);
            end
        end
    end
end
end

