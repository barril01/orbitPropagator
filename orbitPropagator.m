classdef orbitPropagator < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        x_0     double
        y_0     double
        r_e     double = 6378144 % Default to radius of the earth in meters
        g       double = 9.8     % Default to meters. Gravity on earth.
        u_0     double = 8100
        v_0     double
        delta_t double
        n       int64  = 20155
        x_n     double
        y_n     double
        r_n     double
        g_n     double
        u_n     double
        v_n     double
        q       double = 0
        x_norm  double
        y_norm  double
    end

    methods
        function obj = initializeOrbitPosition(obj)
            obj.x_n = obj.x_0;
            obj.y_n = obj.y_0;
            obj.r_n = rssq([obj.x_0,obj.y_0]);
            obj.u_n = obj.u_0;
            obj.v_n = obj.v_0;
        end

        function obj = propagateForward(obj)
           
            obj.g_n = obj.g * (obj.r_e/obj.r_n)^2;

            u_n_plus_1 = obj.u_n - obj.g_n * obj.u_n * ((obj.delta_t^2)/(2*obj.r_n));
            v_n_plus_1 = obj.v_n - obj.g_n * obj.delta_t ...
                         + obj.g_n * (obj.u_n^2) * (obj.delta_t^3)/(3*(obj.r_n^2));

            a = atan(v_n_plus_1/u_n_plus_1);
            v_mag = rssq([u_n_plus_1,v_n_plus_1]);

            dx = obj.u_n*obj.delta_t - obj.g_n * obj.u_n*((obj.delta_t^3)/(6*obj.r_n));
            dy = obj.v_n*obj.delta_t - 0.5*obj.g_n * (obj.delta_t^2)...
                 + obj.g_n * ( obj.u_n^2) * ((obj.delta_t^4)/(12*obj.r_n^2));

            ds = rssq([dx,dy]);

            q_new = obj.u_n * obj.delta_t / obj.r_n;

            obj.x_n = obj.x_n + ds* sin((pi/2-obj.q)+dy/dx);
            obj.y_n = obj.y_n - ds* cos((pi/2-obj.q)+dy/dx);
            obj.r_n = rssq([obj.x_n,obj.y_n]);
            obj.x_norm = obj.x_n/obj.r_e;
            obj.y_norm = obj.y_n/obj.r_e;

            obj.q = q_new + obj.q;

            obj.u_n = v_mag * cos(a + q_new);
            obj.v_n = v_mag * sin(a + q_new);
            
        end
    end
    methods (Static)
        
        function [x,y,idx] = runPropagation(obj,n)
            x   = zeros(n,1);
            y   = zeros(n,1);
            idx = zeros(n,1);
            x(1) = obj.x_n/obj.r_e;
            y(1) = obj.y_n/obj.r_e;            
            for k = 1:n
                idx = k-1;
                obj.propagateForward();
                x(k+1) = obj.x_norm;
                y(k+1) = obj.y_norm;
            end
        end

    end
end


