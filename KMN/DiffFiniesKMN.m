close all
clear all
clc;

disp('Analyse numérique des équations aux dérivées partielles');
disp('     Simulateur pour l''équation K(2,2)');

% . . .
%Debut du chronometre
% . . .
tic


% . . .
%Variables globales du probleme
% . . .
global m n nx D1 D3;
m = 2;
n = 2;

% . . .
%Grille spatiale
% . . .
x0 = -10;
xL = 15;
nx = 50;
dx = (xL-x0)/(nx-1);
x = [x0:dx:xL];
x=x';
space=x;

% . . .
%Grille temporelle
% . . .
t0 = 0;
nt = 10;
tF = nt*0.5;
dt = (tF-t0)/(nt);
t = [t0:dt:tF];
t = t';
time=t

%Solution analytique
for k=1:length( time )
for i =1:nx
yexact(k,i) = analytique_KMN(space(i) , time( k )) ;
end ;

plot(space,yexact(k,:),'r')
title('Equation de KMN, solution exacte analytique')
hold on
end ;




%%%%%%%%%%%%%%%%%%%%%%%%%% simulateur numérique %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% . . .
%Conditions initiales
% . . .
u = zeros(1,nx);
for i = 1:nx
    u(i) = analytique_KMN(space(i),0);
end
u = u';




% . . .
%Schemas de differences finies pour les derivees spatiales
% . . .

V = 1;
%permet de déterminer si D doit fonctionner
%avec une convection vers la droite (v > 0) ou vers la gauche (v < 0)

%Derivee premiere
%D1=f ive_poin t_biased_upwind_D1( space , V ) ;
%D1=f ive_poin t_biased_upwind_D1( space , V) ;
%D1=f ive_poin t_centered_D1( space ) ;
%D1=four_point_biased_upwind_D1(space , V) ;
%D1=four_point_biased_upwind_D1(space , V) ;
%D1=four_point_upwind_D1(space , V) ;
%D1=four_point_upwind_D1(space , V) ;
D1=three_point_centered_D1 ( space ) ;
%D1=three_point_upwind_D1 ( space , V ) ;
%D1=three_point_upwind_D1 ( space , V) ;
%D1=two_point_upwind_D1 ( space , V ) ;
%D1=two_point_upwind_D1 ( space , V );

%Derivee seconde
D2=five_point_centered_D2 ( space ) ;
%D2=three_point_centered_D2 ( space ) ;

%Derivee troisième
D3=five_point_centered_D3 ( space ) ;


% . . .
%Matrice pour le JPattern
% . . .
J = [ spones( eye( nx ) ) + spones(D1) + spones(D3 ) ] ;
J = spones( J ) ;
J = sparse( J ) ;

% . . .
%Parametres de l’integration temporelle
% . . .
reltol = 1e-6;
abstol = 1e-6;
options = odeset(  'RelTol' ,reltol,  'AbsTol' , abstol, 'stats' ,  'on') ;
%options = odeset(  'RelTol' ,reltol,  'AbsTol' , abstol, 'stats' ,  'on' , 'JPattern' , J ) ;

% . . .
%Integration temporelle
% . . .

%Solveurs non stiff

[ tout , yout ] = ode45( @kmnDiff , time , u , options ) ;
%[ tout , yout ] = ode23( @kmnDiff , time , u , options ) ;
%[ tout , yout ] = ode113( @kmnDiff , time , u , options ) ;
%Solveurs stiff
%[ tout , yout ] = ode15s( @kmnDiff , time , u , options ) ;
%[ tout , yout ] = ode23s(@kmnDiff , time , u , options ) ;
%[ tout , yout ] = ode23tb( @kmnDiff , time , u , options ) ;
%[ tout , yout ] = ode23t ( @kmnDiff , time , u , options ) ;


% . . .
%Rapatriement des conditions aux limites
% . . .
for k=1:length( tout )
yout( k , 1 ) = analytique_KMN( x0 , tout( k ) ) ;
yout( k , nx ) = analytique_KMN( xL , tout( k ) ) ;
end


% . . .
%Fin du chronometre
% . . .
tcpu = toc
% . . .
%Affichage de la solution analytique VS solution numerique
% . . .
%Solution numerique

plot( space , yout , '.-k' ) ;
xlabel( 'space' ) ;
ylabel( 'u(x,t)' ) ;
title( ' Equation de KMN : Differences Finies, sol numerique ' )
hold on
% . . .
%Calcul de l ’ erreur + Graphe de l ’ erreur
% . . .
figure ;
e=ec_KMN( yexact , yout , space )