    close all
    clear variables global
    global mu
    global n z0 zL D2 D1
    
%
%   grille spatiale
%
    z0 = 0;
    zL = 1;
    n = 2001;
    dz = (zL - z0)/(n-1);
    z = (z0:dz:zL)';
%
%   matrices de différentiation
%
   D1 = two_point_upwind_D1(z,1);
   D2 = three_point_centered_D2(z);
%
%   constantes du problème
%
    mu = 0.005;
%
%   conditions initiales
%
    x = zeros(1,n);
    for i = 1:n
        x(i) = burgers_exact(z(i),0);
    end
%
%   instants de visualisation
%
    dt = .1;
    time = (0:dt:1);
    nt = length(time);
%
%   intégration temporelle
%
    [timeout,yout]= ode45(@burgerspdes,time,x);
    
    figure
    
    hold
    plot(z,yout,'.-k')
    yexact = zeros(1,n);
    for k = 1:length(timeout)
        for i = 1:n
            yexact(i) = burgers_exact(z(i),time(k));
        end
        plot(z,yexact,'r')
    end
