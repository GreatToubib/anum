close all
clear all
clc;

disp('Analyse numérique des équations aux dérivées partielles');
disp('     Simulateur pour l''équation K(2,2)');

%Variables globales du probleme
global m n nx D1 D3 Jpattern solv;

%%%%%%%%%%%%%%%%%%%%%%%%%% variables de test %%%%%%%%%%%%%%%%%%%%%%%
m = 2;
n = 2;
nx = 350;
Jpattern = 0;
solv = 2;
D=8;
%%%%%%%%%%%%%%%%%%%%%%%%%% variables de test %%%%%%%%%%%%%%%%%%%%%%%

%Grille spatiale
x0 = -10;
xL = 15;
dx = (xL-x0)/(nx-1);
x = [x0:dx:xL];
x=x';
space=x;

%Grille temporelle
t0 = 0;
nt = 10;
tF = nt*0.5;
dt = (tF-t0)/(nt);
t = [t0:dt:tF];
t = t';
time=t


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
%Derivee troisième
D3=five_point_centered_D3( space ) ;




%tolerances
reltol = 1e-6;
abstol = 1e-6;

treg=[]
ereg=[]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% répéter l'ago pour différents paramètres %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10 max, car 11 et 12 bug, 
for D = 8:1:8
%for nx = [50 , 100,200, 300,500 ]
%for solv = 1:1:7
%if solv>3
 % for Jpattern = [0,1]
  

tic
disp([' starting avec jpattern ' , num2str(Jpattern) , ' solv: ' , num2str(solv) , 'nbre de points: ' , num2str(nx), 'D1:  ' , num2str(D) ])

%Solution analytique
figure;
for k=1:length( time )
for i =1:nx
yexact(k,i) = analytique_KMN(space(i) , time( k )) ;
end ;

plot(space,yexact(k,:),'r')
title('Equation de KMN, solution exacte analytique')
hold on
end ;


if D == 1
  D1=five_point_biased_upwind_D1( space , V ) ;
elseif D == 2
  D1=five_point_biased_upwind_D1( space , V) ;
elseif D == 3
  D1=five_point_centered_D1( space ) ; 
elseif D == 4
  D1=four_point_biased_upwind_D1(space , V) ;
elseif D == 5
  D1=four_point_biased_upwind_D1(space , V) ;
elseif D == 6
  D1=four_point_upwind_D1(space , V) ;
elseif D == 7
  D1=four_point_upwind_D1(space , V) ;
elseif D == 8
  D1=three_point_centered_D1( space ) ;
elseif D == 9
  D1=three_point_upwind_D1( space , V ) ;
elseif D == 10
  D1=three_point_upwind_D1( space , V) ;
elseif D == 11
  D1=two_point_upwind_D1( space , V ) ;
elseif D== 12
  D1=two_point_upwind_D1( space , V );
end

 % options 
if Jpattern == 1
  %Matrice pour le JPattern
  J = [ spones( eye( nx ) ) + spones(D1) + spones(D3 ) ] ;
  J = spones( J ) ;
  J = sparse( J ) ;
  options = odeset(  'RelTol' ,reltol,  'AbsTol' , abstol, 'stats' ,  'on' , 'JPattern' , J ) ;
else
  options = odeset(  'RelTol' ,reltol,  'AbsTol' , abstol, 'stats' ,  'on') ;
end

  
  
%Solveurs non stiff
if solv == 1
  [ tout , yout ] = ode45( @kmnDiff , time , u , options ) ;
elseif solv == 2
  [ tout , yout ] = ode23( @kmnDiff , time , u , options ) ;
elseif solv == 3
  [ tout , yout ] = ode113( @kmnDiff , time , u , options ) ;
  %Solveurs stiff
elseif solv == 4
  [ tout , yout ] = ode15s( @kmnDiff , time , u , options ) ;
elseif solv == 5
  [ tout , yout ] = ode23s(@kmnDiff , time , u , options ) ;
elseif solv == 6
  [ tout , yout ] = ode23tb( @kmnDiff , time , u , options ) ;
elseif solv == 7
  [ tout , yout ] = ode23t ( @kmnDiff , time , u , options ) ;
end


%Rapatriement des conditions aux limites
for k=1:length( tout )
yout( k , 1 ) = analytique_KMN( x0 , tout( k ) ) ;
yout( k , nx ) = analytique_KMN( xL , tout( k ) ) ;
end


%Fin du chronometre
tcpu = toc
disp([' tcpu avec jpattern ' , num2str(Jpattern) , ' solv: ' , num2str(solv) , 'nbre de points: ' , num2str(nx), 'D1:  ' , num2str(D) ])


%Affichage de la solution analytique VS solution numerique
plot( space , yout , '.-k' ) ;
xlabel( 'space' ) ;
ylabel( 'u(x,t)' ) ;
Jpattern 
solv
nx
title( [' Simulateur KMN avec jpattern ' , num2str(Jpattern) , ' solv: ' , num2str(solv) , 'nbre de points: ' , num2str(nx) ])
hold on


%Calcul de l’erreur moyenne + Graphe de l’erreur
figure ;
e=ec_KMN( yexact , yout , space )

treg=[treg, tcpu]
ereg=[ereg, e]
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fin de répéter l'algo pour différents paramètres %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

treg=treg'
ereg=ereg'
treg=[treg,ereg]

