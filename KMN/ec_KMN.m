function e = ec_KMN( yanal , ynum, space, plotgraph)
  
global Jpattern solv nx ;
diff=yanal-ynum ;
for i =1:11
a( i )=norm( diff(i,:));
if plotgraph==1
    figure;
    plot( space , diff( i , : ) , 'g' ) ;
    %title( [' Simulateur KMN avec intégrateur ' , num2str(solv) , ' ,nbre de points: ' , num2str(nx), ' ,Jpattern: ' , num2str(Jpattern)  ])
    hold on
end
end
e=sum( a ) ;
e=e/11;
end
