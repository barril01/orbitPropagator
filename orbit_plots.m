%clc, clear

orbit = orbitPropagator;

orbit.x_0 = 0.0;
orbit.y_0 = 6378000.0; 
orbit.v_0 = 0;
orbit.delta_t = 0.1;
orbit.u_0 = 8100;

orbit.initializeOrbitPosition;

n = 65500;

%n = 69000;
n = 140000;

%n = 11340;

%n = 40000;

%[x,y,~] = orbit.runPropagation(orbit,n);

            x   = zeros(n,1);
            y   = zeros(n,1);
            idx = zeros(n,1);
            x(1) = orbit.x_n;
            y(1) = orbit.y_n;            
             for k = 1:n
%                 % Raise Apogee                 
                if k == 1
                    orbit.u_n = orbit.u_n+1500;
                end
%                 % Circularize
%                 if k == 30000
%                     orbit.u_n = orbit.u_n+570;
%                 end
%                 % De-orbit
%                 if k == 1
%                     orbit.u_n = orbit.u_n-3200;
%                 end

%                 if k == 2000
%                     orbit.u_n = orbit.u_n+200;
%                 end
%                 if k == 8000
%                     orbit.u_n = orbit.u_n-150;
%                 end

                idx = k-1;
                orbit.propagateForward();
                x(k+1) = orbit.x_n;
                y(k+1) = orbit.y_n;
%                 if k == 5000
%                     orbit.u_n = 8100;
%                 end
            end

hold on
plot(x,y)
axis square

% % plot([0],[0],'k*')

% % plot(x(end),y(end),'r*')

% % plot(x(1:1500:end),y(1:1500:end),'*r')
