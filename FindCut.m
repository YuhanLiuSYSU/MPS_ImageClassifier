function [ Np ] = FindCut( BEE )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Np=length(BEE);
shreshold=max(BEE)/3;
for i=1:length(BEE)
   if BEE(i)<shreshold
      Npflag=0;
      for j=i+1:length(BEE)
         if BEE(j)>shreshold 
             Npflag=1;
             break
         end
      end
      if Npflag==0
          Np=i;
      end
   end
   if Np<length(BEE)
       break
   end
end

end

