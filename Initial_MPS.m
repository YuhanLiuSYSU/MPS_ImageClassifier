function MPS = Initial_MPS( Npixel,d,chi,Labelbond )
bond=Mybond( chi,d,Npixel );

MPS=cell(Npixel,1);
for i=2:Npixel-1
    bondr=bond(i+1);bondl=bond(i);
    Tmp=rand(bondr,d,bondl);    
    [Tmp,~]=qr(reshape(Tmp,[bondr*d,bondl]),0);
    MPS{i}=reshape(Tmp,[bondr,d,bondl]);
end

%first tensor
Tmp=rand(bond(2),d,Labelbond);     
[Tmp,~]=qr(reshape(Tmp,[bond(2)*d,Labelbond]),0);
MPS{1}=reshape(Tmp,[bond(2),d,Labelbond]);
%last tensor   NOTICE: will have problem if d<bonddim  because after qr,
%Tmp
Tmp=rand(d,bond(Npixel));     
[Tmp,~]=qr(reshape(Tmp,[d,bond(Npixel)]),0);
MPS{Npixel}=reshape(Tmp,[d,bond(Npixel)]);

end

