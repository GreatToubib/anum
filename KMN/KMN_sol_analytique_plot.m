close all
clear all
% . . .
%Debut du chronometre
% . . .
tic


% . . .
%Variables globales du probleme
% . . .
global x0 xL D1 D2 D3;


% . . .
%Grille spatiale
% . . .
x0= -10.0;
xL=15.0;
dx=0.1;
space=[ x0 : dx : xL ]' ;

% . . .
%Parametres de l’integration temporelle
% . . .
time = [ 0 : 0.5 : 5 ] ;


%Solution analytique
for k=1:length( time )
for i =1:length( space )
yexact(k,i) = analytique_KMN(space(i) , time( k ) ) ;
end ;

plot( space , yexact( k , : ) , 'r' )
title( ' Equation de KMN, solution exacte analytique ' )
hold on
end ;
