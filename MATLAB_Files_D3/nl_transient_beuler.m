

function [tpoints,r] = nl_transient_beuler(t1,t2,h,out)
% [tpoints,r] = beuler(t1,t2,h,out)
% Perform transient analysis for NONLINEAR Circuits using Backward Euler
% Assume zero initial condition.
% Inputs:  t1 = starting time point (typically 0)
%          t2 = ending time point
%          h  = step size
%          out = output node
% Outputs  tpoints = are the time points at which the output
%                    was evaluated
%          r       = value of the response at above time points
% plot(tpoints,r) should produce a plot of the transient response

global G C b


tpoints = t1:h:t2;
r = zeros(1,length(tpoints));
maxer = 10^(-6);

zs = zeros(size(b));
zs2 = zeros(size(b));

for x=1:length(tpoints)-1
    
    x_d = intmax();
    
    while x_d >= maxer
        fun = f_vector(zs2);
        pi = fun+(G+C/h)*zs2-BTime(tpoints(x+1))-(C/h)*zs;

        nlJ = nlJacobian(zs2);
        pi2 = G+C/h+nlJ;

        x_d2 = -1*inv(pi2)*pi;

        zs2 = zs2+x_d2;
        x_d = norm(x_d2);
    end
    
    r(x+1) = zs2(out);
    zs = zs2;
end




   