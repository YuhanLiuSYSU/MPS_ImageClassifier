function [ Sequence] = FindSequence(sum,L)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
sequence=zeros(L,2);
flag=0;
start=max(sum-L,1);
for i=start:L
   for j=start:L
       if i+j==sum
            flag=flag+1;
          sequence(flag,:)=[i,j];         
       end
   end    
end
sequence=sequence(1:flag,:);
Sequence=zeros(flag,2);
if(~mod(sum,2))
    start=min(sequence(:,1));
    for i=start:sum/2
        ii=i-start+1;
       Sequence(ii,:)=sequence(flag+1-ii,:);
        Sequence(flag+1-ii,:)=sequence(ii,:);
    end
else
    Sequence=sequence;
end

end

