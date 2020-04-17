function u=u_anal( x,t)
u=0.5*(1+exp(-6*t))^(1/3 )*(1-tanh ( ( x-3*t ) / 2 ) ) ;
end