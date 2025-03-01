close all;
%clear all;
clc;

disp('Analyse num�rique des �quations aux d�riv�es partielles');
disp('     Simulateur pour l''�quation K(2,2)');

global m n nx D1 D2 D3 Jpattern solv;


%%%%%%%%%%%%%%%%%%%%%%%%%% variables de test %%%%%%%%%%%%%%%%%%%%%%%
m = 2;
n = 2;
nx = 250;
x0 = -10;
xL = 15;
Jpattern = 1;
solv = 1;
D=8;
plotgraph=1;
ploterr=0;
tol=1e-6;
V=1;
stgw=1;
treg=[];
ereg=[];

%%%%%%%%%%%%%%%%%%%%%%%%%% grille temporelle %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t0 = 0;
nt = 10;
tF = nt*0.5;
dt = (tF-t0)/(nt);
t = t0:dt:tF;
t = t';
time=t;


%%%%%%%%%%%%%%%%%%%%%%%%% r�p�tition de l'algo en faisant varier un param�tre %%%%%%%%%%%%%%%%%
for stgw = [0 1 2 3] 
    
%%%%%%%%%%%%%%%%%%%%%%%%% lancement chronom�tre %%%%%%%%%%%%%%%%%
tic
disp([' starting avec jpattern ' , num2str(Jpattern) , ' solv: ' , num2str(solv) , ' nbre de points: ' , num2str(nx), ' D1:  ' , num2str(D), ' stgw:  ' , num2str(stgw) ])


%%%%%%%%%%%%%%%%%%%%%%%%% grille spatiale selon nx %%%%%%%%%%%%%%%%%
dx = (xL-x0)/(nx-1);
x = x0:dx:xL;
x=x';
space=x;

%%%%%%%%%%%%%%%%%%%%%%%%% Conditions initiales %%%%%%%%%%%%%%%%%
u = zeros(1,nx);
for i = 1:nx
    u(i) = analytique_KMN(space(i),0);
end
u = u';

%%%%%%%%%%%%%%%%%%%%%%%%% tol�rances %%%%%%%%%%%%%%%%%
reltol = tol;
abstol = tol;


%%%%%%%%%%%%%%%%%%%%%%%%% solution analytique (et plot) %%%%%%%%%%%%%%%%%
if plotgraph==1
    figure;
end;
for k=1:length( time )
for i =1:nx
yexact(k,i) = analytique_KMN(space(i) , time( k )) ;
end ;
if plotgraph==1
    plot(space,yexact(k,:),'r')
    %title('Equation de KMN, solution exacte analytique')
    hold on
end;
end ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Schemas de differences finies %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% choix de D1 %%%%%%%%%%%%%%%%%
if D == 1
  D1=five_point_biased_upwind_D1( space , V ) ;
elseif D == 2
  D1=five_point_biased_upwind_D1( space , -V) ;
elseif D == 3
  D1=five_point_centered_D1( space ) ; 
elseif D == 4
  D1=four_point_biased_upwind_D1(space , V) ;
elseif D == 5
  D1=four_point_biased_upwind_D1(space , -V) ;
elseif D == 6
  D1=four_point_upwind_D1(space , V) ;
elseif D == 7
  D1=four_point_upwind_D1(space , -V) ;
elseif D == 8
  D1=three_point_centered_D1( space ) ;
elseif D == 9
  D1=three_point_upwind_D1( space , V ) ;
elseif D == 10
  D1=three_point_upwind_D1( space , -V) ;
elseif D == 11
  D1=two_point_upwind_D1( space , V ) ;
elseif D== 12
  D1=two_point_upwind_D1( space , -V );
end
D2=five_point_centered_D2( space ) ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% choix de D3 %%%%%%%%%%%%%%%%%
if stgw==0
    D3=five_point_centered_D3( space ) ;
elseif stgw==1
    D3=D1*D1*D1 ;
elseif stgw==2
    D3=D2*D1 ;
elseif stgw==3
    D3=D1*D2 ;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% definition des options (JPattern ou non) %%%%%%%%%%%%%%%%%
if Jpattern == 1
  %Matrice pour le JPattern
  J = spones( eye( nx ) ) + spones(D1) + spones(D3 ) ;
  J = spones( J ) ;
  J = sparse( J ) ;
  options = odeset(  'RelTol' ,reltol,  'AbsTol' , abstol, 'stats' ,  'on' , 'JPattern' , J ) ;
else
  options = odeset(  'RelTol' ,reltol,  'AbsTol' , abstol, 'stats' ,  'on') ;
end

  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% choix de solveur(int�grateur) %%%%%%%%%%%%%%%%%
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rapatriement des CL %%%%%%%%%%%%%%%%%
for k=1:length( tout )
yout( k , 1 ) = analytique_KMN( x0 , tout( k ) ) ;
yout( k , nx ) = analytique_KMN( xL , tout( k ) ) ;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fin chrono %%%%%%%%%%%%%%%%%
tcpu = toc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot graph analytique vs numerique %%%%%%%%%%%%%%%%%
if plotgraph==1
    plot( space , yout , '.-k' ) ;
    xlabel( 'space' ) ;
    ylabel( 'u(x,t)' ) ;
    %title( [' Simulateur KMN avec int�grateur ' , num2str(solv) , ' ,nbre de points: ' , num2str(nx), ' ,Jpattern: ' , num2str(Jpattern)  ])
    hold on
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% calcul d'ec + plot %%%%%%%%%%%%%%%%%
e=ec_KMN( yexact , yout , space, ploterr );


%%%%%%%%%%%%%%%%%%%%%%%%%%%% enregistrement des performances de chaque simulation %%%%%%%%%%%%%%%%%
treg=[treg, tcpu];
ereg=[ereg, e];



end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fin de la simulation avec les param�tres fix�s %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%% mettre tcpu et ec dans un tableau data en 2 col %%%%%%%%%%%%%%%%%%%%%%%% 
treg=treg';
ereg=ereg';
data=[treg,ereg];




