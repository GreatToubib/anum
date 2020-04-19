close all
clear all
% . . .
%Debut du chronome tre
% . . .
tic
% . . .
%V a r i a b l e s g l o b a l e s du probleme
% . . .
global x0 xL n D1 D2 ;
% . . .
%G r i l l e s p a t i a l e
% . . .
x0= -10.0;
xL=10.0;
n=501;
dx=(xL-x0 ) / ( n-1);
x=[ x0 : dx : xL ]' ;
% . . .
%C o n d i t i o n s i n i t i a l e s
% . . .
u=zeros ( n , 1 ) ;
for i =1:n
u ( i ) = u_anal ( x ( i ) , 0 ) ;
end ;
% . . .
%Schemas de d i f f e r e n c e s f i n i e s pour l e s d e r i v e e s s p a t i a l e s
% . . .
%De r ivee p rem ie re
%D1=f ive_po in t_b iased_upw ind_D1 ( x , 1 ) ;
%D1=f ive_po in t_b iased_upw ind_D1 ( x , ?1) ;
%D1=f ive_po in t_cen tered_D1 ( x ) ;
%D1=four_po int_b iased_upw ind_D1 ( x , 1 ) ;
%D1=four_po int_b iased_upw ind_D1 ( x , ?1) ;
%D1=four_point_upwind_D1 ( x , 1 ) ;
%D1=four_point_upwind_D1 ( x , ?1) ;
30
%D1=three_po in t_cen tered_D1 ( x ) ;
%D1=three_point_upwind_D1 ( x , 1 ) ;
%D1=three_point_upwind_D1 ( x , ?1) ;
%D1=two_point_upwind_D1 ( x , 1 ) ;
D1=two_point_upwind_D1 ( x , -1 );
%De r ivee sec on de
D2=five_point_centered_D2 ( x ) ;
%D2=three_po in t_cen tered_D2 ( x ) ;
% . . .
%Ma tr ice pour l e JP a t te rn
% . . .
J = [ spones( eye( n ) ) + spones(D1) + spones(D2 ) ] ;
J = spones( J ) ;
J = sparse( J ) ;
% . . .
%Parame tres de l ’ i n t e g r a t i o n t e m p o r e l l e
% . . .
t = [ 0 : 0.5 : 5 ] ;
%o p t i o n s = o d e s e t ( ’ RelTol ’ , 1 e ?5 , ’ AbsTol ’ , 1 e ?5 , ’ s t a t s ’ , ’ on ’ ) ;
options = odeset(  'RelTol' ,1e-5,  'AbsTol' , 1e-5, 'stats' ,  'on') ;
% . . .
%I n t e g r a t i o n t e m p o r e l l e
% . . .
%S o l v e u r s non s t i f f
[ tout , yout ] = ode45( @BurgerFisherDiff , t , u , options ) ;
%[ t o u t , y o u t ] = ode23 ( @Bu rge rF i s he rD i f f , t , u , o p t i o n s ) ;
%[ t o u t , y o u t ] = ode113 ( @Bu rge rF i s he rD i f f , t , u , o p t i o n s ) ;
%S o l v e u r s s t i f f
%[ t o u t , y o u t ] = ode15s ( @Bu rge rF i s he rD i f f , t , u , o p t i o n s ) ;
%[ tout , yout ] = ode23s(@BurgerFisherDiff , t , u , options ) ;
%[ t o u t , y o u t ] = o de 2 3 tb ( @Bu rge rF i s he rD i f f , t , u , o p t i o n s ) ;
%[ t o u t , y o u t ] = o de 2 3 t ( @Bu rge rF i s he rD i f f , t , u , o p t i o n s ) ;
% . . .
%Rapa tr iemen t de s c o n d i t i o n s aux l i m i t e s
% . . .
for k=1:length( tout )
yout( k , 1 ) = u_anal( x0 , tout( k ) ) ;
yout( k , n ) = u_anal( xL , tout( k ) ) ;
end
31
% . . .
%Fin du chronome tre
% . . .
tcpu = toc
% . . .
%A f f i c h a g e de l a s o l u t i o n a n a l y t i q u e VS s o l u t i o n numer ique
% . . .
%S o l u t i o n numer ique
plot( x , yout , '.-k' ) ;
xlabel( 'x' ) ;
ylabel( 'u(x,t)' ) ;
title( ' Equation de Burger?Fisher : Differences Finies ' )
hold on
%S o l u t i o n a n a l y t i q u e
for k=1:length( tout )
for i =1:n
yexact(k,i) = u_anal(x(i) , tout( k ) ) ;
end ;
plot( x , yexact( k , : ) , 'r' )
hold on
end ;
% . . .
%C al c ul de l ’ e r r e u r + Graphe de l ’ e r r e u r
% . . .
figure ;
e=ec( yexact , yout , x )