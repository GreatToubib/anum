function ut = kmnDiff( time , u )
% . . .
%variables globales
% . . .
global nx D1 D3;
time
% . . .
%CL a gauche
% . . .
x0 = -2*pi + time;
xL = 2*pi + time;
u(1) = analytique_KMN( x0 , time ) ;
% . . .
%CL a droite
% . . .

u(nx) = analytique_KMN( xL , time ) ;



% . . .
% Thomas : Construction de ut = a.u2.ux + uxx + b( u*u4 )
%KMN : Construction de ut = -u2.ux - u2.uxxx 
% . . .
%Terme : u2
u2=u.*u;

%terme : uxxx
u2xxx = D3*u2;


%Terme : u2.ux

u2x = D1*u2;

%Assemblage de ut
ut = - u2x - u2xxx;
% . . .
%Fixation des conditions aux limites
% . . .
ut( 1 ) = 0 ;
ut( nx ) = 0 ;
