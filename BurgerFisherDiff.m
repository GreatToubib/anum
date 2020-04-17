function ut = BurgerFisherDiff( t , u )
% . . .
%V a r i a b l e s g l o b a l e s
% . . .
global x0 xL n D1 D2 ;
t
% . . .
%CL a gauche
% . . .
u( 1 ) = u_anal( x0 , t ) ;
% . . .
%CL a d r o i t e
% . . .
u( n ) = u_anal( xL , t ) ;

% . . .
%C o n s t r u c t i o n de u t = a . u2 . ux + uxx + b ( u?u4 )
% . . .
%Terme : uxx
uxx = D2*u ;
%Terme : a . u2 . ux
ux = D1*u ;
u2=u.*u ;
a=2/((1+exp(-6* t ) ) ^ ( 2 / 3 ) ) ;
fx = ux.*u2 ;
fx=a*fx ;
%Terme : b ( u?u4 )
b=2/(1+exp(-6* t ) ) ;
u3=u2.*u ;
f=-u.*(u3-1);
f=f*b ;
%Assemblage de u t
ut = f+fx+uxx ;
% . . .
%F i x a t i o n de s c o n d i t i o n s aux l i m i t e s
% . . .
ut( 1 ) = 0 ;
ut( n ) = 0 ;
