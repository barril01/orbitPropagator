clc, clear

orbit = orbitPropagator;

orbit.x_0 = 0.0;
orbit.y_0 = 6378000.0; 
orbit.v_0 = 0.0;
orbit.delta_t = 0.65;

orbit.initializeOrbitPosition;

n = 20155;

[x,y,~] = orbit.runPropagation(orbit,n);

plot(x,y)