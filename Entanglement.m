function [ent]=Entanglement(lambda)
lambda=lambda/norm(lambda);
Eps=1e-20;
dc=find(lambda>Eps,1,'last');
lambda=lambda(1:dc);
ent=-(lambda.^2)'*log(lambda.^2);
end