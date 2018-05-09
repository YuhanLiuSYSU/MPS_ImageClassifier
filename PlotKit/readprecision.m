Precision_total=zeros(10,10);
for i=0:8
   for j=i+1:9
     
       
      load(['MPS_Class(',num2str(i),'-',num2str(j),')_d(',num2str(Info.d),',',num2str(Info.bonddim),')_Map',num2str(Info.featuremap)]); 
      
      
      if i==0
          ii=10;
      else
          ii=i;
      end
      Precision_total(ii,j)=test_precision(5); 
       
   end
    
end