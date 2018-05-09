function [ BEE,SEE ] = Entangle( MPS )
% The MPS has to be in the right-to-left orthogonal form
%            2
%            |
%  3  -   A  -  1
    Npixel=length(MPS);
    BEE=zeros(Npixel,1);
    SEE=zeros(Npixel,1);

    MPSt=MPS{1};
    S=size(MPSt);
    Tuni=reshape(MPSt,[prod(S(1:2)),S(3)]);
    Lambda=svd(Tuni,0);
    dim=min(prod(S(1:2)),S(3));lambda=Lambda(1:dim);
    BEE(1)=Entanglement(lambda);
    SEE(1)=Entropy_calc(MPSt,3);
    
for n=1:Npixel-1
    MPSt=MPS{n};
    S=size(MPSt);
    Tuni=reshape(MPSt,[S(1),prod(S(2:3))]);
    [U,Lambda,~]=svd(Tuni,0);
    dim=min(S(1),prod(S(2:3)));
    lambda=diag(Lambda(1:dim,1:dim));
    BEE(n+1)=Entanglement(lambda);

    if n~=Npixel-1
        [d2,d,d1]=size(MPS{n+1});
        MPS{n+1}=reshape(MPS{n+1},[d2*d,d1])*U(:,1:dim)*diag(lambda); 
        MPS{n+1}=reshape(MPS{n+1},[d2,d,dim]);
        SEE(n+1)=Entropy_calc(MPS{n+1},3);
    else
        MPS{n+1}=MPS{n+1}*U(:,1:dim)*diag(lambda);
        SEE(n+1)=Entropy_calc(MPS{n+1},2);
    end
     
end
end

function[sin_entropy]=Entropy_calc(MPSt,flag)
      % for the last site, flag=2; for others, flag=3;      
      if flag==3
          [dr,d,dl]=size(MPSt);
          MPSt=reshape( permute(MPSt,[1,3,2]),[dr*dl,d] );
          reduceDM=MPSt'*MPSt;
      elseif flag==2
          reduceDM=MPSt*MPSt';
      end
      reduceDM=svd(reduceDM);
      Ne=find(reduceDM>0,1,'last');
      reduceDM=reduceDM(1:Ne);
      reduceDM=reduceDM/sum(reduceDM);
      sin_entropy=-reduceDM.'*log(reduceDM);
end