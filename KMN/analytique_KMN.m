% Fonction r�solvant la Q1 de mani�re analytique
function[A] = analytique_KMN(t, x)
global v x0;
if x-t>=-2*pi && x-t<=2*pi
  A = (4/3)*(cos((x-t)/4))^2;
else
  A = 0;
end