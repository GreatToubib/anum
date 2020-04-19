function e = ec ( yanal , ynum, x )
diff=yanal-ynum ;
for i =1:11
a( i )=norm( diff(i,:));
plot( x , diff( i , : ) , 'g' ) ;
hold on
end
e=sum( a ) ;
e=e/11;
end
