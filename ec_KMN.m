function e = ec_KMN( yanal , ynum, space)
diff=yanal-ynum ;
for i =1:11
a( i )=norm( diff(i,:));
plot( space , diff( i , : ) , 'g' ) ;
hold on
end
e=sum( a ) ;
e=e/11;
end
