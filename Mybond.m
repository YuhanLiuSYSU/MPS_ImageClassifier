function [ bond ] = Mybond( bonddim,d,L_o )

bond=bonddim*ones(1,L_o); %the first is not used
if bonddim>d
    flag=1;i=L_o;tempd=d;
    while(flag)
        bond(i)=tempd;
        tempd=tempd*d;
        if tempd>bonddim
            flag=0;
        else
           i=i-1;           
        end
    end
end

end

