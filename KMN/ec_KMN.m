function e = ec_KMN( yanal , ynum, space)
  
global Jpattern solv nx ;
diff=yanal-ynum ;
for i =1:11
a( i )=norm( diff(i,:));
plot( space , diff( i , : ) , 'g' ) ;
title( [' ec du simulateur KMN avec jpattern ' , num2str(Jpattern) , ' solv: ' , num2str(solv) , 'nbre de points: ' , num2str(nx) ])
hold on
end
e=sum( a ) ;
e=e/11;
end
